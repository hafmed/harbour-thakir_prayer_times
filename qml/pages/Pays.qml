
import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQuick.XmlListModel 2.0


Page {
    id: page
    BusyIndicator {
        size: BusyIndicatorSize.Large
        anchors.centerIn: parent
        running: chapterFetcher.status == XmlListModel.Loading
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
                title: qsTr("Choose Country")+" --- "+indexregion
                wrapMode: Text.Wrap
            }
            XmlListModel{
                id: chapterFetcher
                source: "Locations.xml"
                query: "/gweather/region[name=\'" + indexregion + "'\]/country"

                XmlRole { name: "name"; query: "name["+lang+"]/string()" }
                XmlRole { name: "name_en"; query: "name[1]/string()" }

                XmlRole { name: "gmt"; query: "gmt/string()" }
                XmlRole { name: "method"; query: "method/string()" }
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
                                text: name
                            }

                            onClicked: {
                                indexpays=model.name
                                 if (model.gmt !== "") {
                                     tzone=model.gmt
                                 }else{
                                     tzone="Auto"
                                 }
                                 if (model.method !== "") {
                                     method=model.method
                                 }else{
                                     method="0"
                                 }

                                 method=Math.floor(model.method)
                                 console.log("tzone-----="+tzone)
                                 console.log("method-----="+method)
                                //get_method(index_pays)
                                 if (model.name_en==="United States" || model.name_en==="Canada" || model.name_en==="Belgium" || model.name_en==="Australia"){
                                     payhasstate=true;
                                     pageStack.replace(Qt.resolvedUrl("State.qml"));
                                 }else{
                                     payhasstate=false;
                                     pageStack.replace(Qt.resolvedUrl("City.qml"));
                                 }
                            }
                        }
                }

            }

        }
    }
    Component.onCompleted: {


    }

}
