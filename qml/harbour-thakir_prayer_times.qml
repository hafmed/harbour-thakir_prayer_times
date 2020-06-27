// www.transifex.com/hafsoftdz/thakir-prayer-times.
// to use: import QtSensors 5.0
// in terminal ubuntu desktop:
// ssh -p 2223 -i ~/SailfishOS/vmshare/ssh/private_keys/SailfishOS_Emulator/root root@localhost
//  pkcon install qt5-qtdeclarative-import-sensors
// see : http://flyingsheeponsailfish.blogspot.ch/2013/11/deploying-additional-packages-to.html
// and https://lists.sailfishos.org/pipermail/devel/2014-January/002801.html
//-----------------------------------------
/*
Ver 1.0:

    Initial release.

Ver 1.5:

    Add Adhan (Click on remaining time button to stop Adhan);
    GPS;
    French translation.
*/
//-----------------------------------------
import QtQuick 2.0
import QtMultimedia 5.0
import Sailfish.Silica 1.0
import "pages"
import "cover"
import harbour.thakir_prayer_times.calculcpp 1.0
import harbour.thakir_prayer_times.settings 1.0

//import org.nemomobile.dbus 2.0
//import org.nemomobile.configuration 1.0 //deprecated
import Nemo.Configuration 1.0

//import harbour.thakir_prayer_times.insomniac 1.0

import Nemo.KeepAlive 1.2    //17-09-2019  de 1.1 to 1.2


//import harbour.thakir_prayer_times.uiconnection 1.0

ApplicationWindow
{
    id: app;

    KeepAlive {
        id: keepAlive
        enabled: true
    }

    Timer {
        id: timercalcul
        interval: 10000 // every 15 secs update for now
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            calcul()
        }
        running: viewable
    }


//    DBusInterface {
//        id: profiled
//        service: 'com.nokia.profiled'
//        iface: 'com.nokia.profiled'
//        path: '/com/nokia/profiled'

