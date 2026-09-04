#include <QCoreApplication>
#include <QTimer>
#include <QDebug>
#include <QSettings>
#include <QFile>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonValue>
#include <QDateTime>
#include <QMap>
#include <QSet>
#include <QProcess>
#include <QDBusConnection>
#include <QDBusMessage>
#include <QDBusConnectionInterface>

class Daemon : public QObject
{
    Q_OBJECT
public:
    Daemon(QObject *parent = nullptr)
        : QObject(parent), _settings("harbour-thakir_prayer_times", "net.tanghus.thakir_prayer_times.sailfish")
    {
        loadSchedule();

        // Try to register DBus interface so UI can call us
        bool registered = false;
        if (QDBusConnection::sessionBus().isConnected()) {
            registered = QDBusConnection::sessionBus().registerService("net.tanghus.thakir.daemon");
            QDBusConnection::sessionBus().registerObject("/net/tanghus/thakir/Daemon", this, QDBusConnection::ExportAllSlots);
            qDebug() << "Registered on session bus:" << registered;
        }
        if (!registered && QDBusConnection::systemBus().isConnected()) {
            registered = QDBusConnection::systemBus().registerService("net.tanghus.thakir.daemon");
            QDBusConnection::systemBus().registerObject("/net/tanghus/thakir/Daemon", this, QDBusConnection::ExportAllSlots);
            qDebug() << "Registered on system bus:" << registered;
        }

        // Periodic check
        QTimer *timer = new QTimer(this);
        connect(timer, &QTimer::timeout, this, &Daemon::checkSchedule);
        timer->start(60 * 1000); // every minute

        // Also run an immediate check at startup
        QTimer::singleShot(1000, this, &Daemon::checkSchedule);
    }

public slots:
    // DBus callable methods from UI
    void updateSchedule() {
        qDebug() << "DBus: updateSchedule called";
        loadSchedule();
        checkSchedule();
    }

    void setFavorite(const QString &name, bool enabled) {
        qDebug() << "DBus: setFavorite" << name << enabled;
        _settings.setValue(QString("favorites/%1").arg(name), enabled);
    }

private:
    void loadSchedule() {
        _schedule.clear();
        // Primary: try JSON file in deployed data dir
        const QString dataPath = "/usr/share/harbour-thakir_prayer_times";
        const QString jsonFile = dataPath + "/prayer_times.json";
        if (QFile::exists(jsonFile)) {
            QFile f(jsonFile);
            if (f.open(QIODevice::ReadOnly)) {
                QJsonDocument doc = QJsonDocument::fromJson(f.readAll());
                if (doc.isObject()) {
                    QJsonObject obj = doc.object();
                    for (const QString& key : obj.keys()) {
                        QJsonValue v = obj.value(key);
                        if (v.isString()) {
                            QDateTime t = QDateTime::fromString(v.toString(), Qt::ISODate);
                            if (t.isValid()) {
                                _schedule.insert(key, t);
                            }
                        }
                    }
                }
            }
        }

        // Secondary: try reading from QSettings if stored as JSON string
        if (_schedule.isEmpty()) {
            QVariant var = _settings.value("prayerTimesJson");
            if (var.isValid() && var.toString().size() > 0) {
                QJsonDocument doc = QJsonDocument::fromJson(var.toString().toUtf8());
                if (doc.isObject()) {
                    QJsonObject obj = doc.object();
                    for (const QString& key : obj.keys()) {
                        QDateTime t = QDateTime::fromString(obj.value(key).toString(), Qt::ISODate);
                        if (t.isValid()) _schedule.insert(key, t);
                    }
                }
            }
        }

        qDebug() << "Loaded schedule entries:" << _schedule.keys();
    }

    void checkSchedule() {
        const QDateTime now = QDateTime::currentDateTimeUtc();
        for (auto it = _schedule.begin(); it != _schedule.end(); ++it) {
            QString name = it.key();
            QDateTime t = it.value();
            if (!t.isValid()) continue;
            // Compare in UTC to avoid timezone pitfalls; assumes schedule stored in UTC
            if (t.toUTC() <= now) {
                // Check if already notified for this datetime
                QString key = QString("lastNotified/%1").arg(name);
                QDateTime last = _settings.value(key).toDateTime();
                if (last.isValid() && last >= t) {
                    continue; // already notified
                }

                // Send notification and play sound
                sendNotification(QString("Prayer: %1").arg(name), QString("Time: %1").arg(t.toLocalTime().toString()));
                playSoundForPrayer(name);

                // Mark as notified
                _settings.setValue(key, t);
            }
        }
    }

    void sendNotification(const QString &summary, const QString &body) {
        // Try session DBus notification first
        bool sent = false;
        if (QDBusConnection::sessionBus().isConnected()) {
            QDBusMessage msg = QDBusMessage::createMethodCall("org.freedesktop.Notifications",
                                                              "/org/freedesktop/Notifications",
                                                              "org.freedesktop.Notifications",
                                                              "Notify");
            QList<QVariant> args;
            args << "Thakir" << (uint)0 << QString() << summary << body << QStringList() << QVariantMap() << (int)10000;
            msg.setArguments(args);
            QDBusMessage reply = QDBusConnection::sessionBus().call(msg);
            if (!reply.isError()) {
                sent = true;
            }
        }
        // Fallback to notify-send if available
        if (!sent) {
            QProcess::execute("notify-send", QStringList() << summary << body);
        }
    }

    void playSoundForPrayer(const QString &name) {
        // Look for a matching sound file in deployed sounds dir
        const QString soundDir = "/usr/share/harbour-thakir_prayer_times/sounds";
        QString candidate = soundDir + "/" + name.toLower() + ".ogg";
        if (!QFile::exists(candidate)) {
            // fallback generic alarm
            candidate = soundDir + "/alarm.ogg";
        }
        if (!QFile::exists(candidate)) {
            qDebug() << "No sound file found for" << name;
            return;
        }

        // try paplay, aplay, gst-play, play
        QStringList players = {"paplay", "aplay", "gst-play-1.0", "play"};
        for (const QString &p : players) {
            if (QProcess::execute("which", QStringList() << p) == 0) {
                QProcess::startDetached(p, QStringList() << candidate);
                return;
            }
        }

        qDebug() << "No player found to play" << candidate;
    }

private:
    QSettings _settings;
    QMap<QString, QDateTime> _schedule;
};

int main(int argc, char *argv[])
{
    QCoreApplication a(argc, argv);

    qDebug() << "Thakir daemon starting";
    Daemon d;

    return a.exec();
}

#include "main.moc"
