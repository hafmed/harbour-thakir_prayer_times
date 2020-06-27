
//-----------------

#ifndef calcul_H
#define calcul_H

#include <QObject>
#include <QtMultimedia>

#include "Settings.hpp"
#include "prayer.h"
#include "hijri.h"

class calcul : public QObject
{
    Q_OBJECT
    Q_PROPERTY( QString helloWorld READ helloWorld WRITE setHelloWorld NOTIFY helloWorldChanged )

public:
    explicit calcul(QObject *parent = 0);
    ~calcul();

    Settings settings;

    QDateTime now ;

    Prayer ptList[6];
    int i, deg, min;
    double sec;

    Location loc;
    Method conf;
    Date date;

    Prayer imsaak;
    Prayer nextImsaak;
    Prayer nextFajr;

    QString cityName;
    double degreeLat;
    double degreeLong;
    double seaLevel;
    double gmtDiff;

    double qibla;

    int tm_hour;
    int tm_min;
    int tm_sec;

    int next_prayer_id;
    int cur_minutes;
    int next_minutes;
    int next_old;
    int difference;

    int hours;
    int minutes;

    int diffminuterestente;
    int diffminuteentreoldandnext;
    int pourcentminut;
    int pourcentminutExacte;

    QString remaining_time;
    QString now_prayer_text;
    QString next_prayer_text;

    int Temps_Salat_Old_en_min;
    int Temps_Salat_Next_en_min;

    //---7-1-2016--------
    QString outputtexhigri;
    QString strDaysEvent;

    bool boolisRamathan;
    bool boolisJommoaa;

    //-------------------
    int volumeAthan;
    int athanIsPlaying;

    //-----------------

    bool alertehaseplayed;
    bool athanhaseplayed;
    bool athanHasStoped;
    bool profileSwitcherhaseplayed;
    bool profileSwitcherbackhaseplayed;

    bool athkarSabahHasePlayed;
    bool athkarMassaaHasePlayed;

    //-----------------

    int formatNumberHindiActiveChecked;
    //-----10-6-2016-----
    QString filemaneCategorie;
    int numberligneMax;
    int numberligne;
    int random_integer_hikma;
    int j;
    QString line;
    //-------29-11-2018------------
    int spinBox_correction_hijri;
    int minAlerteBeforeAthanvalue;
    int silenctAfterAthanActiveChecked;
    int silentDuringTarawihChecked;
    int silentDuringSalatJommoaaChecked;
    int run_periodsActiveSilent;
    int minSilentActiveBeforAthanJommoaavalue;
    int minSilentActiveAfterAthanvalue;

    int minSilentDuringTarawihvalue;
    int minSilentActiveAfterAthanJommoaavalue;
    int minSilentActivedurationvalue;
    int run_periodsBackModeSilent;

    int playAthkarSabahChecked;
    int minplayAthkarSabah;
    int run_periodsPlayAthkarSabah;

    int playAthkarMassaChecked;
    int minplayAthkarMassa;

    //-----------------------------

    //Q_INVOKABLE void displayTimes(double lat, double lon, char  *cityName, int day, int month, int year, int gmtDiff, int dst, int method);

    Q_INVOKABLE void InitailTimer();
    Q_INVOKABLE void PrayerTimes_Calculer();
    Q_INVOKABLE void stopAdhan();

    Q_INVOKABLE int hikmatooum();

    Q_INVOKABLE QString displayTimes_nextfajr_hhmm();
    Q_INVOKABLE QString displayTimes_imsaak_hhmm();

    Q_INVOKABLE double getTimeZone();
    Q_INVOKABLE bool getDaylightSavingTime();
    Q_INVOKABLE QString getLanguageUIofPhone();
    Q_INVOKABLE QString getCountryInPhone();

    Q_INVOKABLE QString displayTimes_time_end_Isha_hhmm();
    Q_INVOKABLE QString displayTimes_timebegin_Tholoth_akhir_hhmm();

