#include "calcul.h"
#include <sailfishapp.h>
#include <QDir>
#include <QFile>
/* pour srand */
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <QTimeLine>

#include "prayer.h"
#include "hijri.h"

#include "Settings.hpp"
#include <QTimeZone>
#include <QDebug>
#include <QLocale>

#include <QtMultimedia>
#include <QMediaPlaylist>
#include <QProcess>

#include <QtDBus>

#define PHONE_PROFILE_SILENT       "silent"
#define PHONE_PROFILE_GENERAL      "general"

calcul::calcul(QObject *parent) :
    QObject(parent),
    m_message("")
{
    //------------HAF 27-11-2015--------------
    QString locale = QString(QLocale::system().name()).left(2);
    if (locale.length() < 2) locale = "en";

    //qDebug() << "locale================"<< locale;

    settings.saveValueFor("locale", locale);
    //----------------------------------------
    player = new QMediaPlayer;
    player->setVolume(95);

    player->setMedia(SailfishApp::pathTo("sounds/Adhan/adhan_court.mp3"));

    QTimer::singleShot(1000, this, SLOT(Debut()));
    //----------------------HAF 19-02-2022----------------------------
    playlist = new QMediaPlaylist;
    playerQuran = new QMediaPlayer;
    playerQuran->setPlaylist(playlist);
    playlist->setCurrentIndex(1);

    connect(playlist, SIGNAL(currentIndexChanged(int)), this, SLOT(indexplaylistQuran(int)));
    connect(playerQuran, SIGNAL(stateChanged(QMediaPlayer::State)), this, SLOT(statePlayingQuran(QMediaPlayer::State)));
    connect(playerQuran, SIGNAL(error(QMediaPlayer::Error)), this, SLOT(playingQuranError(QMediaPlayer::Error)));
    //----------------------HAF 1-4-2016 -----------------------------
    connect(player, SIGNAL(stateChanged(QMediaPlayer::State)), this, SLOT(statePlayingAdhan(QMediaPlayer::State)));
    //----------------HAF 1-6-2016-------
    QString formatNumberHindichecked=settings.getValueFor("formatNumberHindiActiveChecked", "");

    if (formatNumberHindichecked=="0") {
        QLocale::setDefault(QLocale(QLocale::Arabic, QLocale::SaudiArabia));
    }else{
        formatNumberArabic();
    }
    //-------------

    allplayedReset();

    playhaftimers = new QTimer();
    playhaftimers->setTimerType(Qt::VeryCoarseTimer);
    connect(playhaftimers, SIGNAL(timeout()), this, SLOT(haftimersplayall()));
    playhaftimers->setInterval(1000 * 60);
    playhaftimers->start();

    //----------------------------
    haftimersplayall();
    connect(player, SIGNAL(positionChanged(qint64)), this, SLOT(athkarplayDurationPosition(qint64)));

    QObject::connect(player, &QMediaPlayer::positionChanged, this, &calcul::setPosition);
    QObject::connect(player, &QMediaPlayer::durationChanged, this, &calcul::setDuration);
}
//------------------
void calcul::playingQuranError(QMediaPlayer::Error errorplayingQuran)
{
    //qDebug() << "-------QMediaPlayer::ResourceError ----------"<<errorplayingQuran<<"-----" ;
    if (errorplayingQuran==QMediaPlayer::ResourceError) {
        hasResourceErrorplayingQuran=true;
        emit sendToQmlErrorplayingQuran();
    }else{
        hasResourceErrorplayingQuran=false;
    }
    //qDebug() << "-------hasResourceErrorplayingQuran="<<hasResourceErrorplayingQuran<<"-----" ;
}

//----Read xml 1-3-2022--------------
void calcul::readxml(QString pathXmlTranslat)
{
    QFile data(pathXmlTranslat);
    data.open(QIODevice::Text | QIODevice::ReadOnly);
    QString dataText = data.readAll();
    //----- remove invalid xml comments that contain double dashes(--) from an xml file? HAF 29-02-2022
    dataText.replace(QString("# --------------------------------------------------------------------"),
                     QByteArray("# ====================================================================")); // replace text in string
    //---------------------
    data.close();

    QString pathXmlTranslatModifed=pathXmlTranslat;
    pathXmlTranslatModifed.remove(pathXmlTranslatModifed.length()-pathXmlTranslat.length());
    QFile outFile(pathXmlTranslatModifed);
    if( !outFile.open( QFile::WriteOnly | QFile::Truncate ) )
    {
        qDebug( "Failed to open file for writing." );
        return ;
    }
    //qDebug() << "pathXmlTranslatModifed"<<pathXmlTranslatModifed ;
    QTextStream stream( &outFile );
    stream << dataText;
    outFile.close();
}
//-----------------------------------
int calcul::statePlayingQuran(QMediaPlayer::State isPlaying)
{
    if (isPlaying==QMediaPlayer::PlayingState) {
        QuranIsPlaying=1;
        emit sendToQmlQuranIsPlaying();
    }else{
        QuranIsPlaying=0;
        hasResourceErrorplayingQuran=false;
        emit sendToQmlQuranIsStoped();
    }
    return QuranIsPlaying;
}
void calcul::indexplaylistQuran(int positionindeAyaPlaying)
{
  if (!hasResourceErrorplayingQuran) {
         emit sendToQmlindexplayAyaChanged(positionindeAyaPlaying);
  }
}
void calcul::stopplayingQuran()
{
    playerQuran->stop();
}
void calcul::pauseplayingQuran()
{
    playerQuran->pause();
}
void calcul::clearplaylist()
{
    playlist->clear();
}
void calcul::addAoutho()
{
    playlist->addMedia(SailfishApp::pathTo("sounds/Quran/001000.mp3")); //Aoutho
}
void calcul::addAouthoBassmalla()
{
    playlist->addMedia(SailfishApp::pathTo("sounds/Quran/001000.mp3")); //Aoutho
    playlist->addMedia(SailfishApp::pathTo("sounds/Quran/001001.mp3")); //Bassm Allah
}
void calcul::addAyatoQuranplay(QString pathAyatoplay)
{
    if (hasResourceErrorplayingQuran==false) playlist->addMedia(QUrl::fromLocalFile("/home/defaultuser"+pathAyatoplay));
}
void calcul::playQuran()
{
    //qDebug() << "-------QDir::currentPath() ----------"<<QDir::currentPath() <<"-----" ;
    //playlist->setCurrentIndex(1);
    //playlist->addMedia(QUrl::fromLocalFile("/home/defaultuser/Downloads/Thakir_Quran/Ghamadi_40kbps/002009.mp3"));
    // playlist->addMedia(QUrl::fromLocalFile("/home/defaultuser/Downloads/Thakir_Quran/Ghamadi_40kbps/002009.mp3"));
    // playlist->addMedia(QUrl::fromLocalFile("/home/defaultuser/Downloads/Thakir_Quran/Ghamadi_40kbps/002010.mp3"));
    playerQuran->play();
}
void calcul::justeplay()
{
    player->play();
}
int calcul::hafplaybackStatus()
{
    if (player->state()==QMediaPlayer::StoppedState) return 0;
    if (player->state()==QMediaPlayer::PlayingState) return 1;
    if (player->state()==QMediaPlayer::PausedState) return 2;

}
//------21-11-2018------------
void calcul::allplayedReset() {
    athkarSabahHasePlayed=false;
    athkarMassaaHasePlayed=false;
    athanHasStoped=false;
    alertehaseplayed=false;
    athanhaseplayed=false;
    profileSwitcherhaseplayed=false;
    profileSwitcherbackhaseplayed=false;
    settings.saveValueFor("athanHasStoped","false");
}
int calcul::remaining_time_timesunrise_mn() {
    PrayerTimes_Calculer();
    now = QDateTime::currentDateTime();
    /* current time */
    tm_hour=now.time().hour() ;
    tm_min=now.time().minute();

    cur_minutes = tm_min + tm_hour * 60;

    return (ptList[1].hour*60+ptList[1].minute)-cur_minutes;
}
void calcul::hafprofileSwitcherReset() {
    QTimer::singleShot(6000, [=] { //after 2mn
        profileSwitcher();
    });

}
void calcul::hafprofileSwitcherBackReset() {
    QTimer::singleShot(6000, [=] { //after 2mn
        profileSwitcherback();
    });

}

void calcul::haftimersplayall() {
    //-----
    remaining_time_haf();
    spinBox_correction_hijri = settings.getValueFor("adjust_hijri","").toInt();
    hijridate(spinBox_correction_hijri);
    isJommoaa();
    //-----
    emit sendToQmlplayhaftimersisActive(playhaftimers->isActive());
    //Alert
    minAlerteBeforeAthanvalue=settings.getValueFor("minAlerteBeforeAthanvalue", "").toInt();
    emit sendToQmltempAlert(remaining_time_haf_Sec()-minAlerteBeforeAthanvalue*60,!athanhaseplayed);
    if (remaining_time_haf_Sec()-minAlerteBeforeAthanvalue*60==0){
        allplayedReset();
        if (settings.getValueFor("alerteActiveChecked","")=="0" && alertehaseplayed==false){
            playAlert();
            alertehaseplayed=true;
            settings.saveValueFor("athanHasStoped","false");
        }
    }
    //Athan
    emit sendToQmltempAthan(remaining_time_haf_Sec(),!athanhaseplayed);
    if(remaining_time_haf_Sec()==0){
        allplayedReset();
        if (athanhaseplayed==false && settings.getValueFor("athanHasStoped","")=="false"){
            playAdhan();
            athanhaseplayed=true;
            settings.saveValueFor("athanHasStoped","true");
        }
    }
    //Active Silent Mode
    silenctAfterAthanActiveChecked=settings.getValueFor("silenctAfterAthanActiveChecked", "").toInt();
    silentDuringTarawihChecked=settings.getValueFor("silentDuringTarawihChecked", "").toInt();
    silentDuringSalatJommoaaChecked=settings.getValueFor("silentDuringSalatJommoaaChecked", "").toInt();

    minSilentActiveBeforAthanJommoaavalue=settings.getValueFor("minSilentActiveBeforAthanJommoaavalue", "").toInt();
    minSilentActiveAfterAthanvalue=settings.getValueFor("minSilentActiveAfterAthanvalue", "").toInt();

    if (next_salat_haf_id()==5 && boolisRamathan){
        run_periodsActiveSilent = remaining_time_haf_Sec();
    }else if(next_salat_haf_id()==2 && boolisJommoaa){
        run_periodsActiveSilent = remaining_time_haf_Sec()-minSilentActiveBeforAthanJommoaavalue*60;
    }else{
        if (!(next_salat_haf_id()==3 && boolisJommoaa)){
            run_periodsActiveSilent = minSilentActiveAfterAthanvalue*60 - passed_time_from_oldSalat_Sec();
        }else{
            run_periodsActiveSilent=1;
        }
    }

    emit sendToQmltempActiveSilent(run_periodsActiveSilent,!profileSwitcherhaseplayed);

    if (run_periodsActiveSilent==0){
        allplayedReset();
        if (next_salat_haf_id()==5 && boolisRamathan){
            if(passed_time_from_oldSalat_Sec() != -1) {
                if (silentDuringTarawihChecked==0 && profileSwitcherhaseplayed==false){
                    profileSwitcher();
                    //profileSwitcherhaseplayed=true;
                    //app.activate();
                }
            }
        }else if(next_salat_haf_id()==2 && boolisJommoaa){
            if(passed_time_from_oldSalat_Sec() != -1) {
                if (silentDuringSalatJommoaaChecked==0 && profileSwitcherhaseplayed==false){
                    profileSwitcher();
                    profileSwitcherhaseplayed=true;
                    //app.activate();
                }
            }
        }else{
            if(passed_time_from_oldSalat_Sec()!= -1) {
                //qDebug() << "-------profileSwitcher')----------"<<passed_time_from_oldSalat_Sec()<<"-----" ;
                if (silenctAfterAthanActiveChecked==0 && profileSwitcherhaseplayed==false && !(next_salat_haf_id()==-1 && boolisRamathan && silentDuringTarawihChecked==0)){
                    profileSwitcher();
                    profileSwitcherhaseplayed=true;
                    //qDebug() << "-------profileSwitcher')----------" ;
                    //app.activate();
                }
            }
        }

    }

    //Active back Mode
    minSilentDuringTarawihvalue=settings.getValueFor("minSilentDuringTarawihvalue", "").toInt();
    minSilentActiveAfterAthanJommoaavalue=settings.getValueFor("minSilentActiveAfterAthanJommoaavalue", "").toInt();
    minSilentActivedurationvalue=settings.getValueFor("minSilentActivedurationvalue", "").toInt();

    if (next_salat_haf_id()==-1 && boolisRamathan){
        if(silentDuringTarawihChecked==0){
            run_periodsBackModeSilent=minSilentDuringTarawihvalue*60-passed_time_from_oldSalat_Sec();
        }else{
            run_periodsBackModeSilent= minSilentActiveAfterAthanvalue*60+minSilentActivedurationvalue*60-passed_time_from_oldSalat_Sec();
        }
    }else if(next_salat_haf_id()==3 && boolisJommoaa){
        run_periodsBackModeSilent=passed_time_from_oldSalat_Sec() - minSilentActiveAfterAthanJommoaavalue*60;
    }else{
        run_periodsBackModeSilent= minSilentActiveAfterAthanvalue*60+minSilentActivedurationvalue*60-passed_time_from_oldSalat_Sec();
    }

    //--
    emit sendToQmltempReturntoNormalMode(run_periodsBackModeSilent,!profileSwitcherbackhaseplayed);

    if (run_periodsBackModeSilent==0){
        allplayedReset();
        if (next_salat_haf_id()==-1 && boolisRamathan){
            //qDebug() << "passed_time_from_oldSalat_Sec()=" << passed_time_from_oldSalat_Sec();
            if(passed_time_from_oldSalat_Sec() != -1) {
                if ((silentDuringTarawihChecked==0 || silenctAfterAthanActiveChecked==0) && profileSwitcherbackhaseplayed==false){
                    profileSwitcherback();
                    //qDebug() << "rentrer dans profileSwitcherback() Ramathan ";
                    profileSwitcherbackhaseplayed=true;
                    //app.activate();
                }
            }
        }else if(next_salat_haf_id()==3 && boolisJommoaa){
            if(passed_time_from_oldSalat_Sec() != -1) {
                if (silentDuringSalatJommoaaChecked==0 && profileSwitcherbackhaseplayed==false){
                    profileSwitcherback();
                    profileSwitcherbackhaseplayed=true;
                    //app.activate();
                }
            }
        }else{
            if(passed_time_from_oldSalat_Sec() != -1) {
                if (silenctAfterAthanActiveChecked==0 && profileSwitcherbackhaseplayed==false){
                    profileSwitcherback();
                    profileSwitcherbackhaseplayed=true;
                    //app.activate();
                }
            }
        }
    }

    //Play Athkar Sabbah
    if (next_salat_haf_id()==2){ //a rectifier pour chorok au lieu fajr
        playAthkarSabahChecked=settings.getValueFor("playAthkarSabahChecked","").toInt();
        minplayAthkarSabah=settings.getValueFor("minplayAthkarSabah","").toInt();

        run_periodsPlayAthkarSabah= minplayAthkarSabah-remaining_time_timesunrise_mn();
        //qDebug() << "remaining_time_timesunrise_mn()=" << remaining_time_timesunrise_mn();
        if (run_periodsPlayAthkarSabah==0){
            allplayedReset();
            if(passed_time_from_oldSalat_Sec() != -1) {
                if (playAthkarSabahChecked==0 && athkarSabahHasePlayed==false){
                    playathkarSabah();
                    athkarSabahHasePlayed=true;
                    //app.activate();
                }
            }
        }
    }

    //Play Athkar Massaa
    if (next_salat_haf_id()==4){
        playAthkarMassaChecked=settings.getValueFor("playAthkarMassaChecked","").toInt();
        minplayAthkarMassa=settings.getValueFor("minplayAthkarMassa","").toInt();

        if (remaining_time_haf_Sec()-minplayAthkarMassa*60==0){
            allplayedReset();
            if(passed_time_from_oldSalat_Sec() != -1) {
                if (playAthkarMassaChecked==0 && athkarMassaaHasePlayed==false){
                    playathkarMassaa();
                    athkarMassaaHasePlayed=true;
                    //app.activate();
                }
            }
        }
    }

}

