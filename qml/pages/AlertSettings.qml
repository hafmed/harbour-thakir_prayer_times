
import QtQuick 2.6
import Sailfish.Silica 1.0
import Sailfish.Pickers 1.0 // File-Loader

Page {
    id: page
    Component {
        id: athanPickerPage
        FilePickerPage {
            title: qsTr("Select Athan file!")
            nameFilters: [ '*.mp3', '*.ogg' ]
            onSelectedContentPropertiesChanged: {
                selectedFajrAdhanFileUser = selectedContentProperties.filePath
                selectedFajrAdhanFileUserName = selectedContentProperties.fileName
                settings.saveValueFor("selectedFajrAdhanFileUser",selectedFajrAdhanFileUser)
                settings.saveValueFor("selectedFajrAdhanFileUserName",selectedFajrAdhanFileUserName)
                if (selectedSoundLabel.label.length !== 0) comboBox_Adhan_Fajr.currentIndex=4
            }
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
            //spacing: Theme.paddingMedium
            anchors.horizontalCenter: parent.horizontal
            PageHeader {
                title: qsTr("Alert Settings")
            }

            TextSwitch {
                id: alerteActive
                text:  qsTr("Activation of Alert before Adhan")
                checked: alerteActiveChecked=="0"
                onCheckedChanged: {
                    if (checked) {
                        alerteActiveChecked="0"
                    }else{
                        alerteActiveChecked="1"
                    }
                    settings.saveValueFor("alerteActiveChecked",alerteActiveChecked)
                }
            }

            Label {
                text: formatNumberHindiActiveChecked=="0"? qsTr("Before Adhan by ")+calculcpp.formatNumberHindi(minAlerteBeforeAthan.value.toFixed(0))+qsTr(" min") : qsTr("Before Adhan by ")+ minAlerteBeforeAthan.value.toFixed(0)+qsTr(" min")
                anchors.horizontalCenter: parent.horizontalCenter
                color: Theme.highlightColor
                font.family: Theme.fontFamilyHeading
                visible: alerteActiveChecked=="0"
            }
            Slider {
                id: minAlerteBeforeAthan
                width: parent.width
                rotation: uiArabic ? 180 : 0
                anchors.horizontalCenter: parent.horizontalCenter
                minimumValue: 3
                maximumValue: 20
                value: minAlerteBeforeAthanvalue
                onValueChanged: {
                    minAlerteBeforeAthanvalue=minAlerteBeforeAthan.value.toFixed(0)
                    //console.log("minAlerteBeforeAthanvalue="+minAlerteBeforeAthanvalue)
                    settings.saveValueFor("minAlerteBeforeAthanvalue",minAlerteBeforeAthanvalue)
                }
                visible: alerteActiveChecked=="0"
            }

            ComboBox {
                id: comboBox_Adhan_Fajr
                width: parent.width
                label: qsTr("Select Adhan:")//"Adhan Fajr"
                currentIndex: adhan_Fajr
                onCurrentIndexChanged: {
                    adhan_Fajr=currentIndex
                    //console.log("adhan_Fajr="+adhan_Fajr)
                    settings.saveValueFor("adhan_Fajr",adhan_Fajr)
                }
                menu: ContextMenu {
                    MenuItem { text: qsTr("No Adhan") }
                    MenuItem { text: qsTr("Short Adhan") }
                    MenuItem { text: qsTr("Mecca Adhan")}
                    MenuItem { text: qsTr("Madina Adhan") }
                    MenuItem { text: qsTr("File user for Adhan") } //"File user for Fajr"
                }
            }
            BackgroundItem {
                visible: comboBox_Adhan_Fajr.currentIndex===4;
                width: parent.width;
                Column {
                    spacing: Theme.paddingSmall;
                    x: Theme.paddingLarge;
                    Row {
                        spacing: Theme.paddingMedium;
                        Image {
                            source: 'image://theme/icon-l-speaker';
                            width: Theme.fontSizeLarge;
                            height: Theme.fontSizeLarge;
                        }

                        Label {
                            id: selectedSoundLabel;
                            color: comboBox_Adhan_Fajr.currentIndex===4 ? Theme.secondaryColor : Theme.highlightColor;
                            textFormat: Text.StyledText;
                            text: selectedFajrAdhanFileUserName;
                        }
                    }
                    Label {
                        x: Theme.fontSizeLarge + Theme.paddingMedium;
                        color: comboBox_Adhan_Fajr.currentIndex===0 ? Theme.secondaryColor : Theme.primaryColor;
                        text: qsTr("Select Adhan file user") //"Select Fajr Adhan file user";
                        font.pixelSize: Theme.fontSizeExtraSmall;
                    }
                }

                onClicked: {
                    pageStack.push(athanPickerPage)
                }
            }
            //----------27-11-2018----------
            TextSwitch {
                id: playAthkarSabah
                text:  qsTr("Listining to morning Athkar")
                checked: playAthkarSabahChecked==="0"
                onCheckedChanged: {
                    if (checked) {
                        playAthkarSabahChecked="0"
                    }else{
                        playAthkarSabahChecked="1"
                    }
                    settings.saveValueFor("playAthkarSabahChecked",playAthkarSabahChecked)
                }
            }

            Label {
                text: formatNumberHindiActiveChecked=="0"? qsTr("Before Chorok by ")+calculcpp.formatNumberHindi(minplayAthkarSabahSlider.value.toFixed(0))+qsTr(" min") : qsTr("Before Chorok by ")+ minplayAthkarSabahSlider.value.toFixed(0)+qsTr(" min")
                anchors.horizontalCenter: parent.horizontalCenter
                color: Theme.highlightColor
                font.family: Theme.fontFamilyHeading
                visible: playAthkarSabahChecked==="0"
            }
            Slider {
                id: minplayAthkarSabahSlider
                width: parent.width
                rotation: uiArabic ? 180 : 0
                anchors.horizontalCenter: parent.horizontalCenter
                minimumValue: 3
                maximumValue: 25
                value: minplayAthkarSabah
                onValueChanged: {
                    minplayAthkarSabah=minplayAthkarSabahSlider.value.toFixed(0)
                    //console.log("minplayAthkarSabah="+minplayAthkarSabah)
                    settings.saveValueFor("minplayAthkarSabah",minplayAthkarSabah)
                }
                visible: playAthkarSabahChecked==="0"
            }
            //-----
            TextSwitch {
                id: playAthkarMassa
                text:  qsTr("Listining to evening Athkar")
                checked: playAthkarMassaChecked==="0"
                onCheckedChanged: {
                    if (checked) {
                        playAthkarMassaChecked="0"
                    }else{
                        playAthkarMassaChecked="1"
                    }
                    settings.saveValueFor("playAthkarMassaChecked",playAthkarMassaChecked)
                }
            }

            Label {
                text: formatNumberHindiActiveChecked=="0"? qsTr("Before Maghreb by ")+calculcpp.formatNumberHindi(minplayAthkarMassaSlider.value.toFixed(0))+qsTr(" min") : qsTr("Before Maghreb by ")+ minplayAthkarMassaSlider.value.toFixed(0)+qsTr(" min")
                anchors.horizontalCenter: parent.horizontalCenter
                color: Theme.highlightColor
                font.family: Theme.fontFamilyHeading
                visible: playAthkarMassaChecked==="0"
            }
            Slider {
                id: minplayAthkarMassaSlider
                width: parent.width
                rotation: uiArabic ? 180 : 0
                anchors.horizontalCenter: parent.horizontalCenter
                minimumValue: 3
                maximumValue: 25
                value: minplayAthkarMassa
                onValueChanged: {
                    minplayAthkarMassa=minplayAthkarMassaSlider.value.toFixed(0)
                    //console.log("minplayAthkarMassa="+minplayAthkarMassa)
                    settings.saveValueFor("minplayAthkarMassa",minplayAthkarMassa)
                }
                visible: playAthkarMassaChecked==="0"
            }

            //------ 11-11-2018------------
            TextSwitch {
                id: stopathanonrotation
                text:  qsTr("Stop Adhan/Athkar by turning the device face down")
                checked: stopathanonrotationChecked=="0"
                onCheckedChanged: {
                    if (checked) {
                        stopathanonrotationChecked="0"
                    }else{
                        stopathanonrotationChecked="1"
                    }
                    settings.saveValueFor("stopathanonrotationChecked",stopathanonrotationChecked)
                }
            }
            //------------

        }
    }
    //    function baseName(str) {
    //       var base = new String(str).substring(str.lastIndexOf('/') + 1);
    //        if(base.lastIndexOf(".") != -1)
    //            base = base.substring(0, base.lastIndexOf("."));
    //       return base;
    //    }
    onStatusChanged: {
        if (status !== PageStatus.Inactive) {
            if (comboBox_Adhan_Fajr.currentIndex===4 && selectedFajrAdhanFileUserName.length === 0)
                comboBox_Adhan_Fajr.currentIndex=1
        }
    }

    Component.onCompleted: {


    }

}