    Q_INVOKABLE double qibla_HAF();

    Q_INVOKABLE double time_now_hours();
    Q_INVOKABLE double timesunrise_hours();
    Q_INVOKABLE double timemaghrib_hours();

    Q_INVOKABLE QString getoutputtexhigri(int index_spinBox_correction_hijri);
    Q_INVOKABLE QString getstrDaysEvent(int index_spinBox_correction_hijri);
    Q_INVOKABLE bool isRamathan(int index_spinBox_correction_hijri);
    Q_INVOKABLE bool isJommoaa();

    Q_INVOKABLE int statePlayingAdhan(QMediaPlayer::State isPlaying);

    Q_INVOKABLE void profileSwitcher();
    Q_INVOKABLE void profileSwitcherback();

    Q_INVOKABLE QString displayTimes_hhmm(int i);

    Q_INVOKABLE bool isPrayerExtrem(int indexprayer);

    Q_INVOKABLE QString remaining_time_haf();
    Q_INVOKABLE int remaining_time_haf_Sec();
    Q_INVOKABLE int remaining_time_haf_Sec_Next();

    Q_INVOKABLE void Debut();

    Q_INVOKABLE QString now_salat_haf();
    Q_INVOKABLE QString next_salat_haf();

    Q_INVOKABLE int next_salat_haf_id();

    Q_INVOKABLE int remaining_ProgressBar_haf();

    Q_INVOKABLE void getPrayerTimes_and_qibla_HAF();

    Q_INVOKABLE bool locationEnabled();

    Q_INVOKABLE int passed_time_from_oldSalat_Sec();

    Q_INVOKABLE QString formatNumberHindi(float value);
    Q_INVOKABLE QString formatNumberArab(QString value);


    Q_INVOKABLE void formatNumberArabic();
    
    Q_INVOKABLE QString Hikkmato_Youm();

    //-----1-12-2018-----
    Q_INVOKABLE int hafplaybackStatus();
    Q_INVOKABLE void athkarplayDurationPosition(qint64 position);
    qint64 &position( );
    qint64 &duration( );
    //-------------------

Q_SIGNALS:
    void helloWorldChanged();

protected:
    QString helloWorld() { return m_message; }
    void setHelloWorld(QString msg) { m_message = msg; Q_EMIT helloWorldChanged(); }

    QString m_message;

private:
    QMediaPlayer * player;
    QTimer * timer;
    QTimer * timerInitial;

    QTimer * playhaftimers;

    sDate mydate;

    //! initially active phone profile
    QString itsInitialProfile;
    QString currentProfile;

    qint64 iPosition;
    qint64 iDuration;

public slots:
    void playAdhan();
    void playAdhanUrl(QString url);
    void hijridate(int index_spinBox_correction_hijri);
    void playAlert();

    void playathkarSabah();
    void playathkarMassaa();

    void haftimersplayall();
    void hafprofileSwitcherReset();
    void hafprofileSwitcherBackReset();
    int remaining_time_timesunrise_mn();

    void allplayedReset();
    void playathkar();
    void stopAthkar();
    void pauseAthkar();
    void justeplay();


//----------
signals:
  void sendToQml(int count);
  void sendToQmlAthanIsPlaying();
  void sendToQmlAthanIsStoped();
  void sendToQmlRemainTimeZero();
  void sendToQmlRemainTimeNotZero();

  void sendToQmltempAlert(int count, bool isactive);
  void sendToQmltempAthan(int count, bool isactive);
  void sendToQmltempActiveSilent(int count, bool isactive);
  void sendToQmltempReturntoNormalMode(int count, bool isactive);
  void sendToQmlplayhaftimersisActive(bool count);
  void sendToQmltempRemainingTime(QString count);

  void positionChanged(qint64 iPosition );
  void sendToQmlDurationMedia(int durat);


public slots:
  void receiveFromQml(int count);

private slots:
    void setPosition(qint64 position);
    void setDuration(qint64 duration);
};

#endif // calcul_H