void calcul::playathkarSabah(){
    int random_integer = rand() % 8;
    //qDebug() << "HAF random_integer_playathkarSabah="<<random_integer << endl;
    switch (random_integer) {
    case 0:
        player->setMedia(SailfishApp::pathTo("sounds/Athkar/1_1.mp3"));
        break;
    case 1:
        player->setMedia(SailfishApp::pathTo("sounds/Athkar/1_2.mp3"));
        break;
    case 2:
        player->setMedia(SailfishApp::pathTo("sounds/Athkar/1_3.mp3"));
        break;
    case 3:
        player->setMedia(SailfishApp::pathTo("sounds/Athkar/1_4.mp3"));
        break;
    case 4:
        player->setMedia(SailfishApp::pathTo("sounds/Athkar/2_4.mp3"));
        break;
    case 5:
        player->setMedia(SailfishApp::pathTo("sounds/Athkar/2_1.mp3"));
        break;
    case 6:
        player->setMedia(SailfishApp::pathTo("sounds/Athkar/1_19.mp3"));
        break;
    case 7:
        player->setMedia(SailfishApp::pathTo("sounds/Athkar/3_1.mp3"));
        break;
    }
    player->setVolume(100);
    player->play();
    emit sendToQmlDurationMedia(duration());
}

void calcul::playathkarMassaa(){
    int random_integer = rand() % 5;
    //qDebug() << "HAF random_integer_playathkarMassaa="<<random_integer << endl;
    switch (random_integer) {
    case 0:
        player->setMedia(SailfishApp::pathTo("sounds/Athkar/2_1.mp3"));
        break;
    case 1:
        player->setMedia(SailfishApp::pathTo("sounds/Athkar/1_3.mp3"));
        break;
    case 2:
        player->setMedia(SailfishApp::pathTo("sounds/Athkar/1_2.mp3"));
        break;
    case 3:
        player->setMedia(SailfishApp::pathTo("sounds/Athkar/2_2.mp3"));
        break;
    case 4:
        player->setMedia(SailfishApp::pathTo("sounds/Athkar/3_2.mp3"));
        break;
    }
    player->setVolume(100);
    player->play();
    emit sendToQmlDurationMedia(duration());
}

void calcul::playathkar(){
    player->setVolume(100);
    int playAthkarsource=settings.getValueFor("playAthkarsource","").toInt();
    switch (playAthkarsource) {
    case 0:
        player->setMedia(SailfishApp::pathTo("/sounds/Athkar/1_18.mp3"));
        player->play();
        break;
    case 1:
        player->setMedia(SailfishApp::pathTo("/sounds/Athkar/1_13.mp3"));
        player->play();
        break;
    case 2:
        player->setMedia(SailfishApp::pathTo("/sounds/Athkar/1_17.mp3"));
        player->play();
        break;
    case 3:
        player->setMedia(SailfishApp::pathTo("/sounds/Athkar/1_14.mp3"));
        player->play();
        break;
    case 4:
        player->setMedia(SailfishApp::pathTo("/sounds/Athkar/1_10.mp3"));
        player->play();
        break;
    case 5:
        player->setMedia(SailfishApp::pathTo("/sounds/Athkar/5_1.mp3"));
        player->play();
        break;
    case 6:
        player->setMedia(SailfishApp::pathTo("/sounds/Athkar/1_6.mp3"));
        player->play();
        break;
    case 7:
        player->setMedia(SailfishApp::pathTo("/sounds/Athkar/1_8.mp3"));
        player->play();
        break;
    case 8:
        playathkarSabah();
        break;
    case 9:
        playathkarMassaa();
        break;
    }
    emit sendToQmlDurationMedia(duration());
}

//----------------------------
calcul::~calcul()
{
    // switch back to initial profile
    if (itsInitialProfile != PHONE_PROFILE_SILENT) {
        QDBusMessage msg = QDBusMessage::createMethodCall(
                    "com.nokia.profiled", // --dest
                    "/com/nokia/profiled", // destination object path
                    "com.nokia.profiled", // message name (w/o method)
                    "set_profile" // method
                    );
        msg << itsInitialProfile;
        QDBusMessage reply = QDBusConnection::sessionBus().call(msg);
        if (reply.type() != QDBusMessage::ErrorMessage) {
            //qDebug() << "Switched phone profile back to" << itsInitialProfile;
        }
        else {
            qWarning() << "Switching current phone profile failed:" << QDBusConnection::sessionBus().lastError();
        }
    }
}
QString calcul::Hikkmato_Youm()
{
    filemaneCategorie=SailfishApp::pathTo("files/Hikmato_El_Youm.txt").path();
    numberligneMax=341;
    srand(time(NULL));
    numberligne=numberligneMax+1; //nbre de lignes+1
    random_integer_hikma=rand() % numberligne;

    QFile file( filemaneCategorie );
    if ( file.open( QIODevice::ReadOnly | QIODevice::Text ) ) {
        QTextStream stream( &file );

        for(j=0;j<=random_integer_hikma;j++)
            line=stream.readLine();
    }

    random_integer_hikma++;
    if (random_integer_hikma==numberligneMax)
        random_integer_hikma=0;
    if (line.isEmpty())
    {
        Hikkmato_Youm();
    }
    //qDebug() << "HAF random_integer_hikma="<<random_integer_hikma << endl;

    file.close();
    return line;
}
void calcul::formatNumberArabic()
{
    //  QLocale::setDefault(QLocale(QLocale::Arabic, QLocale::Algeria));
    QLocale::setDefault(QLocale::system());

}
QString calcul::formatNumberArab(QString value) {
    float valueFloat=value.toFloat();

    //QString formatNumberHindichecked=settings.getValueFor("formatNumberHindiActiveChecked", "");

    QLocale::setDefault(QLocale(QLocale::Arabic, QLocale::Algeria));
    QLocale FormatNumber; // Constructs a default QLocale
    FormatNumber.setNumberOptions(QLocale::OmitGroupSeparator);
    QString Number_Format_Arab = QString::fromUtf8("%1")
            .arg(FormatNumber.toString(valueFloat));


    //if (formatNumberHindichecked!="0") formatNumberArabic();
    return Number_Format_Arab;


    profileSwitcherbackhaseplayed=false;
}
QString calcul::formatNumberHindi(float value) {
    QString formatNumberHindichecked=settings.getValueFor("formatNumberHindiActiveChecked", "");

    QLocale::setDefault(QLocale(QLocale::Arabic, QLocale::SaudiArabia));
    QLocale FormatNumber; // Constructs a default QLocale
    FormatNumber.setNumberOptions(QLocale::OmitGroupSeparator);
    QString Number_Format_Hindi = QString::fromUtf8("%1")
            .arg(FormatNumber.toString(value));


    if (formatNumberHindichecked!="0") formatNumberArabic();
    return Number_Format_Hindi;



}
//----------------------HAF 10-4-2016-------------Profil----------------
void calcul::profileSwitcherback()
{
    // switch back to initial profile
    if (itsInitialProfile != PHONE_PROFILE_SILENT) {
        QDBusMessage msg = QDBusMessage::createMethodCall(
                    "com.nokia.profiled", // --dest
                    "/com/nokia/profiled", // destination object path
                    "com.nokia.profiled", // message name (w/o method)
                    "set_profile" // method
                    );
        msg << itsInitialProfile;
        QDBusMessage reply = QDBusConnection::sessionBus().call(msg);
        if (reply.type() != QDBusMessage::ErrorMessage) {
            //qDebug() << "Switched phone profile back to" << itsInitialProfile;

            player->setMedia(SailfishApp::pathTo("sounds/Alert/Beep.mp3"));
            player->play();
        }
        else {
            hafprofileSwitcherBackReset();

            //qDebug() << "Switching current phone profile failed:" << QDBusConnection::sessionBus().lastError();
        }
    }
}
void calcul::profileSwitcher()
{
    // default status is silent, then no switching back at exit will appear
    itsInitialProfile = PHONE_PROFILE_SILENT;

    bool itsSwitchProfile=true;

    // perform profile switching
    if (itsSwitchProfile) {
        // determine current phone profile
        QDBusMessage msg = QDBusMessage::createMethodCall(
                    "com.nokia.profiled", // --dest
                    "/com/nokia/profiled", // destination object path
                    "com.nokia.profiled", // message name (w/o method)
                    "get_profile" // method
                    );
        QDBusMessage reply = QDBusConnection::sessionBus().call(msg);

        if (reply.type() != QDBusMessage::ErrorMessage) {
            itsInitialProfile = reply.arguments()[0].toString();

            // switch to silent profile
            if (itsInitialProfile != PHONE_PROFILE_SILENT) {
                QDBusMessage msg = QDBusMessage::createMethodCall(
                            "com.nokia.profiled", // --dest
                            "/com/nokia/profiled", // destination object path
                            "com.nokia.profiled", // message name (w/o method)
                            "set_profile" // method
                            );
                msg << PHONE_PROFILE_SILENT;
                QDBusMessage reply = QDBusConnection::sessionBus().call(msg);
                if (reply.type() != QDBusMessage::ErrorMessage) {
                    //qDebug() << "Switched phone profile from" << itsInitialProfile
                             //<< "to" << PHONE_PROFILE_SILENT;
                    player->setMedia(SailfishApp::pathTo("sounds/Alert/Beep.mp3"));
                    player->play();
                }
                else {
                    hafprofileSwitcherReset() ;
                    //qDebug() << "Switching current phone profile failed:" << QDBusConnection::sessionBus().lastError();

                    // we did not switch profile, therefore we also do not need to switch it back
                    // this is achieved by faking the initial profile to silent
                    itsInitialProfile = PHONE_PROFILE_SILENT;
                }
            }
        }
        else{
            hafprofileSwitcherReset();
            //qDebug() << "Determining current phone profile failed:" << QDBusConnection::sessionBus().lastError();
        }
    }
    //qDebug() << "itsInitialProfile===" << itsInitialProfile;
}
//----------------------------------------------------------------------
int calcul::statePlayingAdhan(QMediaPlayer::State isPlaying)
{
    if (isPlaying==QMediaPlayer::PlayingState) {
        athanIsPlaying=1;
        emit sendToQmlAthanIsPlaying();
    }else{
        athanIsPlaying=0;
        emit sendToQmlAthanIsStoped();
    }
    return athanIsPlaying;
}
bool calcul::locationEnabled()
{
    QSettings location("/etc/location/location.conf", QSettings::IniFormat);
    return location.value("location/enabled", false).toBool();
}
void calcul::Debut() {
    //qDebug() <<"------remaining_time_haf_Sec---";
    emit sendToQml(remaining_time_haf_Sec());
}

