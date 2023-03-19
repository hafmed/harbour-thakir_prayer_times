/*
    HAF 25-2-2022
*/

import QtQuick 2.6
import Sailfish.Silica 1.0

Page {
    id: settingsPage        

    property var entries: [
        qsTr('Quran Settings'),
        qsTr('Location Settings'),
        qsTr('Alert Settings'),
        qsTr('Silent Mode Settings'),
        qsTr('Time Adjustments'),
        qsTr('About')
    ]

    allowedOrientations: Orientation.All

    SilicaListView {
        id: settingsView

        anchors.fill: parent

        header: PageHeader {
            title: qsTr('Settings')
        }

        model: ListModel {
            ListElement {
                img: "image://theme/icon-m-other?"// "../Images/Quran-icon.png" "image://theme/icon-m-gps?"
                target: 'Settings-Quran.qml'
            }

            ListElement {
                img: "image://theme/icon-m-location?"
                target: 'SettingsLocation.qml'
            }

            ListElement {
                img: "image://theme/icon-m-speaker?"
                target: 'AlertSettings.qml'
            }

            ListElement {
                img: "image://theme/icon-m-silent?"
                target: 'ActiveSilent.qml'
            }

            ListElement {
                img: "image://theme/icon-m-time?"
                target: 'Adjust.qml'
            }

            ListElement {
                img: "image://theme/icon-m-about?"
                target: 'About.qml'
            }
        }

        delegate: ListItem {
            id: delegate

            contentHeight: content.height

            Row {
                id: content

                width: parent.width
                height: Theme.itemSizeSmall

                anchors.left: parent.left
                anchors.leftMargin: Theme.paddingLarge

                anchors.right: parent.right
                anchors.rightMargin: Theme.paddingLarge

                spacing: Theme.paddingLarge

                Image {
                    id: icon

                    height: parent.height

                    source: img

                    verticalAlignment: Image.AlignVCenter

                    fillMode: Image.Pad
                }

                Label {
                    id: label

                    text: entries[model.index]

                    height: parent.height
                    width: parent.width-2*icon.width

                    verticalAlignment: Text.AlignVCenter
                }
            }

            onClicked: {
                pageStack.push(target)
            }

        }
    }
}
