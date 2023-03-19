import QtQuick 2.6
import Sailfish.Silica 1.0
import QtQuick.XmlListModel 2.0
import QtMultimedia 5.0
import Nemo.Notifications 1.0
import Sailfish.Share 1.0
import harbour.thakir_prayer_times.calculcpp 1.0

Page {
    id: pageAya
    //    Notification {
    //        id: notivationErrorplayingQuran
    //        summary: "This Sura was not download yet!"
    //        body: "to play it, please download it befor."
    //    }
    function numArabicToHindi(num) {
        return num.replace(/0/gi, "٠").replace(/1/gi, "١").replace(/2/gi, "٢").replace(/3/gi, "٣").replace(/4/gi, "٤").replace(/5/gi, "٥").replace(/6/gi, "٦").replace(/7/gi, "٧").replace(/8/gi, "٨").replace(/9/gi, "٩").replace(/٫/gi, ".").replace("bytes/sec", "بايت/تانية").replace("kB/s", "كيلوبايت/تانية").replace("MB/s", "ميجابايت/تانية");
    }
    Notification {
        id: notifier
        expireTimeout: 4000
        function notify(data) {
            body = data
            previewBody = data
            publish()
        }
    }
    Notification {
        id: notivationErrorplayingQuran
        category: "x-nemo.example"
        appName: qsTr("Thakir Prayer Times")
        appIcon: "/usr/share/example-app/icon-l-application"
        summary: qsTr("Can't play soura! Downlod it first.")
        body: qsTr("Error")
        previewSummary: qsTr("Can't play soura! Download it first.")
        previewBody: qsTr("Click on this notification to go to the page of downloading.")
        itemCount: 1//5
        remoteActions: [ {
                "name": "default",
                "displayName": "Do something",
                "icon": "icon-s-do-it",
                "service": "org.nemomobile.example",
                "path": "/example",
                "iface": "org.nemomobile.example",
                "method": "doSomething",
                "arguments": [ "argument", 1 ]
            },{
                "name": "ignore",
                "displayName": qsTr("Ignore the problem"),
                "icon": "icon-s-ignore",
                "service": "org.nemomobile.example",
                "path": "/example",
                "iface": "org.nemomobile.example",
                "method": "ignore",
                "arguments": [ "argument", 1 ]
            } ]
        onClicked: pageStack.push(Qt.resolvedUrl("DownloadSura.qml"))////console.log("Clicked")
        //onClosed: console.log("Closed, reason: " + reason)
    }
    BusyIndicator {
        size: BusyIndicatorSize.Large
        anchors.centerIn: parent
        running: xmlModel_Quran_sura_aya_user.status == XmlListModel.Loading
    }
    Connections {
        target: calculcpp
        onSendToQmlindexplayAyaChanged: {
            if (count===0){
                ayaIndexPlaying=0
            }else{
                if (suraIndex===9 || suraIndex===1 || ayaIndexfromtoPlaying!==1){
                    ayaIndexPlaying=count+ayaIndexfromtoPlaying-1
                }else{
                    ayaIndexPlaying=count+ayaIndexfromtoPlaying-2
                }
                listViewAyat.positionViewAtIndex(ayaIndexPlaying-1, ListView.Center);
            }
            //console.log("from C++: ayaIndexPlaying= " + count)

        }
        onSendToQmlQuranIsPlaying: {
            quranIsPlaying=true
        }
        onSendToQmlQuranIsStoped: {
            quranIsPlaying=false
        }
        onSendToQmlErrorplayingQuran: {
            notivationErrorplayingQuran.publish()
        }
    }
    NumberAnimation { id: animtafssirAya; target: listViewAyat; property: "contentY"; duration: 500 }
    function gotoIndexTafssir(idx) {
        var pos = listViewAyat.contentY;
        var destPos;
        listViewAyat.positionViewAtIndex(idx, ListView.Beginning);
        // if (!gotoAyaofSura){
        destPos = listViewAyat.contentY;
        animtafssirAya.from = pos;
        animtafssirAya.to = destPos;
        animtafssirAya.running = true;
        // }
    }

    function colectsources(idx){
        // nbreayainsura=xmlModel_Quran_sura_aya.dataModel.size()
        //console.log("-------nbreayainsura="+nbreayainsura[suraIndex-1])
        var sources = new Array(nbreayainsura[suraIndex-1]+1);
        for (i=idx;i<=nbreayainsura[suraIndex-1];i++){
            ayaIndexString=i.toString()
            if (i<10) {
                ayaIndexString="00"+i.toString()
            }else if(i>=10 && i<100 ){
                ayaIndexString="0"+i.toString()
            }
            if (offlineAudio){
                sources[i-1]=ayatDownloadDir+nameKria+"/"+suraIndexString+ayaIndexString+".mp3"//for nexus4 offline
            }else{
                sources[i-1]="http://www.everyayah.com/data/"+nameKria+"/"+suraIndexString+ayaIndexString+".mp3"
            }
        }
        //sources.splice(0, 0,  "/sounds/Quran/001000.mp3");
        ////console.log("sourceslength"+sources.length)
        sourcesh=sources
        i=1
    }
    function displayQuranTafssirTranslation(){
        currentIndexAyat= listViewAyat.indexAt(0,listViewAyat.contentY);
        if (quranisShow){
            if (selectorTaffssirindex===0){
                listViewAyat.model=tafssirmuyassar;
            }else if (selectorTaffssirindex===1){
                listViewAyat.model=tafssirjalalayn;
            }else if (selectorTaffssirindex===2){
                listViewAyat.model=xmlModel_translate_Quran;
            }
            quranisShow=false;
        }else{
            listViewAyat.model=xmlModel_Quran_sura_aya_simple;
            quranisShow=true;
        }
        //console.log("currentIndexAyat:" + currentIndexAyat)
        listViewAyat.positionViewAtIndex(currentIndexAyat, ListView.Beginning);
    }
    SilicaFlickable {
        anchors.fill: parent
        PullDownMenu {
            MenuItem {
                text: quranisShow ? qsTr("Show Tafssir/Translation") : qsTr("Show Quran")
                onClicked: {
                    displayQuranTafssirTranslation()
                }
            }
        }
        XmlListModel{
            id: tafssirjalalayn
            source: "xml/ar.jalalayn.xml"
            query: "/quran/sura[@name=\'"+ suraName + "'\]/aya"
            XmlRole { name: "name"; query: "@text/string()" }
            XmlRole { name: "index"; query: "@index/string()" }
        }
        XmlListModel{
            id: tafssirmuyassar
            source: "xml/ar.muyassar.xml"
            query: "/quran/sura[@name=\'"+ suraName + "'\]/aya"
            XmlRole { name: "name"; query: "@text/string()" }
            XmlRole { name: "index"; query: "@index/string()" }
        }
        XmlListModel{
            id: xmlModel_Quran_sura_aya_simple
            source: "xml/quran-simple.xml" //	With : Include tatweel below superscript alefs (like in الرَّحْمَـٰن)
            query: "/quran/sura[@name=\'"+ suraName + "'\]/aya"

            XmlRole { name: "name"; query: "@text/string()" }
            XmlRole { name: "index"; query: "@index/string()" }
            XmlRole { name: "bismillah"; query: "@bismillah/string()" }
            onStatusChanged: {
                //
            }
        }
        XmlListModel{
            id: xmlModel_Quran_sura_aya_user
            source: customXmlPath
            query: "/quran/sura[@name=\'"+ suraName + "'\]/aya"

            XmlRole { name: "name"; query: "@text/string()" }
            XmlRole { name: "index"; query: "@index/string()" }
            XmlRole { name: "bismillah"; query: "@bismillah/string()" }
            onStatusChanged: {
                //
            }
        }
        XmlListModel{
            id: xmlModel_translate_Quran
            source: customXmlPathTranslate
            query: "/quran/sura[@name=\'"+ suraName + "'\]/aya"

            XmlRole { name: "name"; query: "string(@text)" }
            XmlRole { name: "index"; query: "string(@index)" }
            onStatusChanged: {
                //
            }
        }
        SilicaListView {
            id: listViewAyat
            height: parent.height-idFooterRow.height
            VerticalScrollDecorator {page: pageAya; flickable: listViewAyat }
            anchors.left: parent.left
            anchors.right: parent.right

            clip: true

            model: selectorxmlQuranindex===0? xmlModel_Quran_sura_aya_simple : xmlModel_Quran_sura_aya_user

            delegate: ListItem {
                id: myListViewAya
                contentHeight: idVerseTextRow.height+2*Theme.paddingLarge //espace aya-aya=2*Theme.paddingLarge
                contentWidth: parent.width
                menu: Component {
                    ContextMenu {
                        id: menue1
                        MenuItem {
                            text: qsTr("Play from this Aya")
                            onClicked:{
                                labelAya.color=Theme.errorColor
                                ayaIndexfromtoPlaying=model.index
                                loadallayatofcuncurrentSoura(ayaIndexfromtoPlaying)
                                calculcpp.playQuran()
                            }
                        }
                        MenuItem {
                            text: qsTr("Copy this Aya")
                            onClicked:{
                                Clipboard.text = model.name+" ["+suraNametext+":"+model.index+"]"
                                notifier.notify(qsTr("Aya is copied to clipboard."))
                            }
                        }
                        MenuItem {
                            text: qsTr("Share")
                            onClicked: {
                                Clipboard.text = model.name+" ["+suraNametext+":"+model.index+"]"
                                shareAction.resources = [{"data": model.name, "name": suraNametext+"-"+model.index+".txt"}]
                                shareAction.trigger()
                            }
                            ShareAction {
                                id: shareAction
                                title: qsTr("Share Aya")
                                mimeType: "text/x-url"
                            }
                        }
                    }
                }
                Row {
                    id: idVerseTextRow
                    width: parent.width - 2*Theme.horizontalPageMargin
                    anchors {
                        verticalCenter: parent.verticalCenter
                        horizontalCenter: parent.horizontalCenter
                    }
                    Text {
                        id: labelAya
                        width: parent.width
                        lineHeight: (settingsTextsize===Theme.fontSizeExtraLarge ||
                                     settingsTextsize===Theme.fontSizeLarge)? 171 : (settingsTextsize===Theme.fontSizeMedium ||
                                                                                     settingsTextsize===Theme.fontSizeSmall)? 125 : 91
                        textFormat: Text.RichText
                        lineHeightMode: Text.FixedHeight
                        text:  (lang=="2" && formatNumberHindiActiveChecked=="0")?
                                   (quranisShow? bismillah.length === 0? "(" + numArabicToHindi(index.toString()) + "): " + name :bismillah+ "<br>(" + numArabicToHindi(index.toString()) + "): " + name//
                                    : "(" + numArabicToHindi(index.toString()) + "): " + name) :
                                   (quranisShow? bismillah.length === 0? "(" + index + "): " + name :bismillah+ "<br>(" + index + "): " + name//
                                    : "(" + index + "): " + name )//"\u202C"
                        wrapMode: Text.WordWrap
                        horizontalAlignment: Text.AlignJustify
                        font.pixelSize: settingsTextsize
                        font.family: usesystemfont==="true"? Theme.fontFamily : localFont.name
                        color: index==ayaIndexPlaying ? Theme.highlightColor : Theme.primaryColor
                    }
                }

            }
        }

    }

    Rectangle {
        id: idFooterRow
        anchors.bottom: pageAya.bottom
        width: pageAya.width
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
            IconButton {
                visible: quranisShow
                width: parent.width / 6
                height: parent.height
            }
            IconButton {
                id: iconButtonplaypause
                //visible: quranisShow
                width: parent.width / 6
                height: parent.height
                icon.scale: 0.9
                icon.color: Theme.primaryColor
                icon.source: quranIsPlaying ? "image://theme/icon-m-pause?":"image://theme/icon-m-play?"
                onClicked: {
                    if (!quranIsPlaying){
                        calculcpp.playQuran()
                    }else{
                        calculcpp.pauseplayingQuran()
                    }
                }
                onPressAndHold: {
                    //
                }
            }
            Label {
                width: quranisShow ? parent.width / 3 : parent.width-iconButtonplaypause.width
                height: Theme.itemSizeSmall
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: Theme.fontSizeLarge
                color: Theme.primaryColor
                text: quranisShow ? suraNametext : selectorTaffssirindex===0? suraNametext+" "+qsTr("(Tafssir muyassar)"):
                                                                              selectorTaffssirindex===1? qsTr("Sourat: ")+suraNametext+" "+qsTr("(Tafssir jalalayn)") : qsTr("Sourat: ")+suraNametext+" "+qsTr("(Translation)")
                MouseArea {
                    //enabled: ...
                    anchors.fill: parent
                    onClicked: {
                        displayQuranTafssirTranslation()
                    }
                }
            }
            IconButton {
                visible: quranisShow
                width: parent.width / 6
                height: parent.height
                icon.scale: 0.9
                icon.color: Theme.primaryColor
                icon.source: "image://theme/icon-m-cloud-download?"
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("DownloadSura.qml"))
                }
                onPressAndHold: {
                    //
                }
            }
            IconButton {
                visible: quranisShow
                width: parent.width / 6
                height: parent.height
            }
        }
    }

    onStatusChanged: {
        //console.log("ok=PageStatus.Active changed="+status)
        if (status === PageStatus.Active) {
            viewableQuran=true
        }else{
            viewableQuran=false
            calculcpp.stopplayingQuran()
            ayaIndexPlaying=-1
        }
    }

    function loadallayatofcuncurrentSoura(idx) {
        ayaIndexfromtoPlaying=idx
        calculcpp.clearplaylist()
        colectsources(ayaIndexfromtoPlaying)
        if (suraIndex===9 || suraIndex===1 || idx!==1){
            calculcpp.addAoutho()
        }else{
            calculcpp.addAouthoBassmalla()
        }
        for (i=ayaIndexfromtoPlaying;i<=nbreayainsura[suraIndex-1];i++){
            calculcpp.addAyatoQuranplay(sourcesh[i-1].toString())
        }
        //console.log("++++++++++++++localFont.source = "+localFont.name)
    }

    Component.onCompleted: {
        viewableQuran=true
        //        if (suraIndex===9){
        //            loadallayatofcuncurrentSoura(0)
        //        }else{
        loadallayatofcuncurrentSoura(1)
        //        }

    }

}