void calcul::InitailTimer() {
    QDateTime nowtemp = QDateTime::currentDateTime();
    if (nowtemp.time().second()==0){
        timerInitial->stop();
        timer->start();
        PrayerTimes_Calculer();
        //qDebug() << "Timer start";
    }else{
        //qDebug() << nowtemp.time().second();
    }
}
void calcul::receiveFromQml(int count) {
    //qDebug() << "Received in C++ from QML:" << count;
}
//-----------
QString calcul::displayTimes_hhmm(int i)
{
    getPrayerTimes_and_qibla_HAF();

    QString lang=settings.getValueFor("language", "");

    formatNumberHindiActiveChecked = settings.getValueFor("formatNumberHindiActiveChecked","").toInt();

    if (ptList[i].minute==99 || ptList[i].hour==99 ){
        return "--:--";
    }else{
        QString temp1;
        QString temp2;
        if (ptList[i].hour < 10 ){
            if (formatNumberHindiActiveChecked==0){
                temp1=formatNumberHindi(0)+formatNumberHindi(ptList[i].hour);
            }else{
                temp1="0"+QString::number(ptList[i].hour);
            }
        }else{
            if (formatNumberHindiActiveChecked==0){
                temp1=formatNumberHindi(ptList[i].hour);
            }else{
                temp1=QString::number(ptList[i].hour);
            }
        }
        if (ptList[i].minute < 10 ){
            if (formatNumberHindiActiveChecked==0){
                temp2=formatNumberHindi(0)+formatNumberHindi(ptList[i].minute);
            }else{
                temp2="0"+QString::number(ptList[i].minute);
            }
        }else{
            if (formatNumberHindiActiveChecked==0){
                temp2=formatNumberHindi(ptList[i].minute);
            }else{
                temp2=QString::number(ptList[i].minute);
            }
        }

        if (settings.getValueFor("timeformat","").toInt()==12){
            if (ptList[i].hour > 12 ){
                if (ptList[i].hour-12 < 10){
                    if (formatNumberHindiActiveChecked==0){
                        temp1=formatNumberHindi(0)+formatNumberHindi(ptList[i].hour-12);
                    }else{
                        temp1="0"+QString::number(temp1.toInt()-12);
                    }
                }else{
                    if (formatNumberHindiActiveChecked==0){
                        temp1=formatNumberHindi(ptList[i].hour-12);
                    }else{
                        temp1=QString::number(temp1.toInt()-12);
                    }
                }
                if (lang=="ar"){
                    temp2=temp2+" م";
                }else{
                    temp2=temp2+" pm";
                }
            }else{
                if (ptList[i].hour == 12 ){
                    if (lang=="ar"){
                        temp2=temp2+" م";
                    }else{
                        temp2=temp2+" pm";
                    }
                }else{
                    if (lang=="ar"){
                        temp2=temp2+" ص";
                    }else{
                        temp2=temp2+" am";
                    }
                }
            }
            if (formatNumberHindiActiveChecked==0){
                if (temp1==formatNumberHindi(00)) temp1=formatNumberHindi(12);
            }else{
                if (temp1=="00") temp1="12";
            }

        }

        return temp1 +":" + temp2;
    }
}
QString calcul::displayTimes_imsaak_hhmm()
{
    getPrayerTimes_and_qibla_HAF();

    QString lang=settings.getValueFor("language", "");

    formatNumberHindiActiveChecked = settings.getValueFor("formatNumberHindiActiveChecked","").toInt();

    if (ptList[0].minute==99 || ptList[0].hour==99 ){
        return "--:--";
    }else{
        QString temp1;
        QString temp2;
        if (imsaak.hour < 10 ){
            if (formatNumberHindiActiveChecked==0){
                temp1=formatNumberHindi(0)+formatNumberHindi(imsaak.hour);
            }else{
                temp1="0"+QString::number(imsaak.hour);
            }
        }else{
            if (formatNumberHindiActiveChecked==0){
                temp1=formatNumberHindi(imsaak.hour);
            }else{
                temp1=QString::number(imsaak.hour);
            }
        }
        if (imsaak.minute < 10 ){
            if (formatNumberHindiActiveChecked==0){
                temp2=formatNumberHindi(0)+formatNumberHindi(imsaak.minute);
            }else{
                temp2="0"+QString::number(imsaak.minute);
            }
        }else{
            if (formatNumberHindiActiveChecked==0){
                temp2=formatNumberHindi(imsaak.minute);
            }else{
                temp2=QString::number(imsaak.minute);
            }
        }

        if (settings.getValueFor("timeformat","").toInt()==12){
            if (imsaak.hour > 12 ){
                if (imsaak.hour-12 < 10){
                    if (formatNumberHindiActiveChecked==0){
                        temp1=formatNumberHindi(0)+formatNumberHindi(imsaak.hour-12);
                    }else{
                        temp1="0"+QString::number(temp1.toInt()-12);
                    }
                }else{
                    if (formatNumberHindiActiveChecked==0){
                        temp1=formatNumberHindi(imsaak.hour-12);
                    }else{
                        temp1=QString::number(temp1.toInt()-12);
                    }
                }
                if (lang=="ar"){
                    temp2=temp2+" م";
                }else{
                    temp2=temp2+" pm";
                }
            }else{
                if (imsaak.hour == 12 ){
                    if (lang=="ar"){
                        temp2=temp2+" م";
                    }else{
                        temp2=temp2+" pm";
                    }
                }else{
                    if (lang=="ar"){
                        temp2=temp2+" ص";
                    }else{
                        temp2=temp2+" am";
                    }
                }
            }
            if (formatNumberHindiActiveChecked==0){
                if (temp1==formatNumberHindi(00)) temp1=formatNumberHindi(12);
            }else{
                if (temp1=="00") temp1="12";
            }

        }

        return temp1 +":" + temp2;
    }
}
QString calcul::displayTimes_nextfajr_hhmm()
{
    getPrayerTimes_and_qibla_HAF();

    QString lang=settings.getValueFor("language", "");

    formatNumberHindiActiveChecked = settings.getValueFor("formatNumberHindiActiveChecked","").toInt();

    if (ptList[0].minute==99 || ptList[0].hour==99 ){
        return "--:--";
    }else{
        QString temp1;
        QString temp2;
        if (nextFajr.hour < 10 ){
            if (formatNumberHindiActiveChecked==0){
                temp1=formatNumberHindi(0)+formatNumberHindi(nextFajr.hour);
            }else{
                temp1="0"+QString::number(nextFajr.hour);
            }
        }else{
            if (formatNumberHindiActiveChecked==0){
                temp1=formatNumberHindi(nextFajr.hour);
            }else{
                temp1=QString::number(nextFajr.hour);
            }
        }
        if (nextFajr.minute < 10 ){
            if (formatNumberHindiActiveChecked==0){
                temp2=formatNumberHindi(0)+formatNumberHindi(nextFajr.minute);
            }else{
                temp2="0"+QString::number(nextFajr.minute);
            }
        }else{
            if (formatNumberHindiActiveChecked==0){
                temp2=formatNumberHindi(nextFajr.minute);
            }else{
                temp2=QString::number(nextFajr.minute);
            }
        }

        if (settings.getValueFor("timeformat","").toInt()==12){
            if (nextFajr.hour > 12 ){
                if (nextFajr.hour-12 < 10){
                    if (formatNumberHindiActiveChecked==0){
                        temp1=formatNumberHindi(0)+formatNumberHindi(nextFajr.hour-12);
                    }else{
                        temp1="0"+QString::number(temp1.toInt()-12);
                    }
                }else{
                    if (formatNumberHindiActiveChecked==0){
                        temp1=formatNumberHindi(nextFajr.hour-12);
                    }else{
                        temp1=QString::number(temp1.toInt()-12);
                    }
                }
                if (lang=="ar"){
                    temp2=temp2+" م";
                }else{
                    temp2=temp2+" pm";
                }
            }else{
                if (nextFajr.hour == 12 ){
                    if (lang=="ar"){
                        temp2=temp2+" م";
                    }else{
                        temp2=temp2+" pm";
                    }
                }else{
                    if (lang=="ar"){
                        temp2=temp2+" ص";
                    }else{
                        temp2=temp2+" am";
                    }
                }
            }
            if (formatNumberHindiActiveChecked==0){
                if (temp1==formatNumberHindi(00)) temp1=formatNumberHindi(12);
            }else{
                if (temp1=="00") temp1="12";
            }

        }

        return temp1 +":" + temp2;
    }
}
bool calcul::isPrayerExtrem(int indexprayer)
{
    getPrayerTimes_and_qibla_HAF();
    return ptList[indexprayer].isExtreme;
}
//void calcul::set_adjustment(double delay) {
//    QProcess *process = new QProcess(this);
//    delay = delay*60;
//    QString delay_str = QString::number(delay);
//    QString cmd = "timedclient-qt5 --set-snooze=" + delay_str;
//    process->start(cmd);
//    //qDebug() << "set_adjustment ok c++: " << cmd;
//}
//double calcul::get_adjustment() {
//    QProcess *process = new QProcess(this);
//    QString cmd = "timedclient-qt5 --get-snooze";
//    process->start(cmd);
//    process->waitForReadyRead();
//    QString delay_sec = process->readAllStandardOutput();
//    process->close();
//    double delay = (delay_sec.toDouble())/60;
//    return delay;
//}
//-----------
void calcul::PrayerTimes_Calculer()
{

    getPrayerTimes_and_qibla_HAF();

    //---------------

    now = QDateTime::currentDateTime();
    double now_hour=now.time().hour() + now.time().minute()/60.;
    //    //qDebug() << now_hour ;
    //    if ( conv_time_haf(now_hour,NEAREST)==conv_time_haf(fajr,NEAREST) || conv_time_haf(now_hour,NEAREST)==conv_time_haf(dhuhr,NEAREST) || conv_time_haf(now_hour,NEAREST)==conv_time_haf(asr,NEAREST) || conv_time_haf(now_hour,NEAREST)==conv_time_haf(maghrib,NEAREST) || conv_time_haf(now_hour,NEAREST)==conv_time_haf(isha,NEAREST))
    //    {
    //       emit sendToQml(43); // for active Silent profile (via dbus)
    //       player->play();
    //    }


    //---------
    now = QDateTime::currentDateTime();

    /* current time */
    tm_hour=now.time().hour() ;
    tm_min=now.time().minute();

    cur_minutes = tm_min + tm_hour * 60;


    next_prayer_id = -1;
    for (int i = 0; i < 6; i++)
    {
        if ( i == 1 ) { continue ;} /* skip shorouk */
        if(ptList[i].hour > tm_hour ||
                (ptList[i].hour == tm_hour &&
                 ptList[i].minute >= tm_min))
        {
            next_prayer_id = i;break;
        }
    }


    //qDebug() << "next_prayer_id======" << next_prayer_id;
}
QString calcul::displayTimes_time_end_Isha_hhmm(){

    getPrayerTimes_and_qibla_HAF();

    QString lang=settings.getValueFor("language", "");

    formatNumberHindiActiveChecked = settings.getValueFor("formatNumberHindiActiveChecked","").toInt();

    //double end_first_third_party_of_night__hours=(24-maghrib+fajr)/3.+maghrib;

    if (ptList[0].minute==99 || ptList[0].hour==99 || ptList[0].isExtreme){
        return "--:--";
    }else{
        int choix=1; //ou 1 soit end_ish=midnight ou 1/3 lial

        int Min_maghreb=ptList[4].minute + ptList[4].hour*60;
        int Min_fadjr_Tomorrow= nextFajr.minute + nextFajr.hour*60;

        int Min_fin_ishaa;
        int Min_debut_Tholoth_akhir;

        int  fin_ishaa_Hour;
        int fin_ishaa_Min;

        int debut_Tholoth_akhir_Hour;
        int debut_Tholoth_akhir_Min;

        if (choix==1)
        {
            if (Min_maghreb < Min_fadjr_Tomorrow)
            {
                Min_fin_ishaa=int((Min_maghreb+Min_fadjr_Tomorrow)/2.);
            }
            else
            {
                Min_fin_ishaa=int((24*60-Min_maghreb+Min_fadjr_Tomorrow)/2.+Min_maghreb);
            }
        }
        if (choix==0)
        {
            if (Min_maghreb < Min_fadjr_Tomorrow)
            {
                Min_fin_ishaa=int((Min_fadjr_Tomorrow-Min_maghreb)/3.+Min_maghreb);
            }
            else
            {
                Min_fin_ishaa=int((24*60-Min_maghreb+Min_fadjr_Tomorrow)/3.+Min_maghreb);
            }
        }

        if (Min_fin_ishaa > 24*60)
        {
            Min_fin_ishaa=Min_fin_ishaa-24*60;
            fin_ishaa_Hour=Min_fin_ishaa/60;
            fin_ishaa_Min=Min_fin_ishaa % 60;
        }
        else
        {
            fin_ishaa_Hour=Min_fin_ishaa/60;
            fin_ishaa_Min=Min_fin_ishaa % 60;

        }

        //---
        if (Min_maghreb < Min_fadjr_Tomorrow)
        {
            Min_debut_Tholoth_akhir=int(((Min_fadjr_Tomorrow-Min_maghreb)/3.)*2+Min_maghreb);
        }
        else
        {
            Min_debut_Tholoth_akhir=int(((24*60-Min_maghreb+Min_fadjr_Tomorrow)/3.)*2+Min_maghreb);
        }
        //---

        if (Min_debut_Tholoth_akhir > 24*60)
        {
            Min_debut_Tholoth_akhir=Min_debut_Tholoth_akhir-24*60;
            debut_Tholoth_akhir_Hour=Min_debut_Tholoth_akhir/60;
            debut_Tholoth_akhir_Min=Min_debut_Tholoth_akhir % 60 ;
        }
        else
        {
            debut_Tholoth_akhir_Hour=Min_debut_Tholoth_akhir/60;
            debut_Tholoth_akhir_Min=Min_debut_Tholoth_akhir % 60 ;
        }

        //--------------

        QString temp4="0";
        QString temp1;
        QString temp2;

        if (fin_ishaa_Hour == 24 )  fin_ishaa_Hour=0;
        if (fin_ishaa_Hour < 10 ) {
            if (formatNumberHindiActiveChecked==0){
                temp1=formatNumberHindi(0)+formatNumberHindi(fin_ishaa_Hour);
            }else{
                temp1=temp4+QString::number(fin_ishaa_Hour);
            }
        }else{
            if (formatNumberHindiActiveChecked==0){
                temp1=formatNumberHindi(fin_ishaa_Hour);
            }else{
                temp1=QString::number(fin_ishaa_Hour);
            }
        }

        if (fin_ishaa_Min < 10 ) {
            if (formatNumberHindiActiveChecked==0){
                temp2=formatNumberHindi(0)+formatNumberHindi(fin_ishaa_Min);
            }else{
                temp2=temp4+QString::number(fin_ishaa_Min);
            }
        }else{
            if (formatNumberHindiActiveChecked==0){
                temp2=formatNumberHindi(fin_ishaa_Min);
            }else{
                temp2=QString::number(fin_ishaa_Min);
            }
        }

        if (settings.getValueFor("timeformat","").toInt()==12){
            if (fin_ishaa_Hour > 12 ){
                if (fin_ishaa_Hour-12 < 10){
                    if (formatNumberHindiActiveChecked==0){
                        temp1=formatNumberHindi(0)+formatNumberHindi(fin_ishaa_Hour-12);
                    }else{
                        temp1="0"+QString::number(temp1.toInt()-12);
                    }
                }else{
                    if (formatNumberHindiActiveChecked==0){
                        temp1=formatNumberHindi(fin_ishaa_Hour-12);
                    }else{
                        temp1=QString::number(temp1.toInt()-12);
                    }
                }
                if (lang=="ar"){
                    temp2=temp2+" م";
                }else{
                    temp2=temp2+" pm";
                }
            }else{
                if (fin_ishaa_Hour == 12 ){
                    if (lang=="ar"){
                        temp2=temp2+" م";
                    }else{
                        temp2=temp2+" pm";
                    }
                }else{
                    if (lang=="ar"){
                        temp2=temp2+" ص";
                    }else{
                        temp2=temp2+" am";
                    }
                }
            }
            if (formatNumberHindiActiveChecked==0){
                if (temp1==formatNumberHindi(00)) temp1=formatNumberHindi(12);
            }else{
                if (temp1=="00") temp1="12";
            }

        }

        QString timemidnight=temp1+":"+temp2;

        return timemidnight;
    }
}
QString calcul::displayTimes_timebegin_Tholoth_akhir_hhmm()
{
    getPrayerTimes_and_qibla_HAF();

    QString lang=settings.getValueFor("language", "");

    formatNumberHindiActiveChecked = settings.getValueFor("formatNumberHindiActiveChecked","").toInt();

    if (ptList[0].minute==99 || ptList[0].hour==99 || ptList[0].isExtreme){
        return "--:--";
    }else{
        int choix=0; //ou 1 soit end_ish=midnight ou 1/3 lial

        int Min_maghreb=ptList[4].minute + ptList[4].hour*60;
        int Min_fadjr_Tomorrow= nextFajr.minute + nextFajr.hour*60;

        int Min_fin_ishaa;
        int Min_debut_Tholoth_akhir;

        int  fin_ishaa_Hour;
        int fin_ishaa_Min;

        int debut_Tholoth_akhir_Hour;
        int debut_Tholoth_akhir_Min;

        if (choix==1)
        {
            if (Min_maghreb < Min_fadjr_Tomorrow)
            {
                Min_fin_ishaa=int((Min_maghreb+Min_fadjr_Tomorrow)/2.);
            }
            else
            {
                Min_fin_ishaa=int((24*60-Min_maghreb+Min_fadjr_Tomorrow)/2.+Min_maghreb);
            }
        }
        if (choix==0)
        {
            if (Min_maghreb < Min_fadjr_Tomorrow)
            {
                Min_fin_ishaa=int((Min_fadjr_Tomorrow-Min_maghreb)/3.+Min_maghreb);
            }
            else
            {
                Min_fin_ishaa=int((24*60-Min_maghreb+Min_fadjr_Tomorrow)/3.+Min_maghreb);
            }
        }

        if (Min_fin_ishaa > 24*60)
        {
            Min_fin_ishaa=Min_fin_ishaa-24*60;
            fin_ishaa_Hour=Min_fin_ishaa/60;
            fin_ishaa_Min=Min_fin_ishaa % 60;
        }
        else
        {
            fin_ishaa_Hour=Min_fin_ishaa/60;
            fin_ishaa_Min=Min_fin_ishaa % 60;
        }

        //---
        if (Min_maghreb < Min_fadjr_Tomorrow)
        {
            Min_debut_Tholoth_akhir=int(((Min_fadjr_Tomorrow-Min_maghreb)/3.)*2+Min_maghreb);
        }
        else
        {
            Min_debut_Tholoth_akhir=int(((24*60-Min_maghreb+Min_fadjr_Tomorrow)/3.)*2+Min_maghreb);
        }
        //---

        if (Min_debut_Tholoth_akhir > 24*60)
        {
            Min_debut_Tholoth_akhir=Min_debut_Tholoth_akhir-24*60;
            debut_Tholoth_akhir_Hour=Min_debut_Tholoth_akhir/60;
            debut_Tholoth_akhir_Min=Min_debut_Tholoth_akhir % 60 ;
        }
        else
        {
            debut_Tholoth_akhir_Hour=Min_debut_Tholoth_akhir/60;
            debut_Tholoth_akhir_Min=Min_debut_Tholoth_akhir % 60 ;
        }

        //--------------

        QString temp4="0";
        QString temp1;
        QString temp2;
        if (debut_Tholoth_akhir_Hour == 24 )  debut_Tholoth_akhir_Hour=0;
        if (debut_Tholoth_akhir_Hour < 10 ) {
            if (formatNumberHindiActiveChecked==0){
                temp1=formatNumberHindi(0)+formatNumberHindi(debut_Tholoth_akhir_Hour);
            }else{
                temp1=temp4+QString::number(debut_Tholoth_akhir_Hour);
            }
        }else{
            if (formatNumberHindiActiveChecked==0){
                temp1=formatNumberHindi(debut_Tholoth_akhir_Hour);
            }else{
                temp1=QString::number(debut_Tholoth_akhir_Hour);
            }
        }

        if (debut_Tholoth_akhir_Min < 10 ) {
            if (formatNumberHindiActiveChecked==0){
                temp2=formatNumberHindi(0)+formatNumberHindi(debut_Tholoth_akhir_Min);
            }else{
                temp2=temp4+QString::number(debut_Tholoth_akhir_Min);
            }
        }else{
            if (formatNumberHindiActiveChecked==0){
                temp2=formatNumberHindi(debut_Tholoth_akhir_Min);
            }else{
                temp2=QString::number(debut_Tholoth_akhir_Min);
            }
        }

        if (settings.getValueFor("timeformat","").toInt()==12){
            if (debut_Tholoth_akhir_Hour > 12 ){
                if (debut_Tholoth_akhir_Hour-12 < 10){
                    if (formatNumberHindiActiveChecked==0){
                        temp1=formatNumberHindi(0)+formatNumberHindi(debut_Tholoth_akhir_Min-12);
                    }else{
                        temp1="0"+QString::number(temp1.toInt()-12);
                    }
                }else{
                    if (formatNumberHindiActiveChecked==0){
                        temp1=formatNumberHindi(debut_Tholoth_akhir_Hour-12);
                    }else{
                        temp1=QString::number(temp1.toInt()-12);
                    }
                }
                if (lang=="ar"){
                    temp2=temp2+" م";
                }else{
                    temp2=temp2+" pm";
                }
            }else{
                if (debut_Tholoth_akhir_Hour == 12 ){
                    if (lang=="ar"){
                        temp2=temp2+" م";
                    }else{
                        temp2=temp2+" pm";
                    }
                }else{
                    if (lang=="ar"){
                        temp2=temp2+" ص";
                    }else{
                        temp2=temp2+" am";
                    }
                }
            }
            if (formatNumberHindiActiveChecked==0){
                if (temp1==formatNumberHindi(00)) temp1=formatNumberHindi(12);
            }else{
                if (temp1=="00") temp1="12";
            }

        }

        QString debut_Tholoth_akhir=temp1+":"+temp2;
        return debut_Tholoth_akhir;
    }

}
QString calcul::now_salat_haf(){

    if (next_prayer_id==-1)
    {
        now_prayer_text=tr("Ishaa");
    }
    if (next_prayer_id==0)
    {
        now_prayer_text=tr("Ishaa");
    }
    if (next_prayer_id==2)
    {
        now_prayer_text=tr("Fajr");
    }
    if (next_prayer_id==3)
    {
        now_prayer_text=tr("Dhouhr");
    }
    if (next_prayer_id==4)
    {
        now_prayer_text=tr("Assar");
    }
    if (next_prayer_id==5)
    {
        now_prayer_text=tr("Maghreb");
    }
    return now_prayer_text;
}
int calcul::next_salat_haf_id(){
    PrayerTimes_Calculer();
    return next_prayer_id;
}
QString calcul::next_salat_haf(){
    PrayerTimes_Calculer();
    if (next_prayer_id==-1)
    {
        next_prayer_text=tr("Tomorrow's Fajr");
    }
    if (next_prayer_id==0)
    {
        next_prayer_text=tr("Fajr");
    }
    if (next_prayer_id==2)
    {
        next_prayer_text=tr("Dhouhr");
    }
    if (next_prayer_id==3)
    {
        next_prayer_text=tr("Assar");
    }
    if (next_prayer_id==4)
    {
        next_prayer_text=tr("Maghreb");
    }
    if (next_prayer_id==5)
    {
        next_prayer_text=tr("Ishaa");
    }
    return    next_prayer_text;
}
int calcul::remaining_ProgressBar_haf()
{
    PrayerTimes_Calculer();

    if (next_prayer_id==-1)
    {
        next_minutes = nextFajr.minute + nextFajr.hour*60;
        next_old = ptList[5].minute + ptList[5].hour*60;
        next_minutes += 60*24;

    }
    else
    {
        next_minutes = ptList[next_prayer_id].minute + ptList[next_prayer_id].hour*60;
        next_old = ptList[next_prayer_id-1].minute + ptList[next_prayer_id-1].hour*60;
    }

    diffminuterestente=hours*60+minutes;
    diffminuteentreoldandnext;
    if(ptList[next_prayer_id].hour < tm_hour || next_prayer_id== 0)
    {
        diffminuteentreoldandnext=(nextFajr.hour*60+nextFajr.minute)+(24*60-(ptList[5].hour*60+ptList[5].minute));
    }
    else
    {
        diffminuteentreoldandnext=next_minutes-next_old;
    }

    pourcentminut=int((diffminuterestente*100)/diffminuteentreoldandnext);

    pourcentminutExacte=100-pourcentminut;

    if (pourcentminutExacte>100)
    {
        pourcentminutExacte=100;
    }
    if (pourcentminutExacte<5)
    {
        pourcentminutExacte=5;
    }

    return   pourcentminutExacte;
}
int calcul::passed_time_from_oldSalat_Sec()   // 15-4-2016
{

    PrayerTimes_Calculer();

    int next_prayer_id_old;

    if (next_prayer_id==-1 || next_prayer_id==2)
    {
        next_prayer_id_old=-1 ;
    }
    else
    {
        next_prayer_id_old=next_prayer_id-1 ;
    }

    if (ptList[next_prayer_id_old].minute==99 || ptList[next_prayer_id_old].hour==99){
        return -1;
    }else{
        if (next_prayer_id_old==-1)
        {
            if (next_prayer_id==-1) next_old = ptList[5].minute + ptList[5].hour*60; // Isha
            if (next_prayer_id==2) next_old = ptList[0].minute + ptList[0].hour*60; //Fajr
        }else{
            next_old = ptList[next_prayer_id_old].minute + ptList[next_prayer_id_old].hour*60;
        }

        difference = cur_minutes-next_old;


        return difference*60;
    }
}
int calcul::remaining_time_haf_Sec()
{

    PrayerTimes_Calculer();

    if (ptList[next_prayer_id].minute==99 || ptList[next_prayer_id].hour==99){
        return -1;
    }else{
        if (next_prayer_id==-1)
        {
            next_minutes = nextFajr.minute + nextFajr.hour*60;
            next_minutes += 60*24;
        }
        else
        {
            next_minutes = ptList[next_prayer_id].minute + ptList[next_prayer_id].hour*60;
        }

        difference = next_minutes - cur_minutes;

        return difference*60;


        //        QLocale::setDefault( QLocale(QLocale::Arabic, QLocale::SaudiArabia) );
        //       // reportCost->setText( QString("%1").arg( cost ) );

        //       // msg = tr("You have %1 new message(s).", "", n).arg(region.locale().toString(n));

        //        QString temp1=QString("%1").arg(difference*60);

        //                return temp1.toInt();
    }
}
int calcul::remaining_time_haf_Sec_Next()
{
    PrayerTimes_Calculer();

    int next_prayer_id_next;

    if (next_prayer_id==5)
    {
        next_prayer_id_next=-1 ;
    }
    else
    {
        next_prayer_id_next=next_prayer_id+1 ;
    }

    if (ptList[next_prayer_id_next].minute==99 || ptList[next_prayer_id_next].hour==99){
        return -1;
    }else{
        if (next_prayer_id_next==-1)
        {
            next_minutes = nextFajr.minute + nextFajr.hour*60;
            next_minutes += 60*24;
        }
        else
        {
            next_minutes = ptList[next_prayer_id_next].minute + ptList[next_prayer_id_next].hour*60;
        }

        difference = next_minutes - cur_minutes;

        return difference*60;
    }
}
QString calcul::remaining_time_haf()
{

    PrayerTimes_Calculer();

    if (ptList[next_prayer_id].minute==99 || ptList[next_prayer_id].hour==99){
        return "--:--";
    }else{
        if (next_prayer_id==-1)
        {
            next_minutes = nextFajr.minute + nextFajr.hour*60;
            next_minutes += 60*24;
        }
        else
        {
            next_minutes = ptList[next_prayer_id].minute + ptList[next_prayer_id].hour*60;
        }

        difference = next_minutes - cur_minutes;

        hours = difference / 60;
        minutes = difference % 60;


        //---HAF--------

        if (hours==0 && minutes==0 )
        {
            emit sendToQmlRemainTimeZero();
        }else{
            emit sendToQmlRemainTimeNotZero();
        }

        //--------------

        QString temp4;

        formatNumberHindiActiveChecked = settings.getValueFor("formatNumberHindiActiveChecked","").toInt();

        if (formatNumberHindiActiveChecked==0){
            temp4=formatNumberHindi(0);
        }else{
            temp4="0";
        }

        QString temp1;
        QString temp2;


        if (hours < 10 ) {
            if (formatNumberHindiActiveChecked==0){
                temp1=temp4+formatNumberHindi(hours);
            }else{
                temp1=temp4+QString::number(hours);
            }
        }else{
            if (formatNumberHindiActiveChecked==0){
                temp1=formatNumberHindi(hours);
            }else{
                temp1=QString::number(hours);
            }
        }

        if (minutes < 10 ) {
            if (formatNumberHindiActiveChecked==0){
                temp2=temp4+formatNumberHindi(minutes);
            }else{
                temp2=temp4+QString::number(minutes);
            }
        }else{
            if (formatNumberHindiActiveChecked==0){
                temp2=formatNumberHindi(minutes);
            }else{
                temp2=QString::number(minutes);
            }
        }

        remaining_time=temp1+":"+temp2;
        emit sendToQmltempRemainingTime(remaining_time);
        return remaining_time;

    }
}
void calcul::playAdhanUrl(QString url)
{
    volumeAthan = settings.getValueFor("volumeAthanSlidervalue","").toInt();
    player->setVolume(volumeAthan);
    player->setMedia(QUrl::fromLocalFile(url));
    player->play();
}
void calcul::playAlert()
{
    volumeAthan = settings.getValueFor("volumeAthanSlidervalue","").toInt();
    player->setVolume(volumeAthan);
    player->setMedia(SailfishApp::pathTo("sounds/Alert/bip.mp3"));
    player->play();
}
void calcul::playAdhan()
{
    // a METTRE AUSSI SI CHANGEMENT HEURE DU PHONE 29-4-2016
    QTimer::singleShot(60000, this, SLOT(Debut()));
    // determine current phone profile
    QDBusMessage msg = QDBusMessage::createMethodCall(
                "com.nokia.profiled", // --dest
                "/com/nokia/profiled", // destination object path
                "com.nokia.profiled", // message name (w/o method)
                "get_profile" // method
                );
    QDBusMessage reply = QDBusConnection::sessionBus().call(msg);

    if (reply.type() != QDBusMessage::ErrorMessage) {
        currentProfile = reply.arguments()[0].toString();
    }else{
        msg = QDBusMessage::createMethodCall(
                    "com.nokia.profiled", // --dest
                    "/com/nokia/profiled", // destination object path
                    "com.nokia.profiled", // message name (w/o method)
                    "get_profile" // method
                    );
        reply = QDBusConnection::sessionBus().call(msg);
    }

    if (!(currentProfile == PHONE_PROFILE_SILENT && settings.getValueFor("noAthanInSilentProfileChecked","")=="0")){
        //---7-4-2016----
        volumeAthan = settings.getValueFor("volumeAthanSlidervalue","").toInt();
        sendToQml(volumeAthan);
        //qDebug() <<"volumeAthan=" <<volumeAthan;
        player->setVolume(volumeAthan);
        //---------------

        if (next_prayer_id==2 && QDate::currentDate().dayOfWeek()==5 ) //Salat Jommoa or || (next_prayer_id==5 && boolisRamathan) Ishaa in Ramathan
        {
            if (settings.getValueFor("adhan_Fajr","").toInt()!=0){
                player->setMedia(SailfishApp::pathTo("sounds/Alert/bip.mp3"));
                player->play();
            }
        }else{
            switch(settings.getValueFor("adhan_Fajr","").toInt())
            {
            case 0:
                break;
            case 1:
                if (next_prayer_id==0){  // Fajr
                    player->setMedia(SailfishApp::pathTo("sounds/Adhan/Fajr.ogg"));
                }else{
                    player->setMedia(SailfishApp::pathTo("sounds/Adhan/adhan_court.mp3"));
                }
                player->play();
                break;
            case 2:
                if (next_prayer_id==0){  // Fajr
                    player->setMedia(SailfishApp::pathTo("sounds/Adhan/Fajr.ogg"));
                }else{
                    player->setMedia(SailfishApp::pathTo("sounds/Adhan/adhan_Makka.mp3"));
                }
                player->play();
                break;
            case 3:
                if (next_prayer_id==0){  // Fajr
                    player->setMedia(SailfishApp::pathTo("sounds/Adhan/Fajr.ogg"));
                }else{
                    player->setMedia(SailfishApp::pathTo("sounds/Adhan/adhan_Maddina.mp3"));
                }
                player->play();
                break;
            case 4:
                QString tempPathAdhanUser=settings.getValueFor("selectedFajrAdhanFileUser","");
                player->setMedia(QUrl::fromLocalFile(tempPathAdhanUser));
                player->play();
                break;
            }
        }
    }
}
void calcul::stopAthkar()
{
    player->stop();
}
void calcul::pauseAthkar()
{
    player->pause();
    emit positionChanged(position());
}
qint64 &calcul :: duration ( ) {
    return iDuration;
}
qint64 &calcul :: position( ) {
    return iPosition;

}
void calcul::setDuration(qint64 duration)
{
    iDuration = duration;
    //emit durationChanged();
}
void calcul::setPosition(qint64 position)
{
    iPosition = position;
    //emit positionChanged(iPosition);

}
void calcul::athkarplayDurationPosition(qint64 position) {
    emit positionChanged(position);
    emit sendToQmlDurationMedia(duration());
}
void calcul::stopAdhan()
{
    player->stop();
    athanHasStoped=true;
}
double calcul::getTimeZone()
{
    now = QDateTime::currentDateTime();
    double timezone = now.offsetFromUtc()/3600.;
    return timezone;
}
bool calcul::getDaylightSavingTime()
{
    now = QDateTime::currentDateTime();
    return now.isDaylightTime();
}
QString calcul::getLanguageUIofPhone()
{
    return QLocale::languageToString(QLocale::system().language());
}
QString calcul::getCountryInPhone()
{
    QLocale::Country country = QLocale::system().country();
    return QLocale::countryToString(country);
}
int calcul::hikmatooum()
{
    now = QDateTime::currentDateTime();
    //    QLocale::Country country = QLocale::system().country();
    //    QString locale = QLocale::system().name();
    //   //qDebug() << QLocale::languageToString(country) ;
    //   //qDebug() << QLocale::system().name();
    //  //qDebug() << QLocale::countryToString(country);
    //   //qDebug() << QLocale::system().nativeLanguageName();
    //  //qDebug() <<QLocale::languageToString(QLocale::system().language());
    //    QTimeZone timezone1=QTimeZone("America/Chicago");
    //    QTimeZone timezone2=QTimeZone("America/Chicago");
    // //qDebug() << now.isDaylightTime();
    //  //qDebug() << timezone2.isDaylightTime(now);
    //double timezone = now.offsetFromUtc()/3600.;
    // //qDebug() << timezone;
    //    if (now.isDaylightTime()){
    //     return QLocale::countryToString(country)+":"+QLocale::languageToString(QLocale::system().language())+"::"+"true";
    //    }else{
    //        return QLocale::countryToString(country)+":"+QLocale::languageToString(QLocale::system().language())+"::"+"false";
    //    }

    //return settings.getValueFor("dst","").toInt();
    return player->volume();

}
double calcul::time_now_hours()
{
    now = QDateTime::currentDateTime();

    /* current time */
    tm_hour=now.time().hour() ;
    tm_min=now.time().minute();

    return tm_hour+tm_min/60.;

}
double calcul::timesunrise_hours()
{
    getPrayerTimes_and_qibla_HAF();
    return ptList[1].hour+ptList[1].minute/60. ;

}
double calcul::timemaghrib_hours()
{
    getPrayerTimes_and_qibla_HAF();
    return ptList[4].hour+ptList[4].minute/60. ;

}
double calcul::qibla_HAF()
{
    getPrayerTimes_and_qibla_HAF();
    return qibla;

}

