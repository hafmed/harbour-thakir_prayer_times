
import QtQuick 2.6
import Sailfish.Silica 1.0
import QtQuick.XmlListModel 2.0

Page {
    id: pagecity
    property string  latdeg;
    property string  latmin;
    property string  latsec;
    property string  latNS;
    property string  longideg;
    property string  longimin;
    property string  longisec;
    property string  longiEW;
    property string  latstringcoor;
    property string  longistringcoor;

    function covertcoordinatesCityLat(coordinatesCity) {
        latstringcoor=coordinatesCity.substring(0,coordinatesCity.indexOf(" "));

        //console.log("LAT:");
        if (latstringcoor.length===6) {
            latdeg=latstringcoor.substring(0,2);
            latmin=latstringcoor.substring(3,5);
            latNS=latstringcoor.substring(5);
            latsec=0;

            //console.log(latdeg);
            //console.log(latmin);
            //console.log(latsec);
            //console.log(latNS);
        }
        if (latstringcoor.length===9) {
            latdeg=latstringcoor.substring(0,2);
            latmin=latstringcoor.substring(3,5);
            latsec=latstringcoor.substring(6,8);
            latNS=latstringcoor.substring(8);

            //console.log(latdeg);
            //console.log(latmin);
            //console.log(latsec);
            //console.log(latNS);
        }
        if (latstringcoor.length===8) {
            latdeg=latstringcoor.substring(0,2);
            latmin=latstringcoor.substring(3,5);
            latsec=latstringcoor.substring(6,8);
            latNS="N";

            //console.log(latdeg);
            //console.log(latmin);
            //console.log(latsec);
            //console.log(latNS);
        }

        var conferLat=Math.round(latdeg)+latmin/60+latsec/3600;
        if (latNS==="S") {
            return -conferLat;
        }else{
            return conferLat;
        }

    }


    function covertcoordinatesCityLongi(coordinatesCity) {
        longistringcoor=coordinatesCity.substring(coordinatesCity.indexOf(" ")+1);

        //console.log("LONGI:");

        if (longistringcoor.length===7) {
            longideg=longistringcoor.substring(0,3);
            longimin=longistringcoor.substring(4,6);
            longiEW=longistringcoor.substring(6);
            longisec=0;

            //console.log(longideg);
            //console.log(longimin);
            //console.log(longisec);
            //console.log(longiEW);
        }
        if (longistringcoor.length===10) {
            longideg=longistringcoor.substring(0,3);
            longimin=longistringcoor.substring(4,6);
            longisec=longistringcoor.substring(7,9);
            longiEW=longistringcoor.substring(9);

            //console.log(longideg);
            //console.log(longimin);
            //console.log(longisec);
            //console.log(longiEW);
        }
        if (longistringcoor.length===9) {
            longideg=longistringcoor.substring(0,3);
            longimin=longistringcoor.substring(4,6);
            longisec=longistringcoor.substring(7,9);
            longiEW="E";

            //console.log(longideg);
            //console.log(longimin);
            //console.log(longisec);
            //console.log(longiEW);
        }

        var conferLongi=Math.round(longideg)+longimin/60+longisec/3600;
        if (longiEW==="W") {
            return -conferLongi;
        }else{
            return conferLongi;
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
            spacing: Theme.paddingLarge
            anchors.horizontalCenter: parent.horizontal
            PageHeader {
                title: qsTr("Choose City")+" --- "+indexpays
            }


            Label {
                id: text_indexcity
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                text: indexcity
                color: Theme.highlightColor
            }
            Label {
                id: text_coordinatesCity
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                text: coordinatesCity
                color: Theme.highlightColor
            }
            Button {
                width: parent.width
                id: button_coordinatesCity
                text: qsTr("Ok")
                onClicked:{
                    cityname=indexcity;
                    lat=covertcoordinatesCityLat(coordinatesCity).toFixed(4);
                    longi=covertcoordinatesCityLongi(coordinatesCity).toFixed(4);
                    pop()
                    pageStack.replace(Qt.resolvedUrl("Settings.qml"));
                }
            }

        }

        Component.onCompleted: {

        }

    }
}
