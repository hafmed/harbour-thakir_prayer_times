// HAF 01-03-2022
import QtQuick 2.6
import Sailfish.Silica 1.0
import QtSensors 5.0
import harbour.thakir_prayer_times.qtimer 1.0
import harbour.thakir_prayer_times.calculcpp 1.0
import QtQuick.XmlListModel 2.0
import "./components" as Thakir

Page {
    id: _mainPage

    function readConfig() {
        athanHasStoped=false;
        var locale=settings.getValueFor("language","");
        if (locale==="ar" || locale==="fr" || locale==="en") {
            // numerotation fonction de lang dans Locations.xml
            if (locale==="ar") lang= "2";
            if (locale==="fr") lang= "6";
            if (locale==="en") lang= "1";

        }else{
            lang= "1";
        }

        cityname=settings.getValueFor("cityname",cityname)
        longi=settings.getValueFor("longi",longi)
        lat=settings.getValueFor("lat",lat)
        tzone=settings.getValueFor("tzone",tzone)
        dst=settings.getValueFor("dst",dst)
        method=settings.getValueFor("method",method)
        exmethods=settings.getValueFor("exmethods",exmethods)

        adjust_hijri=settings.getValueFor("adjust_hijri",adjust_hijri)
        adjust_fajr=settings.getValueFor("adjust_fajr",adjust_fajr)
        adjust_dhuhr=settings.getValueFor("adjust_dhuhr",adjust_dhuhr)
        adjust_asr=settings.getValueFor("adjust_asr",adjust_asr)
        adjust_maghrib=settings.getValueFor("adjust_maghrib",adjust_maghrib)
        adjust_isha=settings.getValueFor("adjust_isha",adjust_isha)

        adhan_Fajr=settings.getValueFor('adhan_Fajr',adhan_Fajr)
        selectedFajrAdhanFileUser=settings.getValueFor('selectedFajrAdhanFileUser',selectedSound)

        stylecompass=settings.getValueFor("stylecompass",stylecompass)

        noAthanInSilentProfileChecked=settings.getValueFor("noAthanInSilentProfileChecked",noAthanInSilentProfileChecked)
        volumeAthanSlidervalue=settings.getValueFor("volumeAthanSlidervalue",volumeAthanSlidervalue)

        alerteActiveChecked=settings.getValueFor("alerteActiveChecked",alerteActiveChecked)
        minAlerteBeforeAthanvalue=settings.getValueFor("minAlerteBeforeAthanvalue",minAlerteBeforeAthanvalue)

        silenctAfterAthanActiveChecked=settings.getValueFor("silenctAfterAthanActiveChecked",silenctAfterAthanActiveChecked)
        minSilentActiveAfterAthanvalue=settings.getValueFor("minSilentActiveAfterAthanvalue",minSilentActiveAfterAthanvalue)
        minSilentActivedurationvalue=settings.getValueFor("minSilentActivedurationvalue",minSilentActivedurationvalue)

        formatNumberHindiActiveChecked=settings.getValueFor("formatNumberHindiActiveChecked",formatNumberHindiActiveChecked)

        silentDuringTarawihChecked=settings.getValueFor("silentDuringTarawihChecked",silentDuringTarawihChecked)
        minSilentDuringTarawihvalue=settings.getValueFor("minSilentDuringTarawihvalue",minSilentDuringTarawihvalue)

        stopathanonrotationChecked=settings.getValueFor("stopathanonrotationChecked",stopathanonrotationChecked)

        silentDuringSalatJommoaaChecked=settings.getValueFor("silentDuringSalatJommoaaChecked",silentDuringSalatJommoaaChecked)
        minSilentActiveBeforAthanJommoaavalue=settings.getValueFor("minSilentActiveBeforAthanJommoaavalue",minSilentActiveBeforAthanJommoaavalue)
        minSilentActiveAfterAthanJommoaavalue=settings.getValueFor("minSilentActiveAfterAthanJommoaavalue",minSilentActiveAfterAthanJommoaavalue)

        playAthkarSabahChecked=settings.getValueFor("playAthkarSabahChecked",playAthkarSabahChecked)
        playAthkarMassaChecked=settings.getValueFor("playAthkarMassaChecked",playAthkarMassaChecked)

        minplayAthkarSabah=settings.getValueFor("minplayAthkarSabah",minplayAthkarSabah)
        minplayAthkarMassa=settings.getValueFor("minplayAthkarMassa",minplayAthkarMassa)

    }

    function saveSettings() {
        settings.saveValueFor("athanHasStoped",athanHasStoped)
        settings.saveValueFor("cityname",cityname)
        settings.saveValueFor("longi",longi)
        settings.saveValueFor("lat",lat)
        settings.saveValueFor("tzone",tzone)
        settings.saveValueFor("dst",dst)
        settings.saveValueFor("method",method)
        settings.saveValueFor("exmethods",exmethods)

        settings.saveValueFor("adjust_hijri",adjust_hijri)
        settings.saveValueFor("adjust_fajr",adjust_fajr)
        settings.saveValueFor("adjust_dhuhr",adjust_dhuhr)
        settings.saveValueFor("adjust_asr",adjust_asr)
        settings.saveValueFor("adjust_maghrib",adjust_maghrib)
        settings.saveValueFor("adjust_isha",adjust_isha)

        settings.saveValueFor('adhan_Fajr',adhan_Fajr)
        settings.saveValueFor('selectedFajrAdhanFileUser',selectedFajrAdhanFileUser)

        settings.saveValueFor("stylecompass",stylecompass)

        settings.saveValueFor("noAthanInSilentProfileChecked",noAthanInSilentProfileChecked)
        settings.saveValueFor("volumeAthanSlidervalue",volumeAthanSlidervalue)

        settings.saveValueFor("alerteActiveChecked",alerteActiveChecked)
        settings.saveValueFor("minAlerteBeforeAthanvalue",minAlerteBeforeAthanvalue)

        settings.saveValueFor("silenctAfterAthanActiveChecked",silenctAfterAthanActiveChecked)
        settings.saveValueFor("minSilentActiveAfterAthanvalue",minSilentActiveAfterAthanvalue)
        settings.saveValueFor("minSilentActivedurationvalue",minSilentActivedurationvalue)

        settings.saveValueFor("formatNumberHindiActiveChecked",formatNumberHindiActiveChecked)

        settings.saveValueFor("silentDuringTarawihChecked",silentDuringTarawihChecked)
        settings.saveValueFor("minSilentDuringTarawihvalue",minSilentDuringTarawihvalue)

        settings.saveValueFor("stopathanonrotationChecked",stopathanonrotationChecked)

        settings.saveValueFor("silentDuringSalatJommoaaChecked",silentDuringSalatJommoaaChecked)
        settings.saveValueFor("minSilentActiveBeforAthanJommoaavalue",minSilentActiveBeforAthanJommoaavalue)
        settings.saveValueFor("minSilentActiveAfterAthanJommoaavalue",minSilentActiveAfterAthanJommoaavalue)

        settings.saveValueFor("playAthkarSabahChecked",playAthkarSabahChecked)
        settings.saveValueFor("playAthkarMassaChecked",playAthkarMassaChecked)

        settings.saveValueFor("minplayAthkarSabah",minplayAthkarSabah)
        settings.saveValueFor("minplayAthkarMassa",minplayAthkarMassa)



    }


    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaFlickable {
        id: thakirsilicaFlickable
        anchors.fill: parent
        height: _mainPage.height-idFooterRow.height
        // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
        PullDownMenu {
            MenuItem {
                text: qsTr("Favorites")
                onClicked: pageStack.push(Qt.resolvedUrl("Favorites.qml"))
            }
//            MenuItem {
//                text: qsTr("Listening to some Athkar")
//                onClicked: pageStack.push(Qt.resolvedUrl("Athkar.qml"))
//            }
            MenuItem {
                text: qsTr("Direction of Quibla")
                onClicked: pageStack.push(Qt.resolvedUrl("Quibla.qml"))
            }
        }

        // Tell SilicaFlickable the height of its content.
        contentHeight: displayInfo_dpiHeight-idFooterRow.height

        // Place our content in a Column.  The PageHeader is always placed at the top
        // of the page, followed by our content.
        //        Column {
        //            id: column
        //            width: displayInfo_dpiWidth
        //            height: displayInfo_dpiHeight
        //            anchors.centerIn: parent.Center
        //            spacing: uiArabic ? Theme.paddingMedium : Theme.paddingLarge

        Label {
            id:label1
            x: Theme.paddingLarge
            width:  parent.width
            text: qsTr("Prayer Times for: ")+ cityname
            color: Theme.secondaryHighlightColor
            font.pixelSize: Theme.fontSizeLarge
            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
            wrapMode: Text.Wrap
            truncationMode: TruncationMode.Fade
            anchors.top: parent.top
            anchors.topMargin: skipinterval

        }
        Label {
            id:label2
            x: Theme.paddingLarge
            width:  parent.width
            text:  lang=="2"? (formatNumberHindiActiveChecked=="0"? time_now_Arab_NbreHindi: time_now_Arab ) :time_now
            color: Theme.secondaryHighlightColor
            font.pixelSize: Theme.fontSizeLarge
            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: label1.bottom
            anchors.topMargin: skipinterval
        }
        Label {
            id: text_time_hijri
            x: Theme.paddingLarge
            width:  parent.width
            text: lang=="2"? (formatNumberHindiActiveChecked=="0"? time_hijri_Arab_NbreHindi: time_hijri_Arab ):time_hijri
            color: Theme.secondaryHighlightColor
            font.pixelSize: Theme.fontSizeLarge
            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: label2.bottom
            anchors.topMargin: skipinterval
        }
        Column {
            id:column1
            width: displayInfo_dpiWidth
            anchors.centerIn: parent.Center
            anchors.topMargin: skipinterval
            //uiArabic ? Theme.paddingMedium : Theme.paddingLarge
            anchors.top: text_time_hijri.bottom
            Row {
                width: displayInfo_dpiWidth
                layoutDirection: uiArabic ? Qt.RightToLeft : Qt.LeftToRight
                Label {
                    text: qsTr("Fajr")
                    width: (displayInfo_dpiWidth - displayInfo_dpiMarge) / 3.
                    horizontalAlignment: Text.AlignHCenter
                }
                Label {
                    text: qsTr("Chourouq")
                    width: (displayInfo_dpiWidth - displayInfo_dpiMarge) / 3.
                    horizontalAlignment: Text.AlignHCenter
                }
                Label {
                    text: qsTr("Dhouhr")
                    width: (displayInfo_dpiWidth - displayInfo_dpiMarge) / 3.
                    horizontalAlignment: Text.AlignHCenter
                }
            }
            Row {
                width: displayInfo_dpiWidth
                layoutDirection: uiArabic ? Qt.RightToLeft : Qt.LeftToRight
                Button {
                    id: timefajr_text
                    text: (timefajr.charAt(2) == "N" || timefajr.charAt(2)=="n" ) ? "--:--"  : timefajr
                    width: (displayInfo_dpiWidth - displayInfo_dpiMarge) / 3.
                    color: isfajrExtrem? Theme.highlightColor : Theme.primaryColor
                    //onClicked: calculcpp.playathkarSabah()
                }
                Button {
                    id: timesunrise_text
                    text: (timesunrise.charAt(2) == "N" || timesunrise.charAt(2)=="n" ) ? "--:--"  : timesunrise
                    width: (displayInfo_dpiWidth - displayInfo_dpiMarge) / 3.
                    color: issunriseExtrem? Theme.highlightColor : Theme.primaryColor
                }
                Button {
                    id: timedhuhr_text
                    text: (timedhuhr.charAt(2) == "N" || timedhuhr.charAt(2)=="n" )? "--:--"  : timedhuhr
                    width: (displayInfo_dpiWidth - displayInfo_dpiMarge) / 3.
                    color: isdhuhrExtrem? Theme.highlightColor : Theme.primaryColor
                }
            }
        }
        Column {
            id:column2
            width: displayInfo_dpiWidth
            anchors.centerIn: parent.Center
            anchors.topMargin: skipinterval
            // spacing: uiArabic ? Theme.paddingMedium : Theme.paddingLarge
            anchors.top: column1.bottom
            Row {
                width: displayInfo_dpiWidth
                layoutDirection: uiArabic ? Qt.RightToLeft : Qt.LeftToRight
                Label {
                    text: qsTr("Assar")
                    width: (displayInfo_dpiWidth - displayInfo_dpiMarge) / 3.
                    horizontalAlignment: Text.AlignHCenter
                }
                Label {
                    text: qsTr("Maghreb")
                    width: (displayInfo_dpiWidth - displayInfo_dpiMarge) / 3.
                    horizontalAlignment: Text.AlignHCenter
                }
                Label {
                    text: qsTr("Ishaa")
                    width: (displayInfo_dpiWidth - displayInfo_dpiMarge) / 3.
                    horizontalAlignment: Text.AlignHCenter
                }
            }
            Row {
                width: displayInfo_dpiWidth
                layoutDirection: uiArabic ? Qt.RightToLeft : Qt.LeftToRight
                Button {
                    id: timeasr_text
                    text: (timeasr.charAt(2) == "N" || timeasr.charAt(2)=="n" ) ? "--:--"  : timeasr
                    width: (displayInfo_dpiWidth - displayInfo_dpiMarge) / 3.
                    color: isasrExtrem? Theme.highlightColor : Theme.primaryColor
                }
                Button {
                    id: timemaghrib_text
                    text: (timemaghrib.charAt(2) == "N" || timemaghrib.charAt(2)=="n" ) ? "--:--"  : timemaghrib
                    width: (displayInfo_dpiWidth - displayInfo_dpiMarge) / 3.
                    color: ismaghribExtrem? Theme.highlightColor : Theme.primaryColor
                }
                Button {
                    id: timeisha_text
                    text: (timeisha.charAt(2) == "N" || timeisha.charAt(2)=="n" ) ? "--:--"  : timeisha
                    width: (displayInfo_dpiWidth - displayInfo_dpiMarge) / 3.
                    color: isishaExtrem? Theme.highlightColor : Theme.primaryColor
                }
            }
        }
        Column {
            id:column3
            width: displayInfo_dpiWidth
            anchors.centerIn: parent.Center
            anchors.topMargin: skipinterval
            //spacing: uiArabic ? Theme.paddingMedium : Theme.paddingLarge
            anchors.top: column2.bottom
            Row {
                width: displayInfo_dpiWidth
                layoutDirection: uiArabic ? Qt.RightToLeft : Qt.LeftToRight
                Label {
                    id:text_Midnight
                    text: qsTr("Midnight") //"End time Isha"
                    width: isRamathan ? (displayInfo_dpiWidth - displayInfo_dpiMarge) / 3. : (displayInfo_dpiWidth - displayInfo_dpiMarge) / 2.
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: Theme.fontSizeMedium
                }
                Label {
                    id:label_temp
                    text: (isRamathan)? qsTr("Last 1/3 Night"): qsTr("Last 1/3 Night Begins")
                    width: isRamathan ? (displayInfo_dpiWidth - displayInfo_dpiMarge) / 3. : (displayInfo_dpiWidth - displayInfo_dpiMarge) / 2.
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: Theme.fontSizeMedium//Theme.fontSizeLarge //Theme.fontSizeMedium //Theme.fontSizeSmall

                }
                Label {
                    text: qsTr("Imsak") // if ramathan imsak
                    width:  isRamathan ? (displayInfo_dpiWidth - displayInfo_dpiMarge) / 3. : (displayInfo_dpiWidth - displayInfo_dpiMarge) / 2.
                    horizontalAlignment: Text.AlignHCenter
                    visible: isRamathan
                    font.pixelSize: Theme.fontSizeMedium
                }
            }
            Row {
                width: displayInfo_dpiWidth
                layoutDirection: uiArabic ? Qt.RightToLeft : Qt.LeftToRight
                Button {
                    id: time_end_Isha_text
                    text:(time_end_Isha.charAt(2) == "N" || time_end_Isha.charAt(2)=="n" ) ? "--:--"  : time_end_Isha
                    width: isRamathan ? (displayInfo_dpiWidth - displayInfo_dpiMarge) / 3. : (displayInfo_dpiWidth - displayInfo_dpiMarge) / 2.
                }
                Button {
                    id: timebegin_Tholoth_akhir_text
                    text:(timebegin_Tholoth_akhir.charAt(2) == "N" || timebegin_Tholoth_akhir.charAt(2)=="n" ) ? "--:--"  : timebegin_Tholoth_akhir
                    width: isRamathan ? (displayInfo_dpiWidth - displayInfo_dpiMarge) / 3. : (displayInfo_dpiWidth - displayInfo_dpiMarge) / 2.
                }
                Button {
                    id: timeimsak_text
                    text:(timeimsak.charAt(2) == "N" || timeimsak.charAt(2)=="n" ) ? "--:--"  : timeimsak
                    width: isRamathan ? (displayInfo_dpiWidth - displayInfo_dpiMarge) / 3. : (displayInfo_dpiWidth - displayInfo_dpiMarge) / 2.
                    visible: isRamathan
                }
            }
        }
        Column {
            id: column4
            width: displayInfo_dpiWidth
            //spacing: Theme.paddingSmall
            anchors.topMargin: skipinterval
            anchors.top: column3.bottom
            //anchors.topMargin: 100
            Thakir.ProgressBar {
                id: progressBar
                x: (displayInfo_dpiWidth - progressBar.width)/2.
                width: parent.width - 50
                rotation: uiArabic ? 180 : 0
                height: 15
                opacity: 1.0
                progress: pourcent_remaining_time/100
            }
            Label {
                text: qsTr("Remaining time until: ") + next_salat
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: Theme.fontSizeMedium
            }
            Button {
                id: remaining_time_text
                text:(athanIsPlaying === true) ? qsTr("Stop Adhan/Athkar")  : (remaining_time.charAt(2) == "N" || remaining_time.charAt(2)=="n" ) ? "--:--"  : remaining_time
                width: (athanIsPlaying === true) ? (displayInfo_dpiWidth - displayInfo_dpiMarge) / 2. : (displayInfo_dpiWidth - displayInfo_dpiMarge) / 3.
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: {
                    calculcpp.haftimersplayall()
                    calculcpp.stopAdhan()
                    athanHasStoped=true;
                    settings.saveValueFor("athanHasStoped",athanHasStoped)
                }
            }
        }
        Rectangle {
            id:testhikmaAndevent_hijri
            width:  parent.width
            anchors.top: column4.bottom
            height: testhikmaAndevent_hijri2.contentItem.height//300
            anchors.topMargin: skipinterval
            anchors.bottomMargin: skipinterval
            color: "transparent"
            TextArea {
                id:testhikmaAndevent_hijri2
                x: Theme.paddingLarge
                width:  parent.width
                height: 300
                //text: "haf haf haf haf haf haf haf haf haf haf haf haf haf haf haf haf haf haf haf haf haf haf haf haf haf haf haf haf haf haf haf haf haf haf haf haf haf haf haf haf haf haf haf haf haf haf haf haf haf haf haf haf haf haf haf haf haf haf haf haf haf haf haf haf haf haf haf haf haf haf haf haf haf haf haf haf haf haf haf haf haf haf haf haf haf haf haf haf haf haf haf haf haf haf haf haf haf haf haf haf haf haf haf haf haf "
                text: playhaftimersisActive==true ? event_hijri : "noactive (Please restart Application)"
                anchors.top: parent.top
                //y : (idFooterRow.y+column4.y)/2
                //                text: (playhaftimersisActive==true ? "active\n" : "noactive\n") +
                //                "t1: "+ run_periodsActiveAtlert+"("+run_periodsActiveAtlertIsActive+")"+"---"+
                //                "t2: "+ run_periodsActiveAthan+"("+run_periodsActiveAthanIsActive+")"+"\n"+
                //                "t3: "+ run_periodsActiveSilent+"("+run_periodsActiveSilentIsActive+")"+"---"+
                //                "t4: "+ run_periodsActiveBackMode+"("+run_periodsActiveBackModeIsActive+")"

                color: Theme.secondaryHighlightColor
                font.pixelSize: Theme.fontSizeMedium
                //font.pixelSize: Theme.fontSizeSmall
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
                wrapMode: Text.Wrap
                //truncationMode: TruncationMode.Fade
                // visible: event_hijri !== ""
                readOnly: true
                enabled :true
                onPressAndHold: {
                    selectAll()
                    copy()
                }
                focus: true
                autoScrollEnabled: true

            }
        }
        OrientationSensor {
            id: orientationSensor
            active: true
            onReadingChanged: {
                if (reading.orientation === OrientationReading.FaceDown && stopathanonrotationChecked==='0'){
                    calculcpp.stopAdhan()
                    athanHasStoped=true;
                    settings.saveValueFor("athanHasStoped",athanHasStoped)
                }
            }
        }
    }
    Rectangle {
        id: idFooterRow
        anchors.bottom: _mainPage.bottom
        width: _mainPage.width
        height:  Theme.itemSizeSmall
        color: Theme.highlightDimmerColor
        Separator {
            id: navigationRowSeparator
            width: parent.width
            color: Theme.primaryColor
            horizontalAlignment: Qt.AlignHCenter
        }
        Row {
            anchors.fill: parent
            IconButton {
                //enabled: finishedLoading
                width: parent.width / 3
                height: parent.height
                icon.scale: 1.25
                icon.color: Theme.primaryColor
                icon.source: "../Images/Doaa.png"
                //color: (currentView === "folder") ? (finishedLoading ? Theme.highlightColor : Theme.secondaryHighlightColor) : (finishedLoading ? Theme.primaryColor : Theme.secondaryColor)
                //text: qsTr("Quran")
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("Athkar.qml"))
                    //currentView = "folder"
                    //storageItem.setSetting("infoCurrentView", "folder")
                }
            }
            IconButton {
                //enabled: finishedLoading
                width: parent.width / 3
                height: parent.height
                icon.scale: 1.25
                icon.color: Theme.primaryColor
                icon.source: "../Images/Quran-icon.png"
                //color: (currentView === "folder") ? (finishedLoading ? Theme.highlightColor : Theme.secondaryHighlightColor) : (finishedLoading ? Theme.primaryColor : Theme.secondaryColor)
                //text: qsTr("Quran")
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("Souwar.qml"))
                    //currentView = "folder"
                    //storageItem.setSetting("infoCurrentView", "folder")
                }
            }
            IconButton {
                //enabled: finishedLoading
                width: parent.width / 3
                height: parent.height
                icon.scale: 0.9
                icon.color: Theme.primaryColor
                icon.source: "image://theme/icon-m-developer-mode?"
                onClicked: {
                    pageStack.animatorPush(Qt.resolvedUrl("SettingsPage.qml"))
                }
                onPressAndHold: {
                    //
                }
            }
        }
    }

    Component.onCompleted: {
        readConfig();
        //updateUi();
        saveSettings();
        calcul();
        //timeintial.start()
        //-----HAF 21-2-2022---------
        skipinterval=((Screen.height-idFooterRow.height)-(column1.height+column2.height+column3.height+column4.height+label1.height+label2.height+text_time_hijri.height+testhikmaAndevent_hijri.height))/9
        //console.log("skipinterval:" + skipinterval)
        //console.log("Screen.height:" + Screen.height)
        //----------------------------
    }
    //    LightSensor {
    //        id: lightSensor

    //        //active: cover.status === Cover.Active || applicationActive

    //        // Jolla light sensor gives quite easily a zero level in low light...
    //        //property real _nightThreshold: 0

    //        onReadingChanged: {
    //            calculcpp.stopAdhan()
    //            //calculcpp.playAdhanUrl(selectedFajrAdhanFileUser)
    //            //next_salat='dfqsdqsdqsdqsdqsdqs'

    //            ////console.log("***Light reading: " + reading.illuminance);
    //            //sharedSettings.sensorNigth = (reading.illuminance <= _nightThreshold) && active;
    //        }
    //        onActiveChanged: {
    //            //calculcpp.stopAdhan()

    //            ////console.log("***Light sensor: " + (active ? "START" : "STOP"));
    //            //if (!active) {
    //                //sharedSettings.sensorNigth = false; // Default to "day" when sensor is off
    //            //}
    //        }
    //    }
    onStatusChanged: {
        ////console.log("Page XXX: onStatusChanged: status: " + status);

        //if (status === PageStatus.Active) {
        //    calcul();
        //}
        if (status === PageStatus.Active) {
            //----For Favorites -5-12-2015-----
            saveSettings();
            readConfig();
            //--------------------------------

            calcul();
            timerclock.restart();
            event_hijri = calculcpp.getstrDaysEvent(adjust_hijri);
            calculcpp.stopAthkar();
            // timercalcul.restart();

            // lightSensor.active=true;

        }else{
            //lightSensor.active=false;
        }
    }
}