void calcul::getPrayerTimes_and_qibla_HAF()
{
    cityName=settings.getValueFor("cityname","");
    QDateTime now = QDateTime::currentDateTime();
    //-------------

    /* fill the Date structure */
    date.day = now.date().day();
    date.month = now.date().month();
    date.year = now.date().year();
    /* fill the location info. structure */
    loc.degreeLat = settings.getValueFor("lat","").toDouble();
    loc.degreeLong = settings.getValueFor("longi","").toDouble();
    loc.gmtDiff = settings.getValueFor("tzone","").toDouble();
    loc.dst = settings.getValueFor("dst","").toInt();
    loc.seaLevel = 0;
    loc.pressure = 1010;
    loc.temperature= 10;

    switch(settings.getValueFor("method","").toInt())
    {
    case 0:getMethod(1, &conf);break;
    case 1:getMethod(2, &conf);break;
    case 2:getMethod(3, &conf);break;
    case 3:getMethod(4, &conf);break;
    case 4:getMethod(5, &conf);break;
    case 5:getMethod(6, &conf);break;
    case 6:getMethod(7, &conf);break;
    case 7:getMethod(8, &conf);break;
    case 8:getMethod(9, &conf);break;
    case 9:getMethod(10, &conf);break;
    case 10:getMethod(11, &conf);break;
        // HAF 7-11-2015
    case 11:getMethod(12, &conf);break;
    case 12:getMethod(13, &conf);break;
    case 13:getMethod(14, &conf);break;
    case 14:getMethod(15, &conf);break;
    case 15:getMethod(16, &conf);break;
    case 16:getMethod(17, &conf);break;
    case 17:getMethod(18, &conf);break;
    case 18:getMethod(19, &conf);break;
    case 19:getMethod(20, &conf);break;
    case 20:getMethod(21, &conf);break;
    case 21:getMethod(22, &conf);break;
    case 22:getMethod(23, &conf);break;
    }

    /* auto fill the method structure. Have a look at prayer.h for a
         * list of supported methods */
    // getMethod(5, &conf);
    conf.round = 3;
    conf.extreme = settings.getValueFor("exmethods","").toInt();

    conf.offset = 1; //zero pour desactiver
    conf.offList[0] = settings.getValueFor("adjust_fajr","").toInt()+conf.offList[0];
    conf.offList[2] = settings.getValueFor("adjust_dhuhr","").toInt()+conf.offList[2];
    conf.offList[3] = settings.getValueFor("adjust_asr","").toInt()+conf.offList[3];
    conf.offList[4] = settings.getValueFor("adjust_maghrib","").toInt()+conf.offList[4];
    conf.offList[5] = settings.getValueFor("adjust_isha","").toInt()+conf.offList[5];



    /* Call the main function to fill the Prayer times array of
         * structures */
    getPrayerTimes (&loc, &conf, &date, ptList);

    /* Call functions for other prayer times and qibla */
    getImsaak (&loc, &conf, &date, &imsaak);
    getNextDayFajr (&loc, &conf, &date, &nextFajr);
    getNextDayImsaak (&loc, &conf, &date, &nextImsaak);
    qibla = getNorthQibla(&loc);


}
bool calcul::isRamathan(int index_spinBox_correction_hijri)
{
    hijridate(index_spinBox_correction_hijri);
    return boolisRamathan;
}
//-----17-11-2018------
bool calcul::isJommoaa()
{
    if (QDate::currentDate().dayOfWeek()==5)
    {
        boolisJommoaa=true;
    }else{
        boolisJommoaa=false;
    }
    return boolisJommoaa;
}
//---------------------
QString calcul::getoutputtexhigri(int index_spinBox_correction_hijri)
{
    hijridate(index_spinBox_correction_hijri);
    return outputtexhigri;
}
QString calcul::getstrDaysEvent(int index_spinBox_correction_hijri)
{
    hijridate(index_spinBox_correction_hijri);
    return strDaysEvent;
}

