

import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQuick.XmlListModel 2.0


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
            spacing: Theme.paddingLarge
            anchors.horizontalCenter: parent.horizontal
            PageHeader {
                title: qsTr("Choose City")+" --- "+indexpays
                wrapMode: Text.Wrap
            }
            XmlListModel{
                id: chapterFetcher
                source: "Locations.xml"
                query: payhasstate ? "/gweather/region/country/state[name=\'" + indexpays + "'\]/location":"/gweather/region/country[name=\'" + indexpays + "'\]/location"

                XmlRole { name: "name"; query: "name["+lang+"]/string()" }
                XmlRole { name: "coordinates"; query: "coordinates/string()" }
            }
            SilicaListView {
                id: listView
                height: page.height
                VerticalScrollDecorator { flickable: listView }
                anchors.left: parent.left
                anchors.right: parent.right

                // this is needed so that the list elements
                // do not overlap with other controls in column
                clip: true

                model: chapterFetcher

                delegate:
                    ListItem {
                    anchors.left: parent.left
                    anchors.right: parent.right
                        BackgroundItem {
                            id: deviceItem;
                            anchors { left: parent.left; }
                            width: parent.width;

                            Label {
                                horizontalAlignment: Text.AlignHCenter
                                anchors.horizontalCenter: parent.horizontalCenter
                                //anchors.verticalCenter: parent.verticalCenter;
                                width: parent.width;
                                text: name //+coordinates
                            }

                            onClicked: {
                                indexcity=name;
                                coordinatesCity=coordinates;

                                //get_method(index_pays)
                                pageStack.replace(Qt.resolvedUrl("Coord.qml"));

                            }
                        }
                }

            }

        }
    }
    Component.onCompleted: {


    }

}





