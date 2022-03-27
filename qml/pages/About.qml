// HAF 29-5-2021
// HAF 5-11-2015

import QtQuick 2.6
import Sailfish.Silica 1.0


Page {
    id: page
    property string version: "4.0.19"
    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height

        Column {
            id: column
            width: displayInfo_dpiWidth
            spacing: Theme.paddingMedium
            //            anchors.horizontalCenter: parent.horizontal
            PageHeader {
                title: qsTr("About")
            }
            Label {
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: Theme.fontSizeSmall
                wrapMode: Text.WordWrap
                color : "red"
                horizontalAlignment: Text.AlignHCenter
                text:"Please keep application open to hear automatically Azan (ATHAN)."
            }
            Label {
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: Theme.fontSizeSmall
                wrapMode: Text.WordWrap
                //maximumLineCount: 2
                horizontalAlignment: Text.AlignHCenter
                text:
                    "Thakir Prayer Times \n"+
                    "Version "+version+"\n"+
                    "27-3-2022 for openrepos.net and harbour.jolla\n"+ //for openrepos.net //harbour.jolla
                    "By Mohamed HAFIANE,"
            }
            Label {
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: Theme.fontSizeSmall
                wrapMode: Text.WordWrap
                //maximumLineCount: 2
                horizontalAlignment: Text.AlignHCenter
                text:
                    "Please ensure that prayer times given by Thakir are in agreement with those of your city.\n"+
                    "The application use the Islamic Tools and Libraries (ITL) from\n"+
                    "https://github.com/arabeyes-org/ITL. Jazzahom ELLAH kola Khir."
            }
            Label {
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                text: "xml file of Quran (Version 1.1) was downloaded from: <a href=\"https://tanzil.net/download\">https://tanzil.net/download/</a>.\n Jazzahom ELLAH kola Khir."
                color: Theme.primaryColor
                linkColor: "#ffffff"
                wrapMode: Text.Wrap
                truncationMode: TruncationMode.Fade
                onLinkActivated: {
                    Qt.openUrlExternally(link)
                }
            }
            Label {
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                text: "Application site is: <a href=\"http://sites.google.com/site/thakirprayertimes\">http://sites.google.com/site/thakirprayertimes</a>."
                color: Theme.primaryColor
                linkColor: "#ffffff"
                wrapMode: Text.Wrap
                truncationMode: TruncationMode.Fade
                onLinkActivated: {
                    Qt.openUrlExternally(link)
                }
            }
            Label {
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: Theme.fontSizeSmall
                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignHCenter
                text:
                    "This application is free. Fisabill ELLAH"
            }
            Label {
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                text: "If you found any bug, please contact me in e-mail: <a href=\"mailto:thakir.dz@gmail.com?subject=About%20Thakir%20Prayer%20Times%20(Ver:"+version+")%20SailfishOS\">thakir.dz@gmail.com</a>"
                color: Theme.primaryColor
                linkColor: "#ffffff"
                wrapMode: Text.Wrap
                truncationMode: TruncationMode.Fade
                onLinkActivated: {
                    Qt.openUrlExternally(link)
                }
            }
            Label {
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: Theme.fontSizeSmall
                wrapMode: Text.WordWrap
                //maximumLineCount: 2
                horizontalAlignment: Text.AlignHCenter
                text:
                    "I will add others features in next version In chaa ELLAH"//\n"
                   // "Qibla direction,..."
            }
        }
    }
    onStatusChanged: {
    }
    Component.onCompleted: {
    }

}