void calcul::hijridate(int index_spinBox_correction_hijri)
{
    /* hijri code specifics */
    int day, month, year;
    //sDate mydate;
    sDate mydate2;
    //int i;
    int error_code = 0;

    /* umm_alqura code specifics */
    //int dg, mg, yg;
    //int dh, mh, yh;
    int x;
    //int weekday;

    //int yy = 1424;
    //int mm = 11;
    //int dd = 11;

    time_t mytime;
    struct tm *t_ptr;

    /* Get current dte structure */
    time(&mytime);

    t_ptr = localtime(&mytime);

    // HAF
    //int index_spinBox_correction_hijri=ui->spinBox_correction_hijri->value();
    //

    /* Set current time values */
    day   = t_ptr->tm_mday + index_spinBox_correction_hijri;
    month = t_ptr->tm_mon  + 1;
    year	 = t_ptr->tm_year + 1900;

    // Convert using hijri code from meladi to hijri
    error_code = h_date(&mydate, day, month, year);

    error_code = g_date(&mydate2, mydate.day, mydate.month, mydate.year);

    // x = G2H(&mydate, day, month, year);

    //---------------------HAF 7-1-2016-------------------------------------
    //monthHijri=mydate.month;
    //------------
    outputtexhigri="";
    strDaysEvent="";

    QString strhijri = tr("%1 %2 %3 H.Y")
            .arg(mydate.day)
            .arg(mydate.to_mname)
            .arg(mydate.year);

    outputtexhigri.append(strhijri);

    QString strmydate_day= QString("%1")
            .arg(mydate.day);

    //--------------HAF 15-4-2021---------------
    sDate mydateaddoneday;
    int dayaddoneday;
    int error_codeaddoneday = 0;
    dayaddoneday   = t_ptr->tm_mday + index_spinBox_correction_hijri+1;
    error_codeaddoneday = h_date(&mydateaddoneday, dayaddoneday, month, year);
    //------------------------------------------
    if (mydate.month==9 || (mydate.month==8 && mydateaddoneday.day==1)) // HAF 15-4-2021
    {
        boolisRamathan=true;
    }else{
        boolisRamathan=false;
    }

    //--25-9-2010-----pas imsak le dernier jour de Ramathan
    if (strmydate_day==QString("30") && mydate.month==9)
    {
        // ui->stackedWidget_event_Imsak->setCurrentIndex(0);
    }
    if (strmydate_day==QString("1") && mydate.month==1)
    {
        strDaysEvent=tr("ToDay's Event: Islamic New Year");
    }
    if (strmydate_day==QString("8") && mydate.month==1)
    {
        strDaysEvent=tr("After tomorrow's Event: Aashura, it is recommended to fasted and the day before");
    }
    if (strmydate_day==QString("9") && mydate.month==1)
    {
        strDaysEvent=tr("Tomorrow's Event: Aashura, it is recommended to fasted");
    }
    if (strmydate_day==QString("10") && mydate.month==1)
    {
        strDaysEvent=tr("ToDay's Event: Aashura, it is recommended to fasted");
    }
    if (strmydate_day==QString("12") && mydate.month==3)
    {
        strDaysEvent=tr("ToDay's Event: Birth of the Prophet (Sala ELLAH alihi wasalam)");
    }
    if (strmydate_day==QString("20") && mydate.month==3)
    {
        strDaysEvent=tr("ToDay's Event: Liberation of Bait AL-Maqdis by Omar Ibn Al-Khattab (15 A.H)");
    }
    if (strmydate_day==QString("25") && mydate.month==4)
    {
        strDaysEvent=tr("ToDay's Event: Battle of Hitteen (583 A.H)");
    }
    if (strmydate_day==QString("5") && mydate.month==5)
    {
        strDaysEvent=tr("ToDay's Event: Battle of Muatah (8 A.H)");
    }
    if (strmydate_day==QString("27") && mydate.month==7)
    {
        strDaysEvent=tr("ToDay's Event: Salahuddin liberates Bait Al-Maqdis from crusaders");
    }
    if (strmydate_day==QString("14") && mydate.month==8)
    {
        strDaysEvent=tr("ToDay's Event: Battle of Qadisiah (14 A.H)");
    }
    if (strmydate_day==QString("1") && mydate.month==9)
    {
        strDaysEvent=tr("ToDay's Event: First day of month-long Fasting (Ramathan)");
    }
    if (strmydate_day==QString("17") && mydate.month==9)
    {
        strDaysEvent=tr("ToDay's Event: Battle of Badr (2 A.H)");
    }
    if (strmydate_day==QString("20") && mydate.month==9)
    {
        strDaysEvent=tr("ToDay's Event: beginning of the last ten days of Ramathan");
    }
    if (strmydate_day==QString("21") && mydate.month==9)
    {
        strDaysEvent=tr("ToDay's Event: Liberation of Makkah (8 A.H)");
    }
    if (strmydate_day==QString("1") && mydate.month==10)
    {
        strDaysEvent=tr("ToDay's Event: Eid Al-Fitr");
    }
    if (strmydate_day==QString("6") && mydate.month==10)
    {
        strDaysEvent=tr("ToDay's Event: Battle of Uhud (3 A.H)");
    }
    if (strmydate_day==QString("10") && mydate.month==10)
    {
        strDaysEvent=tr("ToDay's Event: Battle of Hunian (8 A.H)");
    }
    if (strmydate_day==QString("8") && mydate.month==12)
    {
        strDaysEvent=tr("ToDay's Event: Hajj to Makkah - day #1");
    }
    if (strmydate_day==QString("9") && mydate.month==12)
    {
        strDaysEvent=tr("ToDay's Event: Day of Arafah, it is recommended to fasted for noHajj");
    }
    if (strmydate_day==QString("10") && mydate.month==12)
    {
        strDaysEvent=tr("ToDay's Event: Hajj to Makkah - day #3 and Eid Al-Adhaa");
    }

    //---------10-6-2016------------

    if (strDaysEvent.length()==0 && settings.getValueFor("language", "")=="ar") strDaysEvent=Hikkmato_Youm();
    //------------------------------
}

//void calcul::TafasilHadath()
//{

//sDate mydate;
//int day, month, year;
//time_t mytime;
//struct tm *t_ptr;

//time(&mytime);

//t_ptr = localtime(&mytime);


////int dg, mg, yg;
////int dh, mh, yh;
//int x;

////int weekday;

////int yy = 1424;
////int mm = 11;
////int dd = 11;

//int index_spinBox_correction_hijri=ui->spinBox_correction_hijri->value();

//day   = t_ptr->tm_mday + index_spinBox_correction_hijri;
//month = t_ptr->tm_mon  + 1;
//year	 = t_ptr->tm_year + 1900;

//x = G2H(&mydate, day, month, year);

//ui->tabWidget_Athan->setCurrentIndex(2);

//if (mSound_MediaObject->state()!=Phonon::PlayingState)
//{
// ui->stackedWidget_ok_athkar_athan_ikama_stop->setCurrentIndex(0);
// ui->timeEdit_AthanDoaa_playTime->hide();
// ui->label_time->hide();
// ui->timeEdit_AthanDoaa_stopTime->hide();
// ui->SeekSlider_Athan_2->hide();
//}

//QString strmydate_day= QString("%1")
//.arg(mydate.day);

//if (strmydate_day==QString("1") && mydate.month==1)
//        {
//        ui->label_messages_titre->setText(tr("حدث اليوم : بداية السنة الهجرية"));
//        ui->label_messages->setText(tr("هو اليوم الذي هجر فيه محمد صلى الله عليه وسلم من المكة الى المدينة"));
//        }

//if ((strmydate_day==QString("8") || strmydate_day==QString("9") || strmydate_day==QString("10"))  && mydate.month==1)
//        {
//        if (strmydate_day==QString("8") )
//                {
//                ui->label_messages_titre->setText(tr("حدث بعد الغد : عاشوراء"));
//                }
//        if (strmydate_day==QString("9") )
//                {
//                ui->label_messages_titre->setText(tr("حدث الغد : عاشوراء"));
//                }
//        if (strmydate_day==QString("10") )
//                {
//                ui->label_messages_titre->setText(tr("حدث اليوم : عاشوراء"));
//                }
//        ui->label_messages->setText(tr("أولا ـ تعريف اسم عاشوراء : "
//                        "\n"
//                        "\n"
//        "كذا بالمد على المشهور وحكى القلعي قصرهما فتعقبه النووي بقوله : وهو شاذ أو باطل."
//        "وقال القاضي عياض في (مشارق الأنوار): عاشوراء اسم إسلامي لا يعرف في الجاهلية، لأنه ليس في كلامهم فاعولاء."
//        "ومعنى عاشوراء أي اليوم العاشر من المحرم."
//                        "\n"
//                        "\n"
//        "ثانيا ـ الحث على صيامه :"
//        "\n"
//        "\n"
//        "وردت جملة من الأحاديث الصحيحة التي تأكد استحباب صيام هذا اليوم ومن هذه الأحاديث:"
//        "1 ـ عن عائشة رضي الله عنها قالت : ثم كانت قريش تصوم عاشوراء في الجاهلية وكان رسول الله صلى الله عليه وسلم يصومه فلما هاجر إلى المدينة صامه وأمر بصيامه فلما فرض شهر رمضان قال من شاء صامه ومن شاء تركه . رواه الشيخان ."
//        "2 ـ وعن بن عباس ـ رضي الله عنهما ـ ثم أن رسول الله صلى الله عليه وسلم قدم المدينة فوجد اليهود صياما يوم عاشوراء فقال لهم رسول الله صلى الله عليه وسلم : (ما هذا اليوم الذي تصومونه؟!) ."
//        "فقالوا : هذا يوم عظيم أنجى الله فيه موسى وقومه وغرق فرعون وقومه فصامه موسى شكرا فنحن نصومه !"
//        "فقال رسول الله صلى الله عليه وسلم : (فنحن أحق وأولى بموسى منكم) فصامه رسول الله صلى الله عليه وسلم وأمر بصيامه. رواه الشيخان ."
//        "\n"
//        "\n"
//        "ثالثا ـ أي يوم يصام في عاشوراء :"
//        "\n"
//        "\n"
//        "يتعين على من صام يوم عاشوراء صيام يوم قبله أي (تاسوعاء) أو بعده (الحادي عشر) وذلك لما ثبت عن عبد الله بن عباس ـ رضي الله عنهما ـ قال: حين صام رسول الله صلى الله عليه وسلم يوم عاشوراء وأمر بصيامه قالوا : ثم يا رسول الله إنه يوم تعظمه اليهود والنصارى!! فقال رسول الله صلى الله عليه وسلم : (فإذا كان العام المقبل ـ إن شاء الله ـ صمنا اليوم التاسع) ."
//        "قال : فلم يأت العام المقبل حتى توفي رسول الله صلى الله عليه وسلم. رواه مسلم ."
//        "\n"
//        "\n"
//        "رابعا ـ ثواب من صام عاشوراء :"
//        "\n"
//        "\n"
//        "بين ذلك ما ثبت عن أبي قتادة قال مرفوعا: (صيام يوم عرفة أحتسب على الله أن يكفر السنة التي قبله والسنة التي بعده وصيام يوم عاشوراء أحتسب على الله أن يكفر السنة التي قبله ."
//        "\n"
//        "رواه مسلم-."));
//        }
//if (strmydate_day==QString("12") && mydate.month==3)
//        {
//        ui->label_messages_titre->setText(tr("حدث اليوم : مولد الرسول محمد صلى الله عليه وسلم"));
//        ui->label_messages->setText(tr("للعظماء شأنهم المبكر منذ ولادتهم، فكيف إذا كان العظيم هو محمد صلى الله عليه وسلم، سيد الخلق، وأفضل الرسل، وخاتم الأنبياء، الذي أحاطته الرعاية الربانية، والعناية الإلهية، وهيأ الله له الظروف مع صعوبتها، وحماه من الشدائد مع حدتها، وسخر له القلوب مع كفرها وضلالها."
//                        "\n"
//                        "\n"
//        "ولد صلى الله عليه وسلم يتيم الأب، حيث فقد أباه قبل مولده، وقد أشار القرآن إلى يتمه، فقال تعالى: { ألم يجدك يتِيما فآوى } (الضحى:6)، وقال أنس رضي الله عنه: ( ولدت آمنة رسول الله صلى الله عليه وسلم بعد ما توفي أبوه) رواه مسلم."
//        "\n"
//        "\n"
//        "وكان مولده صلى الله عليه وسلم بشعب بني هاشم في مكة المكرمة صبيحة يوم الاثنين الثاني عشر من شهر ربيع الأول، الموافق العشرين أو الثاني والعشرين من شهر إبريل سنة 571م، وقيل إنه ولد في العاشر من ربيع الأول، وقيل في الثاني من ربيع الأول، وقد ولد في أشرف بيت من بيوت العرب، فهو من أشرف فروع قريش، وهم بنو هاشم."
//        "\n"
//        "\n"
//        "وكان استبشار جده عبدالمطلب بولادته كبيرا، وفرحه بحفيده كثيرا، وأعلن ذلك بين الملأ من خلال قيامه بالواجب نحو اليتيم، واختياره له الاسم الجميل -محمد- ولم يكن معروفاً عند العرب."
//        "\n"
//        "\n"
//        "وكانت ولادته عام الفيل، بعد الحادثة المشهورة التي ذكرها الله - عز وجل- في كتابه، قال تعالى: { ألم تر كيف فعل ربك بأصحاب الفيل } (الفيل:1)، ويرى ابن القيم أن حادثة الفيل كانت توطئة وإرهاصاً لظهوره صلى الله عليه وسلم، حيث دفع الله نصارى الحبشة عن الكعبة، دون حولٍ من العرب المشركين، تعظيماً لبيته."
//        "\n"
//        "\n"
//        "وأول من أرضع رسول الله صلى الله عليه وسلم بعد أمه، ثويبة مولاة أبي لهب التي أرضعت حمزة أيضاً، ولما كانت عادة حواضر العرب أن يرسلوا أبنائهم إلى البادية للرضاعة، إبعادا لهم عن أمراض الحواضر، ومن أجل تقوية أجسامهم، وإتقان اللسان العربي في مهدهم، دُفع بمحمد إلى حليمة السعدية من بني سعد، التي نالت الخير والبركة بذلك النبي المبارك، فأمضى رسول الله صلى الله عليه وسلم السنوات الأربع الأولى من طفولته في صحراء بني سعد، فنشأ قوي البنية، سليم الجسم، فصيح اللسان، جريء الجنان، يُحسن ركوب الخيل على صغر سنه، صلى الله عليه وسلم."
//        "\n"
//        "\n"
//        "ثم جاءت حادثة شق الصدر، والتي كانت في بادية بني سعد وعمره آنذاك أربع سنين كما ذكر أهل السير، فقد روى مسلم عن أنس ‏ رضي الله عنه‏ أن رسول الله صلى الله عليه وسلم أتاه جبريل، وهو يلعب مع الغلمان، فأخذه فصرعه، فشق عن قلبه، فاستخرج القلب، فاستخرج منه علقة، فقال‏:‏ هذا حظ الشيطان منك، ثم غسله في طَسْت من ذهب بماء زمزم، ثم لأَمَه ـ أي جمعه وضم بعضه إلى بعض ـ ثم أعاده في مكانه، وجاء الغلمان يسعون إلى أمه ـ يعنى مرضعته ـ فقالوا‏:‏ إن محمدًا قد قتل، فاستقبلوه وهو مُنْتَقِعُ اللون ـ أي متغير اللون ـ قال أنس‏ :‏ وقد كنت أرى أثر ذلك المخيط في صدره‏ .‏ "
//        "\n"
//        "\n"
//        "وبهذه الحادثة الكريمة، نال -صلى الله عليه وسلم- شرف التطهير من حظ الشيطان ووساوسه، مع ما حباه الله به من حفظ وبعد عن أدران الشرك وعبادة الأصنام، فكان تهيؤه للنبوة والوحي منذ الصغر."
//        "\n"
//        "\n"
//        "وبعد هذه الحادثة خشيت مرضعته عليه فأعادته إلى أمه الحنون، كي يلقى الرعاية والاهتمام منها."
//        "\n"
//        "\n"
//        "ثم ظل رسول الله -صلى الله عليه وسلم- في رعاية أمه آمنة بنت وهب وكفالة جده عبدالمطلب ، إلى أن توفيت في الأبواء بين مكة والمدينة، وكان عمره آنذاك ست سنين."
//        "\n"
//        "\n"
//        "ثم قام بالاعتناء به جده عبدالمطلب إلى أن توفي وكان عمر النبي صلى الله عليه وسلم ثمان سنوات، فوصى به إلى عمه أبي طالب، وظل تحت رعاية عمه إلى قبيل الهجرة بثلاث سنوات."
//        "\n"
//        "\n"
//        "ولما بلغ الأربعين بُعث للعالمين، بشيرا ونذيرا، وداعيا إلى الله بإذنه وسراجا منيرا."
//        "\n"
//        "\n"
//        "لقد كان مولد النبي -صلى الله عليه وسلم- وبعثته مولدا لنور الإسلام، وضياء الحق المبين، الذي تبددت به ظلمات الشرك والكفر، وزال به الران الذي طُبع على قلوب كثير من الناس."
//        "\n"
//        "\n"
//        "وإنك لتعجب من أناس فرقوا بين النورين، وخالفوا بين الأمرين، فهم يتذكرون ولادته -صلى الله عليه وسلم- ولا ينسونها، وفي المقابل تجدهم تاركيين لجملة من شريعته، ومقصرين في اتباع هديه صلى الله عليه وسلم، مع أن أمر الصحابة رضي الله عنهم ومن بعدهم على خلاف ذلك، فقد تمسكوا بهذا الدين، وقاموا به خير قيام، حتى كانت حياتهم ومماتهم لأجل هذا الدين، ولأجل تلك العقيدة."
//        "\n"
//        "\n"
//        "لقد عرف الصحابة رضي الله عنهم كيف يعبرون عن فرحتهم برسول الله -صلى الله عليه وسلم-، وبالنور الذي جاء به، فبذلوا أموالهم وأنفسهم في سبيل الدين، فتقبلهم ربهم بقبول حسن، وأسكنهم جنات عدن التي وعدهم، ثم جاء أقوام بعدهم فجعلوا فرحهم برسول الله -صلى الله عليه وسلم- وبالنور الذي جاء به مقتصرا على احتفالات محدثة وأفعال جوفاء، وترانيم هزيلة، لا تفي بقدر هذا الدين، وما يتطلبه من بذل وتضحية، فلم يوفوا حق نبيهم، ولم يقتدوا بسلفهم، وأنت ترى ما عليه المسلمون اليوم من تعلق بظواهر ومناسبات، وتركهم اللب والمهمات."
//        "\n"
//        "\n"
//        "فحري بنا أن تكون ذكرانا لمولد نبينا -صلى الله عليه وسلم- كل يوم، وأن تكون هذه الذكرى ذكرى لسيرته وشريعته، وأن يدفعنا ذلك إلى الاقتداء بسنته والاهتداء بهديه في سائر شؤون حياتنا، وصدق الله إذ يقول {لقد كان لكم في رسول الله أسوة حسنة لمن كان يرجو الله واليوم الآخر وذكر الله كثيرا } (الأحزاب:21) ."));
//        }

