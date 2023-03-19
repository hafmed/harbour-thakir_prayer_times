
import QtQuick 2.6
import Sailfish.Silica 1.0
import harbour.thakir_prayer_times.calculcpp 1.0
import harbour.thakir_prayer_times.settings 1.0

import "sun.js" as Sun
import QtSensors 5.0 as Sensors

Page {
    id: pageCompass

    property real calibration_Compass: 0
    property int angle_Compass: 0

    property int angle_Quibla:-90
    property int angle_Sun:280
    property bool sun_is_visible: false
    property bool thile_is_visible: false

    property bool viewablePageQuibla: cover.status === Cover.Active
                                      || cover.status === Cover.Activating
                                      || applicationActive;

    onViewablePageQuiblaChanged: calculQuibla()

    Sensors.Compass {
        id: compass
        dataRate: 50
        active:true                        // amettre false si user quitte cette page
        property int old_value: 0

        onReadingChanged: {
            var new_value = -1.0 * compass.reading.azimuth
            if (Math.abs(old_value-new_value)>270){
                if (old_value > new_value){
                    new_value += 360.0
                }else{
                    new_value -= 360.0
                }
            }
            old_value = new_value
            angle_Compass = new_value

            calibration_Compass=compass.reading.calibrationLevel
        }
    }

    function calculQuibla(){
        stylecompass=settings.getValueFor("stylecompass",stylecompass)
        if (stylecompass==1){
            image_compass.source="../Images/compass_style2.png"
        }else{
            image_compass.source="../Images/compass_style3.png"
        }
        if (calculcpp.time_now_hours() > calculcpp.timesunrise_hours() && calculcpp.time_now_hours() < calculcpp.timemaghrib_hours()) {
            menuItem_Quibla.visible=true;
            sun_is_visible = true;
            thile_is_visible = true;
        } else {
            menuItem_Quibla.visible=false;
            sun_is_visible = false;
            thile_is_visible = false;
        }

        angle_Quibla=-calculcpp.qibla_HAF();
        angle_Sun=Sun.sun_azimuth(new Date(), lat, longi)
    }
    SilicaFlickable {
        anchors.fill: parent
        // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
        PullDownMenu {
            MenuItem {
                id: menuItem_Quibla
                text: !thile_is_visible? qsTr("Show direction of Shadow only") : qsTr("Show direction of Sun only")
                visible: (calculcpp.time_now_hours() > calculcpp.timesunrise_hours() && calculcpp.time_now_hours() < calculcpp.timemaghrib_hours())
                onClicked: {
                    thile_is_visible = !thile_is_visible;
                    sun_is_visible = !thile_is_visible;
                }
            }
            MenuItem {
                text: qsTr("Change the style of the Compass")
                onClicked: {
                    if (stylecompass==1){
                        image_compass.source="../Images/compass_style3.png"
                        stylecompass=2
                    }else{
                        image_compass.source="../Images/compass_style2.png"
                        stylecompass=1
                    }
                    settings.saveValueFor("stylecompass",stylecompass)
                }
            }

        }
        //contentHeight: column.height
        Column {
            anchors.fill: parent
            width: parent.width
            Label {
                id:quibla_text
                width: parent.width
                text:formatNumberHindiActiveChecked=="0"? (angle_Quibla>=0? qsTr('Quibla direction is <br>')+calculcpp.formatNumberHindi(angle_Quibla)+qsTr(" degrees east of North") : qsTr('Quibla direction is <br>')+calculcpp.formatNumberHindi(-angle_Quibla)+qsTr(" degrees west of North")):(angle_Quibla>=0? qsTr('Quibla direction is <br>')+angle_Quibla+qsTr(" degrees east of North") : qsTr('Quibla direction is <br>')+-angle_Quibla+qsTr(" degrees west of North"))
                horizontalAlignment:TextEdit.AlignHCenter
                visible: cityname!=="Mekka"
            }
            Label {
                id:quibla_calibration
                width: parent.width
                text: qsTr('Compass Sensor Calibration Level is <br>')+calibration_Compass*100+"%"
                horizontalAlignment:TextEdit.AlignHCenter
            }
            Image {
                id: imgcalibrationLevel
                source: "../Images/calibration.png"
                anchors.horizontalCenter: parent.horizontal
                visible: calibration_Compass!==1
                transform: Scale { origin.x: parent.width/2+imgcalibrationLevel.width/2; origin.y: 0; xScale: .5; yScale: .5}

            }
        }
        Flickable {
            //anchors.fill: parent
            contentHeight: parent.height
            anchors.centerIn: parent
            Column {
                anchors.fill: parent
                Rectangle {
                    id:rect
                    transform:  Rotation { origin.x: 0; origin.y: 0; angle: angle_Compass}
                    Behavior on rotation {
                        SmoothedAnimation{ velocity: -1; duration:100;maximumEasingTime: 100 }
                    }
                    Rectangle {
                        transform: Scale { origin.x: 0; origin.y: 0; xScale: parent.width/image_compass.width; yScale: parent.width/image_compass.width}

                        Image {
                            id: image_compass
                            source: "../Images/compass_style2.png"
                            anchors.centerIn: parent
                            //transform: Zoom
                        }
                        Image {
                            id: image_fleche // image 20*100 pixel
                            x: -10
                            y: -100
                            source: "../Images/hour.png"
                            visible: cityname!=="Mekka"
                            transform: Rotation { origin.x: 10; origin.y: 100.; angle: angle_Quibla}
                        }
                        Image {
                            id: image_kaaba
                            x: -17.5
                            y: -120
                            width: 35; height: 35
                            fillMode: Image.PreserveAspectFit
                            rotation: -angle_Quibla
                            source: "../Images/ox16-app-kaaba-icon.png"
                            visible: cityname!=="Mekka"
                            transform: Rotation { origin.x: 17.5; origin.y: 120.; angle: angle_Quibla}
                        }
                        Image {
                            id: image_fleche_sun // a collorer en jaune
                            x: -10
                            y: -100
                            visible: sun_is_visible
                            source: "../Images/hour.png"
                            transform: Rotation { origin.x: 10; origin.y: 100.; angle: angle_Sun}
                        }
                        Image {
                            id: image_sun
                            x: -17.5
                            y: -120
                            width: 35; height: 35
                            visible: sun_is_visible
                            fillMode: Image.PreserveAspectFit
                            rotation: -angle_Sun
                            source: "../Images/Sunny-64.png"
                            transform: Rotation { origin.x: 17.5; origin.y: 120.; angle: angle_Sun}
                        }
                        Image {
                            id: image_fleche_thile
                            x: -10
                            y: -100
                            visible: thile_is_visible
                            source: "../Images/hour.png"
                            transform: Rotation { origin.x: 10; origin.y: 100.; angle: angle_Sun+180}
                        }
                        Image {
                            id: image_thile
                            x: -17.5
                            y: -120
                            width: 35; height: 35
                            visible: thile_is_visible
                            fillMode: Image.PreserveAspectFit
                            rotation: -angle_Sun-180
                            source: "../Images/Thile-64.png"
                            transform: Rotation { origin.x: 17.5; origin.y: 120.; angle: angle_Sun+180}
                        }

                    }
                }

            }
        }
    }
    onStatusChanged: {
        //console.log("ok=PageStatus.Active changed="+status)
        if (status === PageStatus.Active) {
            compass.active=true;
            calculQuibla();
        }else{
            compass.active=false;
        }
    }
    Component.onCompleted: {
        calculQuibla();
    }

}
