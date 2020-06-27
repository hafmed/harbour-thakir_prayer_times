
import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQuick.XmlListModel 2.0


Page {
    id: page
    BusyIndicator {
        size: BusyIndicatorSize.Large
        anchors.centerIn: parent
        running: xmlModel1.status == XmlListModel.Loading
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
            spacing: Theme.paddingLarge
            anchors.horizontalCenter: parent.horizontal
            PageHeader {
                title: qsTr("Choose Region")
                wrapMode: Text.Wrap
            }
            XmlListModel {
                id: xmlModel1
                source: "Locations.xml"
                //query: "/gweather/region"
                query: "/gweather/region"
                XmlRole { name: "name"; query: "name["+lang+"]/string()" }
                //XmlRole { name: "country"; query: "country/string()" }

                XmlRole {
                    name: "item"
                    query: "item/string()"
                }
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

                model: xmlModel1

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
                                text: name
                            }

                            onClicked: {
                                indexregion=model.name
                                pageStack.replace(Qt.resolvedUrl("Pays.qml"))
                            }
                        }
                }
            }

        }
    }
    Component.onCompleted: {

    }

}





