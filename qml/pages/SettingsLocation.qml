
import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.thakir_prayer_times.hafgps 1.0

import QtSensors 5.0
import QtPositioning 5.2

import harbour.thakir_prayer_times.calculcpp 1.0

Page {
    id: page

    property PositionSource gps: rootGps
//    readonly property int inView: rootGps.satellitesInView
//    readonly property int inUse: rootGps.satellitesInUse
//    readonly property bool valid: rootGps.valid

    property bool copyCoordGPS

    PositionSource {
        id: rootGps
    }
    Dialog {
        id: locationStatusDialog
        DialogHeader {
            title: qsTr("Enable Location Services: You must have Location Services turned on to use GPS ...Go to your device's Settings menu and select Location.")
        }
    }
    SilicaFlickable {
        anchors.fill: parent

        // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
//        PullDownMenu {
//            MenuItem {
//                text: qsTr("Configure alert and Adhan")
//                onClicked: pageStack.push(Qt.resolvedUrl("Alert_Adhan.qml"))
//            }
//        }

        // Tell SilicaFlickable the height of its content.
        contentHeight: column.height

        // Place our content in a Column.  The PageHeader is always placed at the top
        // of the page, followed by our content.
        Column {
            id: column
            width: displayInfo_dpiWidth
            //spacing: Theme.paddingSmall
            //spacing: Theme.paddingMedium
            //spacing: Theme.paddingLarge
//            anchors.horizontalCenter: parent.horizontal
            PageHeader {
               title: qsTr("Location Settings")
            }

            TextField {
                id: textinput_cityname
                width: parent.width
               // inputMethodHints: Qt.ImhFormattedNumbersOnly
                label: qsTr("City")
                text: cityname
                placeholderText: "Type City name here"
                horizontalAlignment: TextInput.AlignHCenter
                EnterKey.onClicked: parent.focus = true
                onTextChanged:{
                    cityname=textinput_cityname.text
                    settings.saveValueFor("cityname",cityname)
                }
            }
            TextField {
                id: textinput_lat
                width: parent.width
                inputMethodHints: Qt.ImhFormattedNumbersOnly
                label: qsTr("Latitude")
                text: (lat.charAt(2) === "N" || lat.charAt(2)==="n" )? 0  : formatNumberHindiActiveChecked=="0"? calculcpp.formatNumberHindi(lat) : lat
                placeholderText: "Type latitude here"
                horizontalAlignment: TextInput.AlignHCenter
                EnterKey.onClicked: parent.focus = true
                onFocusChanged: {
                    if (formatNumberHindiActiveChecked=="0" && lang=="2"){
                    if(focus){
                        formatNumberHindiActiveChecked="1"
                    }else{
                        formatNumberHindiActiveChecked="0"
                    }
                    }

                }
                onTextChanged: {
                    if (formatNumberHindiActiveChecked=="0" && lang=="2"){
                        var latHindi=textinput_lat.text.replace(/٠/gi, "0").replace(/١/gi, "1").replace(/٢/gi, "2").replace(/٣/gi, "3").replace(/٤/gi, "4").replace(/٥/gi, "5").replace(/٦/gi, "6").replace(/٧/gi, "7").replace(/٨/gi, "8").replace(/٩/gi, "9").replace(/٫/gi, ".")
                    lat=latHindi
                    }else{
                       lat=textinput_lat.text
                    }
                   settings.saveValueFor("lat",lat)
                }
            }
            TextField {
                id: textinput_longi
                width: parent.width
                inputMethodHints: Qt.ImhFormattedNumbersOnly
                label: qsTr("longitude")
                text: (longi.charAt(2) === "N" || longi.charAt(2)==="n" )? 0  : formatNumberHindiActiveChecked=="0"? calculcpp.formatNumberHindi(longi) : longi
                placeholderText: "Type longitude here"
                horizontalAlignment: TextInput.AlignHCenter
                EnterKey.onClicked: parent.focus = true
                onFocusChanged: {
                    if (formatNumberHindiActiveChecked=="0" && lang=="2"){
                    if(focus){
                        formatNumberHindiActiveChecked="1"
                    }else{
                        formatNumberHindiActiveChecked="0"
                    }
                    }

                }
                onTextChanged: {
                    if (formatNumberHindiActiveChecked=="0" && lang=="2"){
                        var longiHindi=textinput_longi.text.replace(/٠/gi, "0").replace(/١/gi, "1").replace(/٢/gi, "2").replace(/٣/gi, "3").replace(/٤/gi, "4").replace(/٥/gi, "5").replace(/٦/gi, "6").replace(/٧/gi, "7").replace(/٨/gi, "8").replace(/٩/gi, "9").replace(/٫/gi, ".")
                    longi=longiHindi
                    }else{
                       longi=textinput_longi.text
                    }
                   settings.saveValueFor("longi",longi)
                }
            }
            TextField {
                id: textinput_timezone
                width: parent.width
                //inputMethodHints: Qt.ImhFormattedNumbersOnly
                label: qsTr("Time zone")
                text: (tzone.charAt(2) === "N" || tzone.charAt(2)==="n" )? 0  : formatNumberHindiActiveChecked=="0"? calculcpp.formatNumberHindi(tzone) : tzone
                placeholderText: "Type Auto to get default time zone"
                horizontalAlignment: TextInput.AlignHCenter
                EnterKey.onClicked: parent.focus = true
                onFocusChanged: {
                    if (formatNumberHindiActiveChecked=="0" && lang=="2"){
                    if(focus){
                        formatNumberHindiActiveChecked="1"
                    }else{
                        formatNumberHindiActiveChecked="0"
                    }
                    }

                }
                onTextChanged:{
                    if (formatNumberHindiActiveChecked=="0" && lang=="2"){
                        if (textinput_timezone.text==="Auto" || textinput_timezone.text==="auto") {
                            tzone=calculcpp.getTimeZone();
                            textinput_timezone.text='Auto'
                        }else{
                            var tzoneHindi=textinput_timezone.text.replace(/٠/gi, "0").replace(/١/gi, "1").replace(/٢/gi, "2").replace(/٣/gi, "3").replace(/٤/gi, "4").replace(/٥/gi, "5").replace(/٦/gi, "6").replace(/٧/gi, "7").replace(/٨/gi, "8").replace(/٩/gi, "9").replace(/٫/gi, ".")
                        tzone=tzoneHindi

                        }
                    }else{
                        if (textinput_timezone.text==="Auto" || textinput_timezone.text==="auto") {
                            tzone=calculcpp.getTimeZone();
                            textinput_timezone.text='Auto'
                        }else{
                            tzone=textinput_timezone.text

                        }
                    }

                   settings.saveValueFor("tzone",tzone)
                }
            }
            Row {
                id:row_gps_city
                width: displayInfo_dpiWidth

            Row {
                id:row_gps
                width: displayInfo_dpiWidth/2
                anchors.centerIn: parent
                BusyIndicator {
                    id:busyIndicator_GPS
                    size: BusyIndicatorSize.Medium
                    //
                    running: copyCoordGPS
                    visible: copyCoordGPS
                    anchors.centerIn: parent
                }
                IconButton {
                    width: parent.width-busyIndicator_GPS.width
                    icon.source: "image://theme/icon-m-gps"
                    visible: copyCoordGPS
                    anchors.centerIn: parent
                }
            }
            Button {
                id: button_GPS
                text:  qsTr("Start GPS")
                width: parent.width/2
                onClicked: {
                    if (calculcpp.locationEnabled() === true){
                        copyCoordGPS=true;
                    }else{
                        copyCoordGPS=false;
                        locationStatusDialog.open();
                    }
                    //rootGps.start();
                }
            }
            Connections {
                target: gps
                onPositionChanged: {
                    if (copyCoordGPS){
                        textinput_lat.text=gps.position.coordinate.latitude;
                        textinput_longi.text=gps.position.coordinate.longitude;
                    }
                }
            }
            Button {
                id: button_Choise_City
                text:  qsTr("Choose City")
                width: parent.width/2
                onClicked: {
                    copyCoordGPS=false;
                    pageStack.push(Qt.resolvedUrl("Regions.qml"))
                }
            }
}
            ComboBox {
                width: parent.width
                label: qsTr("Daylight Saving")
                currentIndex: dst=="1"? 2 : 1
                onCurrentIndexChanged: {
                    switch (currentIndex) {
                    case 0:
                        if (calculcpp.getDaylightSavingTime()==='true'){
                            dst='1'
                        }else{
                            dst='0'
                        }
                        break
                    case 1:
                        dst='0'
                        break
                    case 2:
                        dst='1'
                        break
                    }
                    console.log("dst="+dst)
                    settings.saveValueFor("dst",dst)
                }

                menu: ContextMenu {
                    MenuItem { text: qsTr("Auto") }
                    MenuItem { text: qsTr("Not active") }
                    MenuItem { text: qsTr("Active") }
                }
            }

            ComboBox {
                id: comboBox_method
                width: parent.width
                label: qsTr("Calculation Method")
                currentIndex: method
                onCurrentIndexChanged: {
                    switch (currentIndex) {
                    case 0:
                        method='0'
                        break
                    case 1:
                        method='1'
                        break
                    case 2:
                        method='2'
                        break
                    case 3:
                        method='3'
                        break
                    case 4:
                        method='4'
                        break
                    case 5:
                        method='5'
                        break
                    case 6:
                        method='6'
                        break
                    case 7:
                        method='7'
                        break
                    case 8:
                        method='8'
                        break
                    case 9:
                        method='9'
                        break
                    case 10:
                        method='10'
                        break
                    case 11:
                        method='11'
                        break
                        // HAF 7-11-2015
                    case 12:
                        method='12'
                        break
                    case 13:
                        method='13'
                        break
                    case 14:
                        method='14'
                        break
                    case 15:
                        method='15'
                        break
                    case 16:
                        method='16'
                        break
                    case 17:
                        method='17'
                        break
                    case 18:
                        method='18'
                        break
                    case 19:
                        method='19'
                        break
                    case 20:
                        method='20'
                        break
                    case 21:
                        method='21'
                        break
                    case 22:
                        method='22'
                        break
                    }
                    settings.saveValueFor("method",method)
                }
                menu: ContextMenu {
                    MenuItem { text: qsTr("Egyptian General Authority of Survey")}
                    MenuItem { text: qsTr("University of Islamic Sciences, Karachi; SHAF")}
                    MenuItem { text: qsTr("University of Islamic Sciences, Karachi; HANAF")}
                    MenuItem { text: qsTr("Islamic Society of North America (ISNA)")}
                    MenuItem { text: qsTr("Muslim World League (MWL)")}
                    MenuItem { text: qsTr("Umm Al-Qura University, Makkah")}
                    MenuItem { text: qsTr("Fixed Isha Angle Interval")}
                    MenuItem { text: qsTr("Egyptian General Authority of Survey NEW")}
                    MenuItem { text: qsTr("Umm Al-Qura University, RAMADAN")}
                    MenuItem { text: qsTr("MOONSIGHTING_COMMITTEE")}
                    MenuItem { text: qsTr("MOROCCO_AWQAF")}
                    // HAF 7-11-2015
                    MenuItem { text: qsTr("FRANCE_UOIF")}
                    MenuItem { text: qsTr("MALAYSIA_JAKIM")}
                    MenuItem { text: qsTr("TURKEY_FAZILET")}
                    MenuItem { text: qsTr("TURKEY_TPRA")}
                    //--- HAF 1-5-2016 ---
                    MenuItem { text: qsTr("TURKEY_DIYANET")}
                    //--------------------
                    MenuItem { text: qsTr("ENGLAND_BIRMINGHAM")}
                    MenuItem { text: qsTr("JORDAN_MAIAHPJ")}
                    MenuItem { text: qsTr("ALGERIA_MARWDZ")}
                    MenuItem { text: qsTr("TUNISIA_MAIAMTU")}
                    MenuItem { text: qsTr("OMAN_MARAOM")}
                    MenuItem { text: qsTr("KUWAIT_MARAKU")}
                    MenuItem { text: qsTr("LIBYA_MARALI")}
                    MenuItem { text: qsTr("QATAR_TAQWMQAT")}
                }
            }

            ComboBox {
                id: comboBox_exmethods
                width: parent.width
                label: qsTr("Calculation Methods for High Altitude")
                currentIndex: exmethods
                onCurrentIndexChanged: {
                    switch (currentIndex) {
                    case 0:
                        exmethods='0'
                        break
                    case 1:
                        exmethods='1'
                        break
                    case 2:
                        exmethods='2'
                        break
                    case 3:
                        exmethods='3'
                        break
                    case 4:
                        exmethods='4'
                        break
                    case 5:
                        exmethods='5'
                        break
                    case 6:
                        exmethods='6'
                        break
                    case 7:
                        exmethods='7'
                        break
                    case 8:
                        exmethods='8'
                        break
                    case 9:
                        exmethods='9'
                        break
                    case 10:
                        exmethods='10'
                        break
                    case 11:
                        exmethods='11'
                        break
                    case 12:
                        exmethods='12'
                        break
                    case 13:
                        exmethods='13'
                        break
                    case 14:
                        exmethods='14'
                        break
                    case 15:
                        exmethods='15'
                        break
                    }
                    settings.saveValueFor("exmethods",exmethods)
                }
                menu: ContextMenu {
                    MenuItem { text:  qsTr("NONE")}
                    MenuItem { text:  qsTr("LAT_ALL")}
                    MenuItem { text:  qsTr("LAT_ALWAYS")}
                    MenuItem { text:  qsTr("LAT_INVALID")}
                    MenuItem { text:  qsTr("GOOD_ALL")}
                    MenuItem { text:  qsTr("GOOD_INVALID")}
                    MenuItem { text:  qsTr("SEVEN_NIGHT_ALWAYS")}
                    MenuItem { text:  qsTr("SEVEN_NIGHT_INVALID")}
                    MenuItem { text:  qsTr("SEVEN_DAY_ALWAYS")}
                    MenuItem { text:  qsTr("SEVEN_DAY_INVALID")}
                    MenuItem { text:  qsTr("HALF_ALWAYS")}
                    MenuItem { text:  qsTr("HALF_INVALID")}
                    MenuItem { text:  qsTr("MIN_ALWAYS")}
                    MenuItem { text:  qsTr("MIN_INVALID")}
                    MenuItem { text:  qsTr("GOOD_INVALID)_SAME")}
                    MenuItem { text:  qsTr("ANGLE_BASED") }
                }
            }
            //----------------------
            function changeLanguage(languageSelected) {
                if(language.currentIndex != 0)
                {
                    saveAll()
                    uiconnection.changeLanguage(languageSelected)
                    //pageStack.replace(Qt.resolvedUrl("Start.qml"))
                }
            }

            //-----
            Row {
                width: parent.width
            ComboBox {
                id: language
                width: page.width/2.
                label: qsTr("Language")
                currentIndex: 0
                menu: ContextMenu {
                    MenuItem { text: qsTr("Select Language") }
                    MenuItem { text: "ar" }
                    MenuItem { text: "tr" }
                    MenuItem { text: "en" }
                    MenuItem { text: "fr" }
                }
                onCurrentIndexChanged: {
                    if(language.currentIndex != 0)
                    {
                        switch (currentIndex) {
                        case 0:
                            break
                        case 1:
                            uiconnection.changeLanguage("ar")
                            if (!formatNumberHindiActive.checked) calculcpp.formatNumberArabic();
                            break
                        case 2:
                            uiconnection.changeLanguage("tr")
                            formatNumberHindiActiveChecked="1"
                            settings.saveValueFor("formatNumberHindiActiveChecked",formatNumberHindiActiveChecked)
                            calculcpp.formatNumberArabic();
                            break
                        case 3:
                            uiconnection.changeLanguage("en")
                            formatNumberHindiActiveChecked="1"
                            settings.saveValueFor("formatNumberHindiActiveChecked",formatNumberHindiActiveChecked)
                            calculcpp.formatNumberArabic();
                            break
                        case 4:
                            uiconnection.changeLanguage("fr")
                            formatNumberHindiActiveChecked="1"
                            settings.saveValueFor("formatNumberHindiActiveChecked",formatNumberHindiActiveChecked)
                            calculcpp.formatNumberArabic();
                            break
                        }
                        pageStack.clear()
                        pageStack.replace(Qt.resolvedUrl("PrayerTimes.qml"))
                    }
                }

            }
            TextSwitch {
                id: formatNumberHindiActive
                width: page.width/2.
                text:  calculcpp.formatNumberHindi(123)
                visible: uiArabic
                checked: formatNumberHindiActiveChecked=="0"
                onCheckedChanged: {
                    if (checked) {
                        formatNumberHindiActiveChecked="0"
                    }else{
                        formatNumberHindiActiveChecked="1"
                        calculcpp.formatNumberArabic();
                    }
                    settings.saveValueFor("formatNumberHindiActiveChecked",formatNumberHindiActiveChecked)
                }
            }
            }
        }
    }
    onStateChanged: {
        if (status !== PageStatus.Active) {
           //rootGps.destroy()
            copyCoordGPS=false;
        }

    }

    Component.onCompleted: {
        rootGps.start();
    }

}