//if (strmydate_day==QString("20") && mydate.month==3)
//        {
//        ui->label_messages_titre->setText(tr("حدث اليوم : فتح عمر رضي الله عنه بيت المقدس"));
//        ui->label_messages->setText(tr("في هذا اليوم وفي عام 15 للهجرة فتح الخليفة عمر بن الخطاب رضي الله عنه بيت المقدس"));
//        }

//if (strmydate_day==QString("25") && mydate.month==4)
//        {
//        ui->label_messages_titre->setText(tr("حدث اليوم : معركة حطين"));
//        ui->label_messages->setText(tr("في هذا اليوم وفي عام 583 للهجرة وقعت معركة حطين"));
//        }

//if (strmydate_day==QString("5") && mydate.month==5)
//        {
//        ui->label_messages_titre->setText(tr("حدث اليوم : معركة مؤته"));
//        ui->label_messages->setText(tr("في هذا اليوم وفي عام 8 للهجرة وقعت معركة مؤته"));
//        }
//if (strmydate_day==QString("27") && mydate.month==7)
//        {
//        ui->label_messages_titre->setText(tr("حدث اليوم : حرر صلاح الدين بيت المقدس من الصلبين وهو كذلك يوم الاسراء والمعراج"));
//        ui->label_messages->setText(tr("في هذا اليوم اسري واعرج بنبينا محمد صلى الله عليه وسلم وهو كذلك اليوم الذي حرر صلاح الدين فيه بيت المقدس من الصلبين"
//       "\n"
//       "\n"
//       "كانت رحلة الإسراء اختباراً جديداً للمسلمين في إيمانهم ويقينهم، وفرصة لمشاهدة النبي – صلى الله عليه وسلم - عجائب القدرة الإلهية، والوقوف على حقيقة المعاني الغيبيّة، والتشريف بمناجاة الله في موطنٍ لم يصل إليه بشرٌ قطّ، إضافةً إلى كونها سبباً في تخفيف أحزانه وهمومه، وتجديد عزمه على مواصلة دعوته والتصدّي لأذى قومه. فقد شهدت الأيّام السابقة لتلك الرحلة العديد من الابتلاءات، كان منها موت زوجته خديجة بنت خويلد رضي الله عنها، والتي كانت خير عونٍ له في دعوته، ثم تلاها موت عمّه أبي طالب، ليفقد بذلك الحماية التي كان يتمتّع بها، حتى تجرّأت قريشٌ على إيذائه – صلى الله عليه وسلم – والنيل منه، ثم زادت المحنة بامتناع أهل الطائف عن الاستماع له، والقيام بسبّه وطرده، وإغراء السفهاء لرميه بالحجارة، مما اضطرّه للعودة إلى مكّة حزيناً كسير النفس. "
//       "\n"
//       "\n"
//      " ومع اشتداد المحن وتكاثر الأحزان، كان النبي – صلى الله عليه وسلم – في أمسّ الحاجة إلى ما يعيد له طمأنينته، ويقوّي من عزيمته، فكانت رحلة الإسراء والمعراج، حيث أُسري به – صلى الله عليه وسلم - إلى بيت المقدس، ثم عُرج به إلى السماوات العُلى، ثم عاد في نفس اليوم ."
//      "\n"
//      "\n"
//      " وتبدأ القصّة عندما نزل جبريل إلى النبي – صلى الله عليه وسلم – بصحبة ملكين آخَريْن، فأخذوه وشقّوا صدره، ثم انتزعوا قلبه وغسلوه بماء زمزم، ثم قاموا بملء قلبه إيماناً وحكمة، وأعادوه إلى موضعه ."
//      "\n"
//      "\n"
//      " ثم جاء جبريل عليه السلام بالبراق، وهي دابّة عجيبة تضع حافرها عند منتهى بصرها، فركبه النبي - صلى الله عليه وسلم – وانطلقا معاً، إلى بيت المقدس ."
//      "\n"
//      "\n"
//      " وفي هذه المدينة المباركة كان للنبي - صلى الله عليه وسلم – موعدٌ للقاء بإخوانه من الأنبياء عليهم السلام، فقد اصطحبه جبريل عليه السلام إلى المسجد الأقصى، وعند الباب ربط جبريل البراق بالحلقة التي يربط بها الأنبياء جميعاً، ثم دخلا إلى المسجد، فصلّى النبي – صلى الله عليه وسلم – بالأنبياء إماماً، وكانت صلاته تلك دليلاً على مدى الارتباط بين دعوة الأنبياء جميعاً من جهة، وأفضليّته عليهم من جهة أخرى ."
//      "\n"
//      "\n"
//      " ثم بدأ الجزء الثاني من الرّحلة، وهو الصعود في الفضاء وتجاوز السماوات السبع، وكان جبريل عليه السلام يطلب الإذن بالدخول عند الوصول إلى كلّ سماءٍ، فيؤذن له وسط ترحيب شديد من الملائكة بقدوم سيد الخلق وإمام الأنبياء – صلى الله عليه وسلم - ."
//      "\n"
//      "\n"
//      " وفي السماء الدنيا، التقى – صلى الله عليه وسلم – بآدم عليه السلام، فتبادلا السلام والتحيّة، ثم دعا آدم له بخيرٍ، وقد رآه النبي – صلى الله عليه وسلم – جالساً وعن يمينه وشماله أرواح ذريّته، فإذا التفت عن يمينه ضحك، وإذا التفت عن شماله بكى، فسأل النبي – صلى الله عليه وسلم – جبريل عن الذي رآه، فذكر له أنّ أولئك الذين كانوا عن يمينه هم أهل الجنّة من ذرّيّته فيسعد برؤيتهم، والذين عن شماله هم أهل النار فيحزن لرؤيتهم ."
//      "\n"
//      "\n"
//     "  ثم صعد النبي– صلى الله عليه وسلم – السماء الثانية ليلتقي ب عيسى و يحيى عليهما السلام، فاستقبلاهُ أحسن استقبالٍ وقالا :  مرحباً بالأخ الصالح والنبيّ الصالح  ."
//     "\n"
//     "\n"
//      " وفي السماء الثالثة، رأى النبي– صلى الله عليه وسلم – أخاه يوسف عليه السلام وسلّم عليه، وقد وصفه عليه الصلاة والسلام بقوله : ( ..وإذا هو قد أعطي شطر الحسن ) رواه مسلم ."
//      "\n"
//      "\n"
//      " ثم التقى بأخيه إدريس عليه السلام في السماء الرابعة، وبعده هارون عليه السلام في السماء الخامسة ."
//      "\n"
//      "\n"
//      " ثم صعد جبريل بالنبي– صلى الله عليه وسلم – إلى السماء السادسة لرؤية أخيه موسى عليه السلام، وبعد السلام عليه بكى موسى فقيل له :  ما يبكيك ؟، فقال :  أبكي ؛ لأن غلاماً بُعث بعدي، يدخل الجنة من أمته أكثر ممن يدخلها من أمتي  . "
//      "\n"
//      "\n"
//      " ثمّ كان اللقاء بخليل الرحمن إبراهيم عليه السلام في السماء السابعة، حيث رآه مُسنِداً ظهره إلى البيت المعمور - كعبة أهل السماء - الذي يدخله كل يوم سبعون ألفاً من الملائكة لا يعودون إليه أبداً، وهناك استقبل إبراهيم عليه السلام النبي – صلى الله عليه وسلم – ودعا له، ثم قال : ( يا محمد، أقرئ أمتك مني السلام، وأخبرهم أن الجنة طيبة التربة، عذبة الماء، وأنها قيعان، وأن غراسها : سبحان الله، والحمد لله، ولا إله إلا الله، والله أكبر ) رواه الترمذي . "
//      "\n"
//      "\n"
//     "  وبعد هذه السلسلة من اللقاءات المباركة، صعد جبريل عليه السلام بالنبي– صلى الله عليه وسلم – إلى سدرة المنتهى، وهي شجرةٌ عظيمة القدر كبيرة الحجم، ثمارها تُشبه الجرار الكبيرة، وأوراقها مثل آذان الفيلة، ومن تحتها تجري الأنهار، وهناك رأى النبي– صلى الله عليه وسلم – جبريل عليه السلام على صورته الملائكيّة وله ستمائة جناح، يتساقط منها الدرّ والياقوت ."
//     "\n"
//     "\n"
//     "  ثم حانت أسعد اللحظات إلى قلب النبي – صلى الله عليه وسلم -، حينما تشرّف بلقاء الله والوقوف بين يديه ومناجاته، لتتصاغر أمام عينيه كل الأهوال التي عايشها، وكل المصاعب التي مرّت به، وهناك أوحى الله إلى عبده ما أوحى، وكان مما أعطاه خواتيم سورة البقرة، وغفران كبائر الذنوب لأهل التوحيد الذين لم يخلطوا إيمانهم بشرك، ثم فَرَض عليه وعلى أمّته خمسين صلاة في اليوم والليلة ."
//     "\n"
//     "\n"
//      " وعندما انتهى – صلى الله عليه وسلم – من اللقاء الإلهيّ مرّ في طريقه بموسى عليه السلام، فلما رآه سأله : ( بم أمرك ؟ )، فقال له : ( بخمسين صلاة كل يوم )، فقال موسى عليه السلام : ( أمتك لا تستطيع خمسين صلاة كل يوم، وإني والله قد جربت الناس قبلك فارجع إلى ربك فاسأله التخفيف )، فعاد النبي صلى الله عليه وسلم – إلى ربّه يستأذنه في التخفيف فأسقط عنه بعض الصلوات، فرجع إلى موسى عليه السلام وأخبره، فأشار عليه بالعودة وطلب التخفيف مرّةً أخرى، وتكرّر المشهد عدّة مرّات حتى وصل العدد إلى خمس صلواتٍ في اليوم والليلة، واستحى النبي – صلى الله عليه وسلّم أن يسأل ربّه أكثر من ذلك، ثم أمضى الله عزّ وجل الأمر بهذه الصلوات وجعلها بأجر خمسين صلاة ."
//      "\n"
//      "\n"
//      " وقد شاهد النبي – صلى الله عليه وسلم – في هذه الرحلة الجنّة ونعيمها، وأراه جبريل عليه السلام الكوثر، وهو نهرٌ أعطاه الله لنبيّه إكراماً له، حافّتاه والحصى الذي في قعره من اللؤلؤ، وتربته من المسك، وكان عليه الصلاة والسلام كلما مرّ بملأ من الملائكة قالوا له :  يا محمد، مر أمتك بالحجامة  ."
//      "\n"
//      "\n"
//      " وفي المقابل، وقف النبي – صلى الله عليه وسلم – على أحوال الذين يعذّبون في نار جهنّم، فرأى أقواماً لهم أظفار من نحاس يجرحون بها وجوههم وصدورهم، فسأل جبريل عنهم فقال :  هؤلاء الذين يأكلون لحوم الناس، ويقعون في أعراضهم، ورأى أيضاً أقواماً تقطّع ألسنتهم وشفاههم بمقاريض من نار، فقال له جبريل عليه السلام :  هؤلاء خطباء أمتك من أهل الدنيا، كانوا يأمرون الناس بالبر وينسون أنفسهم وهم يتلون الكتاب، أفلا يعقلون ؟  ."
//      "\n"
//      "\n"
//      " ورأى شجرة الزّقوم التي وصفها الله تعالى بقوله : { والشجرة الملعونة في القرآن } ( الإسراء : 60 )، وقوله : { إنها شجرة تخرج في أصل الجحيم، طلعها كأنه رءوس الشياطين } ( الصافات : 64 – 65 ) ."
//      "\n"
//      "\n"
//     "  ورأى مالكاً خازن النار، ورأى المرأة المؤمنة التي كانت تمشط شعر ابنة فرعون، ورفضت أن تكفر بالله فأحرقها فرعون بالنار، ورأى الدجّال على صورته، أجعد الشعر، أعور العين، عظيم الجثّة، أحمر البشرة، مكتوب بين عينيه  كافر ."
//     "\n"
//     "\n"
//      " وفي تلك الرحلة جاءه جبريل عليه السلام بثلاثة آنية، الأوّل مملوء بالخمر، والثاني بالعسل، والثالث باللبن، فاختار النبي – صلى الله عليه وسلم – إناء اللبن فأصاب الفطرة، ولهذا قال له جبريل عليه السلام :  أما إنك لو أخذت الخمر غوت أمتك.  رواه البخاري ."
//      "\n"
//      "\n"
//      " وبعد هذه المشاهدات، عاد النبي – صلى الله عليه وسلم – إلى مكّة، وأدرك أن ما شاهده من عجائب، وما وقف عليه من مشاهد، لن تتقبّله عقول أهل الكفر والعناد، فأصبح مهموماً حزيناً، ولما رآه أبوجهل على تلك الحال جاءه وجلس عنده ثم سأله عن حاله، فأخبره النبي – صلى الله عليه وسلم – برحلته في تلك الليلة، ورأى أبو جهل في قصّته فرصةً للسخرية والاستهزاء، فقال له : أرأيت إن دعوت قومك أتحدثهم بما حدثتني ؟، فقال له النبي – صلى الله عليه وسلم – : ( نعم )، فانطلق أبو جهل ينادي بالناس ليسمعوا هذه الأعجوبة، فصاحوا متعجّبين، ووقفوا ما بين مكذّب ومشكّك، وارتدّ أناسٌ ممن آمنوا به ولم يتمكّن الإيمان في قلوبهم، وقام إليه أفرادٌ من أهل مكّة يسألونه عن وصف بيت المقدس، فشقّ ذلك على النبي – صلى الله عليه وسلم – لأن الوقت الذي بقي فيه هناك لم يكن كافياً لإدراك الوصف، لكنّ الله سبحانه وتعالى مثّل له صورة بيت المقدس فقام يصفه بدقّة بالغة، حتى عجب الناس وقالوا :  أما الوصف فقد أصاب، ثم قدّم النبي – صلى الله عليه وسلم – دليلاً آخر على صدقه، وأخبرهم بشأن القافلة التي رآها في طريق عودته ووقت قدومها، فوقع الأمر كما قال ."
//      "\n"
//      "\n"
//      " وفي ذلك الوقت انطلق نفرٌ من قريش إلى أبي بكر رضي الله عنه يسألونه عن موقفه من الخبر، فقال لهم :  لئن كان قال ذلك لقد صدق، فتعجّبوا وقالوا :  أو تصدقه أنه ذهب الليلة إلى بيت المقدس وجاء قبل أن يصبح ؟، فقال :  نعم ؛ إني لأصدقه فيما هو أبعد من ذلك، أصدقه بخبر السماء في غدوة أو روحة، فأطلق عليه من يومها لقب  الصديق  ."
//      "\n"
//      "\n"
//      " وكان في هذه المواقف المتباينة حكم إلهيّة عظيمة، ففي تصديق أبي بكر رضي الله عنه إبرازٌ لأهميّة الإيمان بالغيب والتسليم له طالما صحّ فيه الخبر، وفي ردّة ضعفاء الإيمان تمحيصٌ للصفّ الإسلامي من شوائبه، حتى يقوم الإسلام على أكتاف الرّجال الذين لا تهزّهم المحن أو تزلزلهم الفتن، وفي تكذيب كفار قريشٍ للنبي – صلى الله عليه وسلم – وتماديها في الطغيان والكفر تهيئةٌ من الله سبحانه لتسليم القيادة إلى القادمين من المدينة، وقد تحقّق ذلك عندما طاف النبي – صلى الله عليه وسلم – على القبائل طلباً للنصرة، فالتقى بهم وعرض عليهم الإسلام، فبادروا إلى التصديق والإيمان، ليكونوا سبباً في قيام الدولة الإسلامية وانتشار دعوتها في الجزيرة العربية ."));
//        }
//if (strmydate_day==QString("14") && mydate.month==8)
//        {
//        ui->label_messages_titre->setText(tr("حدث اليوم : معركة القادسية"));
//        ui->label_messages->setText(tr(":في هذا اليوم وفي عام 14 للهجرة وقعت معركة القادسية"
//                        "\n"
//                        "\n"
//        " إنها واحدة من أعظم معارك الإسلام، إن لم تكن أعظمها فيما بعد الحقبة النبوية، ولا نجد لها وصفًا أصدق ولا أدق من مقولة الصحابي الجليل «جابر بن عبد الله»: «والله الذي لا إله إلا هو ما اطلعنا على أحد من أهل القادسية أنه يريد الدنيا مع الآخرة».\
//        أما عن سبب هذه المعركة العظمى، فيرجع في الأساس لرغبة الفرس في تحقيق نصر حاسم وكبير على المسلمين، ينهي وجودهم بالعراق، ويرفع الروح المعنوية للجيوش الفارسية التي نالت هزائم كثيرة ومتتالية من المسلمين، لذلك توحد الفرقاء والخصوم من قادة الفرس، وأزالوا كل أسباب الخلاف بينهم، وانتخبوا «يزدجرد» زعيمًا للبلاط الفارسي، وفوضوا أمهر القادة الفرس وهو «رستم» في التحضير لمعركة فاصلة مع المسلمين.\
//        وما إن سمع أهل السواد بالعراق عن أخبار الحملة الفارسية الضخمة، حتى خلعوا طاعة المسلمين ونقضوا عهدهم، فأرسل «المثنى بن حارثة» قائد المسلمين بالعراق برسالة للخليفة عمر بن الخطاب يخبره بصورة الحال، وأن جيش الفرس يتجاوز مائتي ألف مقاتل، فأعلن الخليفة النفير العام للمسلمين ولأول مرة يعلن خليفة مسلم التجنيد الإلزامي للمسلمين في قبائل معينة وهي قبائل «ربيعة»، و«بجيلة»، و«النخع» وسمح لأهل الردة الذين تابوا بالاشتراك في المعركة، حيث كان الخليفة أبو بكر قد فرض عليهم حظرًا تأديبيًا لهم، وبعد أن اجتمعت الجيوش الإسلامية عزم الخليفة «عمر» أن يخرج بنفسه لقيادة الجيوش، ولكن كبار الصحابة أثنوه عن ذلك، لحاجة الأمة له، وأشاروا عليه بتولية رجل من كبار الصحابة من السابقين الأولين، فاختار لهذه المهمة «سعد بن أبي وقاص».\
//        اجتمع عند سعد بن أبي وقاص بالقادسية قرابة الستة والثلاثين ألفًا، في صفر سنة 14هـ وظل هذا الجيش مرابطًا بالقادسية بناءً على أوامر الخليفة «عمر» بعدم تعجل الصدام مع الفرس، وواجه المسلمون مشكلة كبيرة في الإمدادات والغذاء، بسبب غدر أهل السواد الذين خلعوا طاعة المسلمين وفرضوا حصارًا اقتصاديًا، ولكن كرامة هائلة حدثت عندما تكلم الحيوان البهيم ودل المسلمين على مكان قطعان الماشية المخبأة، فانتفع بها المسلمون وتقووا على عدوهم.\
//        دارت مراسلات عديدة بين المسلمين والفرس، حيث حرص المسلمون على توضيح رسالتهم والهدف من جهادهم، فأرسل سعد بن أبي وقاص سفارة لكسرى الفرس «يزدجرد»، فاستهان بهم وأساء معهم الأدب والتعامل، ثم طلب «رستم» من «سعد» أن يرسل إليه سفراء يتناقش معهم فأرسل إليه «سعد» ثلاثة رجال من عنده الواحد تلو الآخر، وهم «ربعي بن عامر»، ثم «حذيفة بن محصن»، ثم «المغيرة بن شعبة»، وكان لرستم هدف شرير من هذه السفارات، حيث كان يرمي لإصابة المسلمين بالهزيمة النفسية، عندما يرى السفراء مدى القوة والأبهة والعظمة التي عليها الجيوش الفارسية، ولكن المسلمين الثلاثة الذين تربوا في مدرسة النبوة العليا، أظهروا نفس رد الفعل من الاستعلاء بالإيمان، واحتقار مباهج الدنيا وزخارفها، والعزة بالدين، فبطل كيد رستم وحبط سعيه، وكان رستم يهدف أيضًا من هذه المراسلات تطويل المدة وتأخير الصدام الوشيك مع المسلمين، لأنه كان رجلاً حكيمًا عاقلاً بصيرًا بالحروب، وقد داخله الخوف، وغلب عليه الظن، أن النصر سيكون حليف المسلمين.\
//        وربما لا يعرف الكثيرون أن معركة القادسية كانت عدة أيام، وليست يومًا واحدًا، وقد تغيرت فيها كفة القتال من طرف لآخر، وهي كالتالي:\
//        "
//        "\n"
//                        "\n"
//        "اليوم الأول: يوم أرماث 14 شعبان:"
//        "\n"
//                        "\n"
//        "كان جيش المسلمين يقدر بستة وثلاثين ألفًا يقودهم الأسد «سعد بن أبي وقاص»، ويقدر جيش الفرس بمائتين وأربعين ألفًا يقودهم «رستم» ومعهم سلاح المدرعات المكون من ثلاثة وثلاثين فيلاً ضخمًا، ووقع الصدام الهائل في أول يوم عندما هجم الفرس بكل قوتهم وركزوا هجومهم الكاسح على قبيلة «بجيلة» حيث كانت تمثل خمس الجيش تقريبًا، وكان السر وراء ذلك التركيز الهجومي من جانب الفرس، هو أن رجلاً من ثقيف خان المسلمين في أحرج ساعاتهم وارتد عن دين الإسلام والتحق بالعدو، ودلهم على مكمن القوة في جيش المسلمين.\
//        أصدر «سعد» قرارًا سريعًا لإنقاذ «بجيلة» فأمر قبيلة «أسد» وقبيلة «بني تميم» برد الهجوم الفارسي الضاري على «بجيلة»، وكان لسلاح الفيلة الفارسي أثر بالغ في المسلمين، ذلك لأن خيل المسلمين لم تكن قد رأت من قبل الأفيال، فنفرت منها بشدة، وقد أصدر «سعد» توجيهًا لكتيبة خاصة من أمهر الفرسان، بهدف تحطيم السروج الخشبية المقامة على ظهور الفيلة، وبالفعل نجح «عاصم بن عمرو» في مهمته، وخرج سلاح الفيلة من القتال مؤقتًا، وانتهى يوم أرماث وكان لصالح الفرس تقريبًا بسبب الخيانة وكذلك الفيلة.\
//        "
//        "\n"
//                        "\n"
//        "اليوم الثاني: يوم أغواث 15 شعبان:"
//        "\n"
//                        "\n"
//        "أصدق وصف لهذا اليوم، أنه يوم الخدع الحربية، فلقد أرسل عمر بن الخطاب إمدادات من الشام إلى المسلمين بالعراق، يقدر بستة آلاف مقاتل، وكان في مقدمة هذه الإمدادات البطل الشهيد «القعقاع بن عمرو» الذي قام بإدخال الإمدادات إلى أرض المعركة على مراحل مع إثارة أكبر قدر من الضوضاء والغبار، ليظن الفرس أن المسلمين قد جاءهم إمدادات ضخمة.\
//        وكان لقدوم «القعقاع بن عمرو» مفعول السحر في نفوس المسلمين، فقد كان بطلاً شجاعًا ماهرًا في شحذ الهمم وإثارة العزائم، فكان يوم أغواث هو يوم البطولات ويوم القعقاع كله، وفيه كان قتال أبي محجن الثقفي البطولي، بعد أن خرج من محبسه، وفيه كان استشهاد أبناء الخنساء الأربعة، وفيه كان مقتل أكبر قادة الجيش الفارسي بعد «رستم» وهو «بهمن جاذويه»، وفيه كانت الخدعة الحربية التي قام بها «القعقاع» عندما ألبس جمال المسلمين خرقًا وبرقعها بالبراقع، فصار لها منظر مخيف عندما رأتها خيل الفرس نفرت وفرت هاربة، وكان هذا اليوم كله لصالح المسلمين.\
//        "
//        "\n"
//                        "\n"
//        "اليوم الثالث: يوم عماس:"
//        "\n"
//                        "\n"
//        "هذه المهمة أربعة نفر «القعقاع بن عمرو»، وأخاه «عاصم بن عمرو»، وهما لقتل الأبيض، و«حمّال بن مالك»، و«الربيل بن عمرو» وهما لقتل الأجرب، ونجح الأبطال الأربعة في المهمة، وقد توقف القتال بعد أن قام «طليحة الأسدي» باختراق صفوف الفرس."
//        "\n"
//                        "\n"
//        "ليلة الهرير:"
//        "\n"
//                        "\n"
//        "في هذه الليلة اشتعل القتال بين المسلمين والفرس وتصافح الناس بالسيوف واشتد القتال بصورة لم ير الناس مثلها من قبل ولا في التاريخ كله، ولم يسمع ليلتها سوى هرير الناس وصليل السيوف، وقاتل المسلمون والفرس قتالاً صار مضربًا للأمثال بعدها، ومقياسًا لشدة الحروب، وشد المسلمون بكل ضراوة على قلب الجيش الفارسي، ومما يدل على شدة القتال في هذه الليلة أن المسلمين قد استشهد منهم قبل ليلة الهرير 2500 شهيد، وفي ليلة الهرير وحدها استشهد 6000 مسلم.\
//        ثم جاءت اللحظة الحاسمة في هذه المعركة الخالدة، وذلك عندما قام البطل المسلم «هلال بن علفة» بقتل القائد العام للفرس «رستم»، وبعدها انهارت معنويات الجيش الفارسي ووقعت عليهم الهزيمة الساحقة، حتى إن الشاب اليافع من المسلمين كان يسوق ثمانين رجلاً من الفرس أسرى، ويشير المسلم إلى الفارسي فيأتيه فيقتله، وربما يأخذ سلاحه الذي عليه فيقتله به، وربما أمر رجلين من الفرس فيقتل أحدهما صاحبه.\
//        وهذه المعركة قضت على معظم قوة الدولة الفارسية وكانت إيذانًا بأفول شمس إمبراطورية المجوس، وكان الناس من العرب والعجم والرومان ينتظرون ما تنجلي عنه هذه الوقعة الهائلة حتى قيل: إن الجن قد حملوا بشارات النصر في أرجاء المعمورة.\
//        "));
//        }
//if (strmydate_day==QString("1") && mydate.month==9)
//        {
//        ui->label_messages_titre->setText(tr("حدث اليوم : أول أيام رمضان المبارك"));
//        ui->label_messages->setText(tr("فضل رمضان في الأحاديث النبوية الشريفة :"
//        "\n"
//        "\n"
//        "·عن طلحة بن عبيد الله -رضي الله عنه- أن أعرابيا جاء إلى رسول الله -صلى الله عليه وسلم- ثائر الرأس فقال: يارسول الله أخبرني ماذا فرض الله علي من الصلاة، فقال: الصلوات الخمس إلا أن تطوع شيئا، فقال: أخبرني ما فرض الله علي من الصيام، فقال شهر رمضان إلا أن تطوع شيئا فقال: أخبرني بما فرض الله علي من الزكاة، فقال: فأخبره رسول الله -صلى الله عليه وسلم- شرائع الاسلام. قال: والذي أكرمك لا أتطوع شيئا ولا انقص مما فرض الله شيئا. فقال رسول الله -صلى الله عليه وسلم- أفلح إن صدق أو دخل الجنة إن صدق."
//        "\n"
//        "\n"
//        "·عن أبي هريرة -رضي الله عنه- ان رسول الله -صلى الله عليه وسلم: (إذا دخل شهر رمضان فتحت أبواب السماء وغلقت أبواب جهنم وسلسلت الشياطين)."
//        "\n"
//        "\n"
//        "·عن ابن عمر -رضي الله عنه- قال سمعت رسول الله -صلى الله عليه وسلم- يقول: (إذا رأيتموه فصوموا وإذا رايتموه فأفطروا فإن غم عليكم فاقدروا له)."
//        "\n"
//        "\n"
//        "·عن ابن عباس -رضي الله عنه- قال: كان النبي -صلى الله عليه وسلم- أجود الناس بالخير وكان أجود ما يكون في رمضان حين يلقاه جبريل، وكان جبريل عليه السلام يلقاه كل ليلة في رمضان حتى ينسلخ يعرض عليه النبي -صلى الله عليه وسلم- القرآن فإذا لقيه جبريل عليه السلام كان أجود بالخير من الريح المرسلة."
//        "\n"
//        "\n"
//        "·قال النبي -صلى الله عليه وسلم: (شهران لا ينقصان شهرا عيد رمضان وذو الحجة)."
//        "·عن أبي هريرة -رضي الله عنه- عن النبي -صلى الله عليه وسلم- قال (لا يتقدمن أحدكم رمضان بصوم يوم أو يومين إلا أن يكون رجل كان يصوم صومه فليصم ذلك اليوم)."
//        "\n"
//        "\n"
//        "·عن ابي هريرة -رضي الله عنه- جاء رجل إلى النبي -صلى الله عليه وسلم- فقال إن الأخر وقع على امرأته في رمضان فقال: أتجد ما تحرر رقبه فقال: لا. قال أفتستطيع أن تصوم شهرين متتابعين، قال:لا. قال: أفتجد ما تطعم به ستين مسكينا. قال: لا. قال: فأتى النبي -صلى الله عليه وسلم- بعرق فيه تمر وهو الزبيل قال أطعم هذا عنك قال على أحوج منا ما بين لا بتيها أهل بيت أحوج منا قال فأطعمه اهلك."
//        "\n"
//        "\n"
//        "·عن عائشة -رضي الله عنها- قالت: كان رسول الله -صلى الله عليه وسلم- يصوم حتى نقول لا يفطر، ويفطر حتى نقول لا يصوم، فما رأيت رسول الله -صلى الله عليه وسلم- استكمل صيام شهر إلا رمضان، وما رأيته أكثر صياما منه في شعبان."
//        "\n"
//        "\n"
//        "·عن أبي هريرة -رضي الله عنه- أن رسول الله -صلى الله عليه وسلم- قال: (من قام رمضان إيماناً واحتساباً غفر له ما تقدم من ذنبه) قال ابن شهاب فتوفي رسول الله صلى الله عليه وسلم والأمر على ذلك ثم كان المر على ذلك في خلافة ابي بكر وصدرا من خلافة عمر رضي الله عنهما."
//        "\n"
//        "\n"
//        "·عن أبي سلمة بن عبدالرحمن أنه سأل عائشة رضي الله عنها: كيف كانت صلاة رسول الله -صلى الله عليه وسلم- في رمضان فقالت ما كان يزيد في رمضان ولا في غيره على إحدى عشرة ركعة يصلي أربعا فلا تسل عن حسنهن وطولهن ثم يصلي أربعا فلا تسل عن حسنهن وطولهن ثم يصلي ثلاثا فقلت يارسول الله أتنام قبل أن توتر قال ياعائشة إن عيني تنامان ولا ينام قلبي."
//        "\n"
//        "\n"
//        "·عن أبي هريرة -رضي الله عنه- عن النبي -صلى الله عليه وسلم- قال: (من صام رمضان إيمانا واحتسابا غفر له ما تقدم من ذنبه ومن قام ليلة القدر إيمانا واحتسابا غفر له ما تقدم من ذنبه)."
//        "\n"
//        "\n"
//        "·عن ابن عباس -رضي الله عنه- ان النبي -صلى الله عليه وسلم- قال: (التمسوها في العشر الأواخر من رمضان ليلة القدر في تاسعة تبقى في سابعة تبقى في خامسة تبقى)."
//        "\n"
//        "\n"
//        "·عن عائشة رضي الله عنها أن النبي -صلى الله عليه وسلم- كان يعتكف العشر الأواخر من رمضان حتى توفاه الله ثم اعتكف أزواجه من بعده."
//        "\n"
//        "\n"
//        "· عن أبي هريرة -رضي الله عنه- قال: كان النبي -صلى الله عليه وسلم- يعتكف في كل رمضان عشرة أيام فلما كان العام الذي قبض فيه اعتكف عشرين يوماً."
//        "\n"
//        "\n"
//        "·عن أبي هريرة -رضي الله عنه- أن رسول الله -صلى الله عليه وسلم- كان يقول: (الصلوات الخمس والجمعة إلى الجمعة ورمضان إلى رمضان مكفرات ما بينهن إذا اجتنب الكبائر)."
//        "\n"
//        "\n"
//        "·عن ابن عمر رضي الله عنهما أن رسول الله -صلى الله عليه وسلم- فرض زكاة الفطر من رمضان على الناس صاعا من تمر أو صاعا من شعير على كل حر أو عبد ذكر أو أنثى من المسلمين."
//        "\n"
//        "\n"
//        "·وعن ابن عمر رضي الله عنهما قال فرض النبي -صلى الله عليه وسلم- صدقة رمضان على الحر والعبد والذكر والأنثى صاعا من تمر أو صاعا من شعير قال فعدل الناس به نصف صاع من بر."
//        "\n"
//        "\n"
//        "·عن أنس قال واصل رسول الله -صلى الله عليه وسلم- في أول شهر رمضان فواصل ناس من المسلمين فبلغه ذلك فقال لو مد لنا الشهر لواصلنا وصالا يدع المتعمقون تعمقهم إنكم لستم مثلي أو قال إني لست مثلكم إني أظل يطعمني ربي ويسقيني."
//        "والوصال : بمعنى وصل أيام الصيام بدون افطار"
//        "\n"
//        "\n"
//        "·عن عائشة رضي الله عنها قالت كان رسول الله -صلى الله عليه وسلم- يقبل في رمضان وهو صائم."
//        "\n"
//        "\n"
//        "·عن عائشة وام سلمة زوجي النبي -صلى الله عليه وسلم- أنهما قالتا إن كان رسول الله -صلى الله عليه وسلم- ليصبح جنبا من جماع غير احتلام في رمضان ثم يصوم."
//        "\n"
//        "\n"
//        "·عن أبي سعيد رضي الله عنه قال كنا نسافر مع رسول الله صلى الله عليه وسلم في رمضان فما يعاب على الصائم صومه ولا على المفطر إفطاره.."
//        "\n"
//        "\n"
//        "·وعن أبي سعيد رضي الله عنه قال سمعت رسول الله -صلى الله عليه وسلم- يقول: (لا يصلح الصيام في يومين، يوم الأضحى ويوم الفطر من رمضان)."
//        "\n"
//        "\n"
//        "·عن عمران بن حصين رضي الله عنه أن النبي -صلى الله عليه وسلم- قال لرجل: (هل صمت من سرر هذا الشهر شيئاً ، قال لا. فقال رسول الله صلى الله عليه وسلم: فإذا أفطرت من رمضان فصم يومين مكانه)."
//        "\n"
//        "\n"
//        "·عن أبي هريرة رضي الله عنه قال، قال رسول الله صلى الله عليه وسلم: (أفضل الصيام بعد رمضان شهر الله المحرم، وأفضل الصلاة بعد الفريضة صلاة الليل)."
//        "\n"
//        "\n"
//        "·عن علي رضي الله عنه قال سأله رجل فقال أي شهر تأمرني أن أصوم بعد شهر رمضان قال له ما سمعت أحد يسأل عن هذا إلا رجلاً سمعته يسأل رسول الله -صلى الله عليه وسلم- وأنا قاعد عنده فقال يا رسول الله اي شهر تأمرني أن أصوم بعد شهر رمضان قال إن كنت صائماً بعد شهر رمضان فصم المحرم فإنه شهر الله فيه يوم تاب فيه على قوم ويتوب فيه على قوم آخرين."
//        "\n"
//        "\n"
//        "· عن ابن عمر رضي الله عنهما عن النبي صلى الله عليه وسلم قال: ( من مات وعليه صيام شهر فليطعم عنه مكان كل يوم مسكيناً)."
//        "\n"
//        "\n"
//        "·عن أبي هريرة رضي الله عنه قال، قال رسول الله صلى الله عليه وسلم: (من أفطر يوما من رمضان من غير رخصة ولا مرض لم يقض عنه صوم الدهر كله وإن صامه )."
//        "\n"
//        "\n"
//        "· عن أبي هريرة رضي الله عنه قال، قال رسول الله صلى الله عليه وسلم: ( من أكل أو شرب ناسيا فلا يفطر فإنما هو رزق رزقه الله)."
//        "\n"
//        "\n"
//        "·عن أبي هريرة رضي الله عنه عن النبي صلى الله عليه وسلم قال: ( لا تصوم المرأة وزوجها شاهد يوماً من غير شهر رمضان إلا بإذنه)."
//        "\n"
//        "\n"
//        "·عن عائشة رضي الله عنها قالت : ما كنت اقضي ما يكون علي من رمضان إلا في شعبان حتى توفي رسول الله صلى الله عليه وسلم."
//        "·عن علي رضي الله عنه أن النبي صلى الله عليه وسلم كان يوقظ أهله في العشر الأواخر من رمضان."
//        "\n"
//        "\n"
//        "·عن ابن عباس رضي الله عنه قال، قال رسول الله صلى الله عليه وسلم لامرأة من الأنصار: (إذا كان رمضان فاعتمري فيه فإن عمرة فيه تعدل حجة)."
//        "\n"
//        "\n"
//        "حدثنا أبو النعمان حدثنا حماد بن زيد حدثنا يحيى عن عمرة عن عائشة رضي الله عنها قالت كان النبي صلى الله عليه وسلم يعتكف في العشر الأواخر من رمضان فكنت أضرب له خباء فيصلي الصبح ثم يدخله فاستأذنت حفصة عائشة أن تضرب خباء فأذنت لها فضربت خباء فلما رأته زينب ابنة جحش ضربت خباء آخر فلما أصبح النبي صلى الله عليه وسلم رأى الأخبية فقال ما هذا فأخبر فقال النبي صلى الله عليه وسلم ألبر ترون بهن فترك الاعتكاف ذلك الشهر ثم اعتكف عشرا من شوال "));
//        }
//if (strmydate_day==QString("17") && mydate.month==9)
//        {
//        ui->label_messages_titre->setText(tr("حدث اليوم : غزوة بدر"));
//        ui->label_messages->setText(tr("في متل هذا اليوم وفي الثاني للهجرة وقعت غزوة بدر اللتي نصر الله فيها المسلمين "));
//        }
//if (strmydate_day==QString("20") && mydate.month==9)
//        {
//        ui->label_messages_titre->setText(tr("حدث اليوم : دخول العشر الأواخر من رمضان"));
//        ui->label_messages->setText(tr("فضل العشر الاواخر من رمضان "
//                        "\n"
//                        "\n"
//        "وفي الصحيح عنها قالت : كان النبي صلى الله عليه وسلم إذا دخل العشر شد مئزره وأحيا ليله وأيقظ أهله )للعشر الأخيرة من رمضان خصائص ليست لغيرها من الأيام ..فمن خصائصها : ان النبي صلى الله عليه وسلم كان يجتهد في العمل فيها أكثر من غيرها..ففي صحيح مسلم عن عائشة رضي الله عنها :أن النبي صلى الله عليه وسلم كان يجتهد في العشر الأواخر مالا يجتهد في غيرها ) رواه مسلم."
//                        "\n"
//                        "\n"
//        "وفي المسند عنها قالت : كان النبي صلى الله عليه وسلم يخلط العشرين بصلاة ونوم فإذا كان العشر شمر وشد المئزر)"
//        "فهذه العشر كان يجتهد فيها صلى الله عليه وسلم أكثر مما يجتهد في غيرها من الليالي والأيام من انواع العبادة : من صلاة وقرآن وذكر وصدقة وغيرها ..ولأن النبي صلى الله عليه وسلم كان يشد مئزره يعني: يعتزل نساءه ويفرغ للصلاة والذكر ولأن النبي صلى الله عليه وسلم كان يحيي ليله بالقيام والقراءة والذكر بقلبه ولسانه وجوارحه لشرف هذه الليالي والتي فيها ليلة القدر التي من قامها إيمانا واحتسابا غفر الله ماتقدم من ذنبه ."
//        "وظاهر هذا الحديث أنه صلى الله عليه وسلم يحيي الليل كله في عبادة ربه من الذكر والقراءة والصلاة والاستعداد لذلك والسحور وغيرها."
//        "وبهذا يحصل الجمع بينه وبين مافي صحيح مسلم عن عائشة رضي الله عنها قالت: ماأعلمه صلى الله عليه وسلم قام ليله حتى الصباح ) لأن إحياء الليل الثابت في العشر يكون بالقيام وغيره من أنواع العبادة والذي نفته إحياء الليل بالقيام فقط."
//        "ومما يدل على فضيلة العشر من الأحاديث أن النبي صلى الله عليه وسلم ان النبي صلى الله عليه وسلم كان يوقظ أهله فيها للصلاة والذكر حرصا على اغتنام هذه الليالي المباركة بما هي جديرة به من العبادة فإنها فرصة العمر وغنيمة لمن وفقه الله عز وجل فلا ينبغي للمسلم العاقل أن يفوّت هذه الفرصة الثمينة على نفسه وأهله فما هي إلا ليال معدودة ربما يُدرك الإنسان فيها نفحة من نفحات المولى فتكون ساعادة في الدنيا والآخرة . "));
//        }
//if (strmydate_day==QString("21") && mydate.month==9)
//        {
//        ui->label_messages_titre->setText(tr("حدث اليوم : فتح مكة"));
//        ui->label_messages->setText(tr("في متل هذا اليوم وفي الثامن للهجرة فتحت مكة المكرمة "));
//        }
//if (strmydate_day==QString("1") && mydate.month==10)
//        {
//        ui->label_messages_titre->setText(tr("حدث اليوم : أول أيام عيد الفطر"));
//        ui->label_messages->setText(tr("غفر الله لنا ولكم وكل عام وأنتم بخير"));
//        }
//if (strmydate_day==QString("6") && mydate.month==10)
//        {
//        ui->label_messages_titre->setText(tr("حدث اليوم : غزوة أحد"));
//        ui->label_messages->setText(tr("في متل هذا اليوم وفي الثالث للهجرة وقعت غزوة أحد "));
//        }
//if (strmydate_day==QString("10") && mydate.month==10)
//        {
//        ui->label_messages_titre->setText(tr("حدث اليوم : غزوة حنين"));
//        ui->label_messages->setText(tr("في متل هذا اليوم وفي الثامن للهجرة وقعت غزوة حنين "));
//        }
//if (strmydate_day==QString("8") && mydate.month==12)
//        {
//        ui->label_messages_titre->setText(tr("حدث اليوم : أول أيام الحج"));
//        ui->label_messages->setText(tr("هو أول أيام الحج"));
//        }
//if (strmydate_day==QString("9") && mydate.month==12)
//        {
//        ui->label_messages_titre->setText(tr("حدث اليوم : ثاني أيام الحج ويوم عرفة"));
//        ui->label_messages->setText(tr("فضل يوم عرفة وحال السلف فيه"
//                        "\n"
//                        "\n"
//                        "الحمد لله وحده، والصلاة والسلام على من لا نبي بعده، وبعد"
//                        "فيوم عرفة من الأيام الفاضلة، تجاب فيه الدعوات، وتقال العثرات، ويباهي الله فيه الملائكة بأهل عرفات، وهو يوم عظَّم الله أمره، ورفع على الأيام قدره. وهو يوم إكمال الدين وإتمام النعمة، ويوم مغفرة الذنوب والعتق من النيران."
//                        "ويوم كهذا –أخي الحاج- حري بك أن تتعرف على فضائله، وما ميزه الله به على غيره من الأيام، وتعرف كيف كان هدي النبي صلى الله عليه وسلم فيه؟ "
//                        "نسأل الله أن يعتق رقابنا من النار في هذا اليوم العظيم. "
//                        "\n"
//                        "\n"
//                        "فضائل يوم عرفة"
//                        "\n"
//                        "\n"
//                        "إنه يوم إكمال الدين وإتمام النعمة-"
//                        "ففي الصحيحين عن عمر بن الخطاب رضي الله عنه أن رجلا من اليهود قال له: يا أمير المؤمنين، آية في كتابكم تقرؤونها، لو علينا معشر اليهود نزلت لاتخذنا ذلك اليوم عيدا، قال أي آيه؟ قال: (اليوم أكملت لكم دينكم وأتممت عليكم نعمتي ورضيت لكم الإسلام دينا) -المائدة: 3- قال عمر: قد عرفنا ذلك اليوم والمكان الذي نزلت فيه على النبي صلى الله عليه وسلم، وهو قائم بعرفة يوم الجمعة."
//                        "\n"
//                        "\n"
//                        "- قال صلى الله عليه وسلم: (يوم عرفة ويوم النحر وأيام التشريق عيدنا أهل الإسلام وهي أيام أكل وشرب) -رواه أهل السّنن-. وقد روي عن عمر بن الخطاب أنه قال: (نزلت –أي آية (اليوم أكملت)- في يوم الجمعة ويوم عرفة، وكلاهما بحمد الله لنا عيد)."
//                        "\n"
//                        "\n"
//                        "إنه يوم أقسم الله به"
//                        "إنه يوم أقسم الله بهوالعظيم لا يقسم إلا بعظيم، فهو اليوم المشهود في قوله تعالى: (وشاهد ومشهود) -البروج: 3-، فعن أبي هريرة رضي الله عنه أن النبي صلى الله عليه وسلم قال: (اليوم الموعود : يوم القيامة، واليوم المشهود : يوم عرفة، والشاهد: يوم الجمعة..) -رواه الترمذي وحسنه الألباني-."
//                        "إنه يوم أقسم الله بهوهو الوتر الذي أقسم الله به في قوله: (والشفع والوتر) -الفجر: 3- قال ابن عباس: الشفع يوم الأضحى، والوتر يوم عرفة، وهو قول عكرمة والضحاك."
//                        "\n"
//                        "\n"
//                        "-أن صيامه يكفر سنتين:"
//                        "فقد ورد عن أبي قتادة رضي الله عنه أن رسول الله صلى الله عليه وسلم سئل عن صوم يوم عرفة فقال: (يكفر السنة الماضية والسنة القابلة) -رواه مسلم."
//                        "وهذا إنما يستحب لغير الحاج، أما الحاج فلا يسن له صيام يوم عرفة؛ لأن النبي صلى الله عليه وسلم ترك صومه، وروي عنه أنه نهى عن صوم يوم عرفة بعرفة."
//                        "\n"
//                        "\n"
//                        "- أنه اليوم الذي أخذ الله فيه الميثاق على ذرية آدم."
//                        "فعن ابن عباس _رضي الله عنهما_ قال: قال رسول الله صلى الله عليه وسلم: (إن الله أخذ الميثاق من ظهر آدم بِنَعْمان- يعني عرفة- وأخرج من صلبه كل ذرية ذرأها، فنثرهم بين يديه كالذّر، ثم كلمهم قِبَلا، قال: (ألست بربكم قالوا بلى شهدنا أن تقولوا يوم القيامة إنا كنا عن هذا غافلين، أو تقولوا إنما أشرك آباؤنا من قبل وكنا ذرية من بعدهم أفتهلكنا بما فعل المبطلون) -الأعراف: 172، 173- -رواه أحمد وصححه الألباني"
//                        "فما أعظمه من يوم! وما أعظمه من ميثاق !"
//                        "\n"
//                        "\n"
//                        "-أنه يوم مغفرة الذنوب والعتق من النار والمباهاة بأهل الموقف:"
//                        "ففي صحيح مسلم عن عائشة _رضي الله عنها_ عن النبي صلى الله عليه وسلم قال: (ما من يوم أكثر من أن يعتق الله فيه عبدأ من النار من يوم عرفة، وإنه ليدنو ثم يباهي بهم الملائكة فيقول: ما أراد هؤلاء؟)."
//                        "وعن ابن عمر أن النبي صلى الله عليه وسلم قال: (إن الله تعالى يباهي ملائكته عشية عرفة بأهل عرفة، فيقول: انظروا إلى عبادي، أتوني شعثا غبرا) رواه أحمد وصححه الألباني."));
//        }
//if (strmydate_day==QString("10") && mydate.month==12)
//        {
//        ui->label_messages_titre->setText(tr("حدث اليوم : أول أيام عيد الأضحى"));
//        ui->label_messages->setText(tr("غفر الله لنا ولكم وكل عام وأنتم بخير"));
//        }
//}

