#include "Settings.hpp"
#include <QSettings>
#include <QDebug>
#include <QStandardPaths>
#include <QGuiApplication>
#include <QFileInfo>
#include <QDir>

Settings::Settings() {
    /////migrateSettings(); //to delete later
    //qDebug() << "QStandardPaths::AppConfigLocation="<< QStandardPaths::writableLocation(QStandardPaths::AppConfigLocation);
    settings= new QSettings(QStandardPaths::writableLocation(QStandardPaths::AppConfigLocation)+"/"
                                   + QCoreApplication::applicationName() + ".conf" , QSettings::NativeFormat);
}
//void Settings::migrateSettings()
//{
//    // migration path for old location for SFOS, since sandboxing it changed
//    // see https://forum.sailfishos.org/t/migrating-configuration-and-data-files-for-sandboxed-apps/8866
//    QString oldConfigFileStr =
//            QStandardPaths::standardLocations(QStandardPaths::ConfigLocation).first() +
//            "/" + "org.hafsoftdz/thakir_prayer_times/harbour-thakir_prayer_times.conf";
//    QString newConfigFileStr =
//            QStandardPaths::standardLocations(QStandardPaths::AppConfigLocation).first() +
//            "/" + QCoreApplication::applicationName() + ".conf";

//    if((!QFileInfo(newConfigFileStr).exists() && !QDir(newConfigFileStr).exists()) &&
//            (QFileInfo(oldConfigFileStr).exists() && !QDir(oldConfigFileStr).exists())) {
//        QFile::rename(oldConfigFileStr, newConfigFileStr);
//        //qDebug() << "ok migrateSettings------------------------------------------------------=";
//    }
//}

QString Settings::getValueFor(const QString &objectName, const QString &defaultValue) {
    // If no value has been saved, return the default value.
    if (settings->value(objectName).isNull()) {
        return defaultValue;
    }
    // Otherwise, return the value stored in the settings object.
    return settings->value(objectName).toString();
}

void Settings::saveValueFor(const QString &objectName, const QString &inputValue) {
    // A new value is saved to the application settings object.
    settings->setValue(objectName, QVariant(inputValue));
}

//--------- HAF 5-1-2016--------------
void Settings::romoveValueFor(const QString &objectName) { 
    settings->remove(objectName);
}
void Settings::clearAll() {
    settings->clear();
}
//-------------------------------------
Settings::~Settings() {
}
