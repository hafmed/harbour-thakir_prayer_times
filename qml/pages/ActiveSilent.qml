
import QtQuick 2.0
import Sailfish.Silica 1.0


Page {
    id: page

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
            //spacing: Theme.paddingMedium
            anchors.horizontalCenter: parent.horizontal
            PageHeader {
                title: qsTr("Silent Mode Activation Settings")
            }

            TextSwitch {
                id: noAthanInSilentProfile
                text:  qsTr("No Adhan in Silent Profile")
                checked: noAthanInSilentProfileChecked=="0"
                onCheckedChanged: {
                    if (checked) {
                        noAthanInSilentProfileChecked="0"
                    }else{
                        noAthanInSilentProfileChecked="1"
                    }
                    //console.log("noAthanInSilentProfileChecked="+noAthanInSilentProfileChecked)
                    settings.saveValueFor("noAthanInSilentProfileChecked",noAthanInSilentProfileChecked)
                }
            }

            TextSwitch {
                id: silenctAfterAthanActive
                text:  qsTr("Activation of Silent Mode during Prayer")
                checked: silenctAfterAthanActiveChecked=="0"
                onCheckedChanged: {
                    if (checked) {
                        silenctAfterAthanActiveChecked="0"
                    }else{
                        silenctAfterAthanActiveChecked="1"
                    }
                    settings.saveValueFor("silenctAfterAthanActiveChecked",silenctAfterAthanActiveChecked)
                }
            }

            Row {
                width: parent.width
                visible: silenctAfterAthanActiveChecked=="0"
                layoutDirection: uiArabic ? Qt.RightToLeft : Qt.LeftToRight
                Column {
                    id: column2
                    width: parent.width/2
                Label {
                    text: formatNumberHindiActiveChecked=="0"? calculcpp.formatNumberHindi(minSilentActiveAfterAthan.value.toFixed(0))+ qsTr(" min after Adhan") : minSilentActiveAfterAthan.value.toFixed(0)+ qsTr(" min after Adhan")
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: Theme.highlightColor
                    font.family: Theme.fontFamilyHeading
                }
                Slider {
                    id: minSilentActiveAfterAthan
                    width: parent.width
                    rotation: uiArabic ? 180 : 0
                    minimumValue: 1
                    maximumValue: 15
                    value: minSilentActiveAfterAthanvalue
                    onValueChanged: {
                        minSilentActiveAfterAthanvalue=minSilentActiveAfterAthan.value.toFixed(0)
                        console.log("minSilentActiveAfterAthanvalue="+minSilentActiveAfterAthanvalue)
                        settings.saveValueFor("minSilentActiveAfterAthanvalue",minSilentActiveAfterAthanvalue)
                    }
                }
                }
                Column {
                    id: column3
                    width: parent.width/2
                Label {
                    text: formatNumberHindiActiveChecked=="0"? qsTr("Duration ")+calculcpp.formatNumberHindi(minSilentActiveduration.value.toFixed(0))+ qsTr(" min") : qsTr("Duration ")+minSilentActiveduration.value.toFixed(0)+ qsTr(" min")
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: Theme.highlightColor
                    font.family: Theme.fontFamilyHeading
                }
                Slider {
                    id: minSilentActiveduration
                    width: parent.width
                    rotation: uiArabic ? 180 : 0
                    minimumValue: 5
                    maximumValue: 25
                    value: minSilentActivedurationvalue
                    onValueChanged: {
                        minSilentActivedurationvalue=minSilentActiveduration.value.toFixed(0)
                        console.log("minSilentActivedurationvalue="+minSilentActivedurationvalue)
                        settings.saveValueFor("minSilentActivedurationvalue",minSilentActivedurationvalue)
                    }
                }
                }

            }

            //------Jommoaa Silent 17-11-2018-----
            TextSwitch {
                id: silentDuringSalatJommoaaActive
                text:  qsTr("Activation of Silent Mode during Jommoaa Prayer")
                checked: silentDuringSalatJommoaaChecked=="0"
                onCheckedChanged: {
                    if (checked) {
                        silentDuringSalatJommoaaChecked="0"
                    }else{
                        silentDuringSalatJommoaaChecked="1"
                    }
                    settings.saveValueFor("silentDuringSalatJommoaaChecked",silentDuringSalatJommoaaChecked)
                }
            }

            Row {
                width: parent.width
                visible: silentDuringSalatJommoaaChecked=="0"
                layoutDirection: uiArabic ? Qt.RightToLeft : Qt.LeftToRight
                Column {
                    id: column2bis
                    width: parent.width/2
                Label {
                    text: formatNumberHindiActiveChecked=="0"? calculcpp.formatNumberHindi(minSilentActiveBeforAthanJommoaa.value.toFixed(0))+ qsTr(" min before Adhan") : minSilentActiveBeforAthanJommoaa.value.toFixed(0)+ qsTr(" min before Adhan")
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: Theme.highlightColor
                    font.family: Theme.fontFamilyHeading
                }
                Slider {
                    id: minSilentActiveBeforAthanJommoaa
                    width: parent.width
                    rotation: uiArabic ? 180 : 0
                    minimumValue: 1
                    maximumValue: 35
                    value: minSilentActiveBeforAthanJommoaavalue
                    onValueChanged: {
                        minSilentActiveBeforAthanJommoaavalue=minSilentActiveBeforAthanJommoaa.value.toFixed(0)
                        console.log("minSilentActiveBeforAthanJommoaavalue="+minSilentActiveBeforAthanJommoaavalue)
                        settings.saveValueFor("minSilentActiveBeforAthanJommoaavalue",minSilentActiveBeforAthanJommoaavalue)
                    }
                }
                }
                Column {
                    id: column3bis
                    width: parent.width/2
                Label {
                    text: formatNumberHindiActiveChecked=="0"? calculcpp.formatNumberHindi(minSilentActiveAfterAthanJommoaa.value.toFixed(0))+ qsTr(" min after Adhan") : minSilentActiveAfterAthanJommoaa.value.toFixed(0)+ qsTr(" min after Adhan")
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: Theme.highlightColor
                    font.family: Theme.fontFamilyHeading
                }
                Slider {
                    id: minSilentActiveAfterAthanJommoaa
                    width: parent.width
                    rotation: uiArabic ? 180 : 0
                    minimumValue: 1
                    maximumValue: 55
                    value: minSilentActiveAfterAthanJommoaavalue
                    onValueChanged: {
                        minSilentActiveAfterAthanJommoaavalue=minSilentActiveAfterAthanJommoaa.value.toFixed(0)
                        console.log("minSilentActiveAfterAthanJommoaavalue="+minSilentActiveAfterAthanJommoaavalue)
                        settings.saveValueFor("minSilentActiveAfterAthanJommoaavalue",minSilentActiveAfterAthanJommoaavalue)
                    }
                }
                }

            }
            //------------------------------------

            TextSwitch {
                id: silentDuringTarawih
                text:  qsTr("Activation of Silent Mode during Taraweeh Prayer")
                visible: isRamathan
                checked: silentDuringTarawihChecked=="0"
                onCheckedChanged: {
                    if (checked) {
                        silentDuringTarawihChecked="0"
                    }else{
                        silentDuringTarawihChecked="1"
                    }
                    settings.saveValueFor("silentDuringTarawihChecked",silentDuringTarawihChecked)
                }
            }
            Column {
                id: columnsilentDuringTarawihChecked
                width: parent.width
                visible: isRamathan
            Label {
                text: formatNumberHindiActiveChecked=="0"? calculcpp.formatNumberHindi(minSilentDuringTarawih.value.toFixed(0))+ qsTr(" min after Adhan Ishaa") : minSilentDuringTarawih.value.toFixed(0)+ qsTr(" min after Adhan Ishaa")
                anchors.horizontalCenter: parent.horizontalCenter
                color: Theme.highlightColor
                font.family: Theme.fontFamilyHeading
            }
            Slider {
                id: minSilentDuringTarawih
                width: parent.width
                rotation: uiArabic ? 180 : 0
                minimumValue: 1
                maximumValue: 95
                value: minSilentDuringTarawihvalue
                onValueChanged: {
                    minSilentDuringTarawihvalue=minSilentDuringTarawih.value.toFixed(0)
                    console.log("minSilentDuringTarawihvalue="+minSilentDuringTarawihvalue)
                    settings.saveValueFor("minSilentDuringTarawihvalue",minSilentDuringTarawihvalue)
                }
            }
            }

        }
    }
    function baseName(str) {
       var base = new String(str).substring(str.lastIndexOf('/') + 1);
        if(base.lastIndexOf(".") != -1)
            base = base.substring(0, base.lastIndexOf("."));
       return base;
    }
    onStateChanged: {

    }

    Component.onCompleted: {


    }

}





