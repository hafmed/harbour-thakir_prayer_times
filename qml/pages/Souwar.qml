import QtQuick 2.6
import Sailfish.Silica 1.0
import QtQuick.XmlListModel 2.0

Page {
    id: pageSura
    function numArabicToHindi(num) {
        return num.replace(/0/gi, "٠").replace(/1/gi, "١").replace(/2/gi, "٢").replace(/3/gi, "٣").replace(/4/gi, "٤").replace(/5/gi, "٥").replace(/6/gi, "٦").replace(/7/gi, "٧").replace(/8/gi, "٨").replace(/9/gi, "٩").replace(/٫/gi, ".").replace("bytes/sec", "بايت/تانية").replace("kB/s", "كيلوبايت/تانية").replace("MB/s", "ميجابايت/تانية");
    }
    BusyIndicator {
        size: BusyIndicatorSize.Large
        anchors.centerIn: parent
        running: xmlModel_Quran_sura_user.status == XmlListModel.Loading
    }
    SilicaFlickable {
        anchors.fill: parent

        XmlListModel{
            id: xmlModel_Quran_sura_simple
            source: "xml/quran-simple.xml" //	With : Include tatweel below superscript alefs (like in الرَّحْمَـٰن)
            query: "/quran/sura"
            XmlRole { name: "name"; query: "@name/string()" }
            XmlRole { name: "index"; query: "@index/number()" }
            onStatusChanged: {
                //
            }
        }
        XmlListModel{
            id: xmlModel_Quran_sura_user
            source: customXmlPath
            query: "/quran/sura"
            XmlRole { name: "name"; query: "@name/string()" }
            XmlRole { name: "index"; query: "@index/number()" }
            onStatusChanged: {
                //
            }
        }
        Rectangle {
            id: idFooterRow
            width: pageSura.width
            height:  Theme.itemSizeSmall
            color: Theme.rgba(Theme.highlightBackgroundColor, Theme.highlightBackgroundOpacity)//Theme.highlightDimmerColor
            //radius: width*0.5
            Separator {
                id: navigationRowSeparator
                width: parent.width
                color: Theme.primaryColor
                horizontalAlignment: Qt.AlignHCenter
            }
            Row {
                anchors.fill: parent
                anchors.centerIn: parent.Center
                Label {
                    width: parent.width
                    height: Theme.itemSizeSmall
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: Theme.fontSizeLarge
                    color: Theme.primaryColor
                    text: qsTr("El Souar")
                }
            }
        }

        SilicaListView {
            id: listView
            height: parent.height-idFooterRow.height
            anchors.top: idFooterRow.bottom
            VerticalScrollDecorator { flickable: listView }
            anchors.left: parent.left
            anchors.right: parent.right

            clip: true

            model: selectorxmlQuranindex===0? xmlModel_Quran_sura_simple : xmlModel_Quran_sura_user

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
                        font.pixelSize: settingsTextsize
                        font.family: usesystemfont==="true"? Theme.fontFamily : localFont.name
                        width: parent.width;
                        text:  (lang=="2" && formatNumberHindiActiveChecked=="0")? numArabicToHindi(index.toString()) + ": " + name
                                        : (lang!="2"? index + ": " + name_Sura_trans[index-1] : index + ": " + name)
                    }

                    onClicked: {
                        if (lang=="2"){
                            suraNametext=model.name
                        }else{
                            suraNametext=name_Sura_trans[index-1]
                        }
                        suraName=model.name
                        suraIndex=model.index
                        quranisShow=true

                        suraIndexString=suraIndex.toString()

                        if (suraIndex<10) {
                            suraIndexString="00"+suraIndex.toString()
                        }else if(suraIndex>=10 && suraIndex<100 ){
                            suraIndexString="0"+suraIndex.toString()
                        }
                        //console.log("suraName="+suraName+"--"+suraIndex)
                        pageStack.push(Qt.resolvedUrl("Ayat.qml"));
                        //pageStack.replace(Qt.resolvedUrl("Ayat.qml"))
                    }
                }
            }
        }
    }
    onStatusChanged: {
        viewableQuran=false
    }
    Component.onCompleted: {
        //        localFont.source = customFontPath
    }

}
