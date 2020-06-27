
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
            spacing: Theme.paddingSmall//Theme.paddingLarge
//            anchors.horizontalCenter: parent.horizontal
            PageHeader {
                title: qsTr("Adjustments")
            }
            //-------
            Slider {
                id: slider_adjust_hijri
                value: adjust_hijri
                minimumValue:-3
                maximumValue:3
                stepSize: 1
                width: parent.width
                valueText:formatNumberHindiActiveChecked=="0"? calculcpp.formatNumberHindi(value.toFixed(0)) : value.toFixed(0)
                label: qsTr("Adjust Hijri date")
                onValueChanged: {
                    adjust_hijri=slider_adjust_hijri.value
                    settings.saveValueFor("adjust_hijri",adjust_hijri)
                    event_hijri = calculcpp.getstrDaysEvent(adjust_hijri);
                }
            }
            Slider {
                id: slider_adjust_fajr
                value: adjust_fajr
                minimumValue:-30
                maximumValue:30
                stepSize: 1
                width: parent.width
                valueText: formatNumberHindiActiveChecked=="0"? calculcpp.formatNumberHindi(value.toFixed(0))+qsTr(" min") : value.toFixed(0)+qsTr(" min")
                label: qsTr("Adjust Fajr")
                onValueChanged: {
                    adjust_fajr=slider_adjust_fajr.value
                    settings.saveValueFor("adjust_fajr",adjust_fajr)
                }
            }
            Slider {
                id: slider_adjust_dhuhr
                value: adjust_dhuhr
                minimumValue:-30
                maximumValue:30
                stepSize: 1
                width: parent.width
                valueText: formatNumberHindiActiveChecked=="0"? calculcpp.formatNumberHindi(value.toFixed(0))+qsTr(" min") : value.toFixed(0)+qsTr(" min")
                label: qsTr("Adjust Dhuhr")
                onValueChanged: {
                    adjust_dhuhr=slider_adjust_dhuhr.value
                    settings.saveValueFor("adjust_dhuhr",adjust_dhuhr)
                }
            }
            Slider {
                id: slider_adjust_asr
                value: adjust_asr
                minimumValue:-30
                maximumValue:30
                stepSize: 1
                width: parent.width
                valueText: formatNumberHindiActiveChecked=="0"? calculcpp.formatNumberHindi(value.toFixed(0))+qsTr(" min") : value.toFixed(0)+qsTr(" min")
                label: qsTr("Adjust Assar")
                onValueChanged: {
                    adjust_asr=slider_adjust_asr.value
                    settings.saveValueFor("adjust_asr",adjust_asr)
                }
            }
            Slider {
                id: slider_adjust_maghrib
                value: adjust_maghrib
                minimumValue:-30
                maximumValue:30
                stepSize: 1
                width: parent.width
                valueText: formatNumberHindiActiveChecked=="0"? calculcpp.formatNumberHindi(value.toFixed(0))+qsTr(" min") : value.toFixed(0)+qsTr(" min")
                label: qsTr("Adjust Maghrib")
                onValueChanged: {
                    adjust_maghrib=slider_adjust_maghrib.value
                    settings.saveValueFor("adjust_maghrib",adjust_maghrib)
                }
            }
            Slider {
                id: slider_adjust_isha
                value: adjust_isha
                minimumValue:-30
                maximumValue:30
                stepSize: 1
                width: parent.width
                valueText: formatNumberHindiActiveChecked=="0"? calculcpp.formatNumberHindi(value.toFixed(0))+qsTr(" min") : value.toFixed(0)+qsTr(" min")
                label: qsTr("Adjust Isha")
                onValueChanged: {
                    adjust_isha=slider_adjust_isha.value
                    settings.saveValueFor("adjust_isha",adjust_isha)
                }
            }
            //-------
        }
    }
    onStateChanged: {
    }

    Component.onCompleted: {
    }
}