//        function send()
//        {
//            profiled.typedCall('get_profile', [], function (result) {
//                // This will be called when the result is available
//                profileActive=result;
//                console.log('Got profile: ' + profileActive);
//            });
//        }
//    }

    // a mettre tjrs tout les variables ici (pas dans les autres pages *.qml) 23-10-2015

    property int displayInfo_dpiWidth: app.width
    property int displayInfo_dpiHeight: app.height
    property int displayInfo_dpiMarge: 0//Theme.horizontalPageMargin

    property string indexregion
    property string indexpays
    property bool payhasstate

    property string indexcity
    property string coordinatesCity

    property string lang //"1" english "2" Arabic "6" francais

    property bool uiArabic: lang==="2"
    property bool hindinumber: false

    property string timefajr
    property string timesunrise
    property string timedhuhr
    property string timeasr
    property string timemaghrib
    property string timeisha

    property bool isfajrExtrem
    property bool issunriseExtrem
    property bool isdhuhrExtrem
    property bool isasrExtrem
    property bool ismaghribExtrem
    property bool isishaExtrem

    property string nextfajr

    property bool isRamathan:false  //pour config Ramathan
    property bool isJommoaa:false  //pour config Silent in Jommoaa 17-11-2018

    property int adjust_hijri:0
    property string event_hijri

    property int adjust_fajr:1
    property int adjust_dhuhr:1
    property int adjust_asr:1
    property int adjust_maghrib:1
    property int adjust_isha:1

    property string time_end_Isha
    property string timebegin_Tholoth_akhir
    property string timeimsak

    property string time_now
    property string time_hijri

    property string time_hijri_Arab
    property string time_now_Arab

    property string time_hijri_Arab_NbreHindi
    property string time_now_Arab_NbreHindi


    property string cityname: "Mekka" //"مكة المكرمة"

    property string method: '5'
    property string exmethods: '0'
    property string lat: "21.423333"
    property string longi: "39.823333"
    property string tzone: "+3"
    property string timeformat: '12'
    property string dst: '0'


    property string next_salat
    property string next_salat_ID
    property string remaining_time
    property int  pourcent_remaining_time


    property int  adhan_Fajr: 1
    property string selectedFajrAdhanFileUser: selectedSound

    property int stylecompass: 2

   // property bool viewable: cover.status === Cover.Active || applicationActive

    //property int i: 0
    //onViewableChanged: i=i+1

    //onViewableChanged: if (viewable==true ) calcul()

    property bool  athanIsPlaying

    property string  noAthanInSilentProfileChecked: "0"
    property string volumeAthanSlidervalue: "75"
    property int  athan_Fajr_Old

    property string  alerteActiveChecked: "0"
    property string minAlerteBeforeAthanvalue: "10"

    property string  silenctAfterAthanActiveChecked: "0"
    property string minSilentActiveAfterAthanvalue: "10"
    property string minSilentActivedurationvalue: "10"

    property string  formatNumberHindiActiveChecked: "1"

    property bool  remainTimeZero

    property string  minSilentDuringTarawihvalue: "57"
    property string  silentDuringTarawihChecked: "0"

    //---17-11-2018-------
    property string  minSilentActiveBeforAthanJommoaavalue: "30"
    property string  minSilentActiveAfterAthanJommoaavalue: "35"
    property string  silentDuringSalatJommoaaChecked: "0"

    //---11-11-2018-------
    property string  stopathanonrotationChecked: "0"
    property bool  athanHasStoped


    property int  run_periodsActiveAtlert
    property int  run_periodsActiveAthan
    property int  run_periodsActiveSilent
    property int  run_periodsActiveBackMode
    property bool  playhaftimersisActive

    property bool  run_periodsActiveAtlertIsActive
    property bool  run_periodsActiveAthanIsActive
    property bool  run_periodsActiveSilentIsActive
    property bool  run_periodsActiveBackModeIsActive

    property string  playAthkarSabahChecked: "0"
    property string  playAthkarMassaChecked: "0"

    property string  minplayAthkarSabah: "10"
    property string  minplayAthkarMassa: "5"

    //--------------------
    Connections {
      target: calculcpp
      onSendToQml: {
          //console.log("from C++: remaining_time_haf_Sec()= " + count)
       }
      onSendToQmltempRemainingTime: {
          remaining_time=count
          //console.log("from C++: remaining_time= " + count)
       }
      onSendToQmltempAlert: {
          run_periodsActiveAtlert=count
          run_periodsActiveAtlertIsActive=isactive
          //console.log("from C++: Temps pour Alert= " + count+"("+isactive+")")
       }
      onSendToQmltempAthan: {
          run_periodsActiveAthan=count
          run_periodsActiveAthanIsActive=isactive
          //console.log("from C++: Temps pour Athan= " + count+"("+isactive+")")
       }
      onSendToQmltempActiveSilent: {
          run_periodsActiveSilent=count
          run_periodsActiveSilentIsActive=isactive
          //console.log("from C++: Temps pour Active Silent= " + count+"("+isactive+")")
       }
      onSendToQmltempReturntoNormalMode: {
          run_periodsActiveBackMode=count
          run_periodsActiveBackModeIsActive=isactive
          //console.log("from C++: Temps pour Back mode= " + count+"("+isactive+")")
       }
      onSendToQmlplayhaftimersisActive: {
          playhaftimersisActive=count
          //console.log("from C++: Temps pour Back mode= " + count)
       }
      onSendToQmlAthanIsPlaying: {
          athanIsPlaying=true
      }
      onSendToQmlAthanIsStoped: {
          athanIsPlaying=false
      }
      onSendToQmlRemainTimeZero: {
          remainTimeZero=true
      }
      onSendToQmlRemainTimeNotZero: {
          remainTimeZero=false
      }

    }
    ConfigurationValue {
        id: timeFormatConfig
        key: "/sailfish/i18n/lc_timeformat24h"
    }
    function calcul(){
//        if (timeFormatConfig.value === "24") {
//            time_now = Qt.formatDateTime(new Date(), "dd-MM-yy  hh:mm");
//            timeformat="24";
//        } else {
//            time_now = Qt.formatDateTime(new Date(), "dd-MM-yy  hh:mm ap");
//            timeformat="12";
//        }

        if (timeFormatConfig.value === "24") {
            time_now =Qt.formatDate(new Date())+ Qt.formatDateTime(new Date(), " hh:mm");
            timeformat="24";
        } else {
            time_now = Qt.formatDate(new Date())+Qt.formatDateTime(new Date(), " hh:mm ap");
            timeformat="12";
        }



        time_hijri = calculcpp.getoutputtexhigri(adjust_hijri)
        if (lang=="2"){
            time_hijri_Arab=time_hijri.replace(/Muharram/gi, "محرم").replace(/Safar/gi, "صفر").replace(/Rabi II/gi, "ربيع الثاني").replace(/Rabi I/gi, "ربيع الأول").replace(/Jumada II/gi, "جمادى الثاني").replace(/Jumada I/gi, "جمادى الأول").replace(/Rajab/gi, "رجب").replace(/Shaaban/gi, "شعبان").replace(/Ramadan/gi, "رمضان").replace(/Shawwal/gi, "شوال").replace(/Thul-Qiaadah/gi, "ذو القعدة").replace(/Thul-Hijja/gi, "ذو الحجة")
            time_now_Arab=time_now.replace(/am/gi, "ص").replace(/pm/gi, "م")
        }

        if (formatNumberHindiActiveChecked=="0"){
            time_hijri_Arab_NbreHindi=time_hijri_Arab.replace(/0/gi, "٠").replace(/1/gi, "١").replace(/2/gi, "٢").replace(/3/gi, "٣").replace(/4/gi, "٤").replace(/5/gi, "٥").replace(/6/gi, "٦").replace(/7/gi, "٧").replace(/8/gi, "٨").replace(/9/gi, "٩")   //.replace(/./gi, "٫")
            time_now_Arab_NbreHindi=time_now_Arab.replace(/0/gi, "٠").replace(/1/gi, "١").replace(/2/gi, "٢").replace(/3/gi, "٣").replace(/4/gi, "٤").replace(/5/gi, "٥").replace(/6/gi, "٦").replace(/7/gi, "٧").replace(/8/gi, "٨").replace(/9/gi, "٩")            //.replace(/./gi, "٫")

        }

        isJommoaa = calculcpp.isJommoaa()
        isRamathan = calculcpp.isRamathan(adjust_hijri)
        //event_hijri = calculcpp.getstrDaysEvent(adjust_hijri)

        timefajr = calculcpp.displayTimes_hhmm(0);
        timesunrise = calculcpp.displayTimes_hhmm(1);
        timedhuhr = calculcpp.displayTimes_hhmm(2);
        timeasr = calculcpp.displayTimes_hhmm(3);
        timemaghrib = calculcpp.displayTimes_hhmm(4);
        timeisha = calculcpp.displayTimes_hhmm(5);

        isfajrExtrem = calculcpp.isPrayerExtrem(0);
        issunriseExtrem = calculcpp.isPrayerExtrem(1);
        isdhuhrExtrem = calculcpp.isPrayerExtrem(2);
        isasrExtrem = calculcpp.isPrayerExtrem(3);
        ismaghribExtrem = calculcpp.isPrayerExtrem(4);
        isishaExtrem = calculcpp.isPrayerExtrem(5);

        timeimsak = calculcpp.displayTimes_imsaak_hhmm();
        nextfajr = calculcpp.displayTimes_nextfajr_hhmm();

        time_end_Isha = calculcpp.displayTimes_time_end_Isha_hhmm();
        timebegin_Tholoth_akhir = calculcpp.displayTimes_timebegin_Tholoth_akhir_hhmm();

        next_salat = calculcpp.next_salat_haf()
        next_salat_ID = calculcpp.next_salat_haf_id();
        remaining_time = calculcpp.remaining_time_haf()
        pourcent_remaining_time = calculcpp.remaining_ProgressBar_haf()

        //-----19-11-2018


    }
    Calculcpp {
        id: calculcpp
    }
    Settings {
        id: settings
    }
