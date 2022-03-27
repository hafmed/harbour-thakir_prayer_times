// http://www.everyayah.com/data/Ghamadi_40kbps/ ok nexus4
// http://www.everyayah.com/data/ahmed_ibn_ali_al_ajamy_128kbps/zips/


import QtQuick 2.6
import QtMultimedia 5.0
import QtQuick.XmlListModel 2.0
import Sailfish.Silica 1.0
import harbour.thakir_prayer_times.calculcpp 1.0
import harbour.thakir_prayer_times.downloadManager 1.0


import Nemo.Notifications 1.0
import Nemo.DBus 2.0
import org.freedesktop.contextkit 1.0 //pb sf 4.3 see if resolved in 4.4

Page {
    id: pagedownloadSura
    function numArabicToHindi(num) {
        return num.toString().replace(/0/gi, "٠").replace(/1/gi, "١").replace(/2/gi, "٢").replace(/3/gi, "٣").replace(/4/gi, "٤").replace(/5/gi, "٥").replace(/6/gi, "٦").replace(/7/gi, "٧").replace(/8/gi, "٨").replace(/9/gi, "٩").replace(/٫/gi, ".").replace("bytes/sec", "بايت/تانية").replace("kB/s", "كيلوبايت/تانية").replace("MB/s", "ميجابايت/تانية");
    }
    function arabicdebit(num) {
        return num.replace("bytes/sec", "بايت/تانية").replace("kB/s", "كيلوبايت/تانية").replace("MB/s", "ميجابايت/تانية");
    }
    // bug sf 4.3 see if resolved in 4.4 //
    property string networkState: "waiting"
    //    DBusInterface {
    //        service: 'com.jolla.lipstick.ConnectionSelector'
    //        path: '/'
    //        iface: 'com.jolla.lipstick.ConnectionSelectorIf'
    //        function openConnection() {
    //            call('openConnectionNow', 'wifi')
    //        }
    //    }
    QtObject {
        id: network
        property bool isOnline: state.value === 'connected'
        property ContextProperty state

        //onIsOnlineChanged: console.log('Env.Network.isOnline:', isOnline)

        state: ContextProperty {
            id: networkOnline
            key: 'Internet.NetworkState'
            onValueChanged: {
                //console.log('Env.Network.state', value, network.isOnline)
            }
        }
    }
    Notification {
        id: notification
        itemCount: 1
        summary: "Error connection"
        body: "Please Active Connection!"
        appName: "Thakir PrayerTimes"
    }
    //-------------------------------------
    BusyIndicator {
        size: BusyIndicatorSize.Large
        anchors.centerIn: parent
        running: downloadManager.activeDownloads !== 0
    }
    SilicaFlickable {
        anchors.fill: parent
        Column{
            width: parent.width
            height: parent.height
            PageHeader {
                title:qsTr("Download Surah: ")+suraNametext
                wrapMode: Text.Wrap
            }
            Label {
                id: warnnig
                width: parent.width
                text: qsTr("Please enable connection first!")
                color: "red"
                horizontalAlignment: Text.AlignHCenter
                visible : network.isOnline==false
            }
            Button {
                id: buttondownloadsura
                width: parent.width
                text: qsTr("Click here to download the audio files")
                icon.source: network.isOnline==true? "image://theme/icon-m-cloud-download?"
                                                   : "image://theme/icon-m-warning?"
                enabled: downloadManager.activeDownloads === 0 && network.isOnline==true
                onClicked: {
                    downloadManager.m_totalCountZero();
                    var temp
                    for (var i = 1; i <= nbreayainsura[suraIndex-1]; i++) {
                        ayaIndexString=i.toString()
                        if (i<10) {
                            ayaIndexString="00"+i.toString()
                        }else if(i>=10 && i<100 ){
                            ayaIndexString="0"+i.toString()
                        }
                        temp="https://everyayah.com/data/"+nameKria+"/"+suraIndexString+ayaIndexString+".mp3"//for nexus4 on line
                        downloadManager.downloadUrl (temp);
                    }
                }
            }
            ProgressBar {
                width: parent.width
                minimumValue: 0
                maximumValue: downloadManager.progressTotal
                value: downloadManager.progressValue
                label : qsTr("Active Downloads: ") + (downloadManager.activeDownloads === 0 ? qsTr("nothing") : ((lang=="2" && formatNumberHindiActiveChecked=="0")? numArabicToHindi(downloadManager.activeDownloads) : downloadManager.activeDownloads))
                //valueText:""
                highlighted : network.isOnline
                //indeterminate : true
                enabled : network.isOnline
            }
            TextArea {
                id: textArea_speedMessage
                width: parent.width
                readOnly : true
                text: lang=="2"? (formatNumberHindiActiveChecked=="0"? numArabicToHindi(downloadManager.progressMessage): arabicdebit(downloadManager.progressMessage) ) :downloadManager.progressMessage
            }
            TextArea {
                id: textArea_statusMessage
                width: parent.width
                readOnly : true
                enabled : network.isOnline
                text:qsTr("The status: ")+ ((lang=="2" && formatNumberHindiActiveChecked=="0")?  numArabicToHindi(downloadManager.statusMessage):downloadManager.statusMessage)
            }
            TextArea {
                id: textArea_errorMessage
                width: parent.width
                readOnly : true
                enabled : network.isOnline
                text: qsTr("Errors: ")+downloadManager.errorMessage
            }
            Button {
                width: parent.width
                enabled: downloadManager.activeDownloads !== 0
                text: qsTr("Stop all downloads")
                onClicked: {
                    while (downloadManager.activeDownloads !== 0){
                        downloadManager.downloadStop();
                    }
                    downloadManager.downloadStop();
                }
            }
        }
    }
    onStatusChanged: {
        //console.log("ok=PageStatus.Active changed="+status)
        if (status !== PageStatus.Active) {
            downloadManager.m_totalCountZero();
            if  (downloadManager.activeDownloads !== 0){
                while (downloadManager.activeDownloads !== 0){
                    downloadManager.downloadStop();
                }
                downloadManager.downloadStop();
                // put here message that download has stoped! //19-2-2022
            }
        }
    }
    Component.onCompleted: {

    }
}