//    UIConnection {
//        id: uiconnection
//    }
    cover: CoverPage {
        id: cover
    }
    Timer {
        id: timerclock
        interval: 1000 // every 15 secs update for now
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            cover.updateTime()
        }
        running: viewable
    }




    property string selectedSound: "../sounds/Adhan/adhan_court.mp3";

    // Close enough to assume screen is off.
    property bool viewable: cover.status === Cover.Active
                            || cover.status === Cover.Activating
                            || applicationActive;

    onViewableChanged: {
        if (viewable==true ) {
            if (timeFormatConfig.value === "24") {
                timeformat="24";
            } else {
                timeformat="12";
            }
            settings.saveValueFor("timeformat",timeformat);

            calcul();

        }
       // if (!backgroundJobAlert.running && !backgroundJobAthan.running && !backgroundJobActiveSilent.running && !backgroundJobRestoreOriginalMode.running) {
           // return;
       // }

        if(viewable) {
            calcul();
            timerclock.restart();
            timercalcul.restart();
            event_hijri = calculcpp.getstrDaysEvent(adjust_hijri);
        }
    }


    Component.onCompleted: {
        timerclock.restart();
        timercalcul.restart();

        calculcpp.haftimersplayall()
        event_hijri = calculcpp.getstrDaysEvent(adjust_hijri);

    }

    Component.onDestruction: {
        //-----
    }

    initialPage: Component { PrayerTimes { } }
    //cover: Qt.resolvedUrl("cover/CoverPage.qml")
    allowedOrientations: Orientation.Portrait
    _defaultPageOrientations: Orientation.Portrait
}


