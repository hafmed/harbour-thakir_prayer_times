
import QtQuick 2.6
import Sailfish.Silica 1.0
import "../pages"

CoverBackground {
//    signal pause();
//    signal mute();
//    signal start();
//    signal reset();
//    property bool viewablecover: cover.status === Cover.Active

//    onViewablecoverChanged: {
//        if (viewable==true ) {
//            reset();
//            seconds= calculcpp.remaining_time_haf_Sec();
//            minutes=0;
//            //console.log("seconds: " + calculcpp.remaining_time_haf_Sec())
//            temp1.text="sec:" + calculcpp.remaining_time_haf_Sec();
//            temp2.text="insomniacRun="+insomniac.running
//            start();
//        }
//    }
 Column {
     id: column
     spacing: uiArabic ? Theme.paddingSmall : Theme.paddingMedium
    // anchors.centerIn: parent
     width: parent.width
     height: parent.height-enableAthan.height-enableAthanicon.height
     anchors.bottom: top.enableAthan
     anchors.top: top.parent
    Label {
        id: label
        width: parent.width
        horizontalAlignment: Text.AlignHCenter
        text: cityname
        wrapMode: Text.Wrap
        truncationMode: TruncationMode.Fade
    }

    Label {
        id: labe_time_now
        width: parent.width
        horizontalAlignment: Text.AlignHCenter
        //text: time_now
        text:  lang=="2"? (formatNumberHindiActiveChecked=="0"? time_now_Arab_NbreHindi: time_now_Arab ) :time_now
        font.pixelSize: Theme.fontSizeExtraSmall
    }

    Label {
        id: labe_time_hijri
        width: parent.width
        horizontalAlignment: Text.AlignHCenter
        //text: time_hijri
        text: lang=="2"? (formatNumberHindiActiveChecked=="0"? time_hijri_Arab_NbreHindi: time_hijri_Arab ):time_hijri
        font.pixelSize: Theme.fontSizeExtraSmall
    }

    Label {
        id: labe_next_salat_text
        width: parent.width
        horizontalAlignment: Text.AlignHCenter
        text: qsTr("Remaining time until: ")
        font.pixelSize: Theme.fontSizeExtraSmall
    }

    Label {
        id: labe_next_salat
        width: parent.width
        horizontalAlignment: Text.AlignHCenter
        text: next_salat
        font.pixelSize: Theme.fontSizeExtraSmall
        color: Theme.highlightColor
    }

    Label {
        id: labe_remaining_time
        width: parent.width
        horizontalAlignment: Text.AlignHCenter
        text: remaining_time
        font.pixelSize: Theme.fontSizeLarge //Theme.fontSizeMedium //Theme.fontSizeSmall
        color: Theme.highlightColor //Theme.secondaryHighlightColor
    }

    Label {
        id: labe_AthanActived
        width: parent.width
        horizontalAlignment: Text.AlignHCenter
        text: adhan_Fajr===0 ? qsTr("Adhan is not actived") : qsTr("Adhan is actived")
        font.pixelSize: Theme.fontSizeSmall //Theme.fontSizeMedium //Theme.fontSizeSmall
        color: Theme.highlightColor //Theme.secondaryHighlightColor
    }

}


    function updateTime() {
//        if (timeFormatConfig.value === "24") {
//            time_now = Qt.formatDateTime(new Date(), "dd-MM-yy  hh:mm");
//            timeformat="24";
//        } else {
//            time_now = Qt.formatDateTime(new Date(), "dd-MM-yy  hh:mm ap");
//            timeformat="12";
//        }


        if (timeFormatConfig.value === "24") {
            time_now =Qt.formatDate(new Date())+ Qt.formatDateTime(new Date(), " hh:mm");
            timeformat="24";
        } else {
            time_now = Qt.formatDate(new Date())+Qt.formatDateTime(new Date(), " hh:mm ap");
            timeformat="12";
        }


        time_hijri = calculcpp.getoutputtexhigri(adjust_hijri)
        next_salat=calculcpp.next_salat_haf()
        //remaining_time=calculcpp.remaining_time_haf()

        labe_next_salat_text.text=qsTr("Remaining time until: ")

        if ( adhan_Fajr===0 ){
            labe_AthanActived.text=qsTr("Adhan is not actived")
        }else{
            labe_AthanActived.text=qsTr("Adhan is actived")
        }

    }



    CoverActionList {
        id: enableAthan

        CoverAction {
            id:enableAthanicon
            iconSource: adhan_Fajr===0 ? "image://theme/icon-m-speaker":"image://theme/icon-m-speaker-mute"
            onTriggered:{
                if (athan_Fajr_Old==0) athan_Fajr_Old=1;
                if  (adhan_Fajr===0){
                    adhan_Fajr=athan_Fajr_Old;
                }else{
                    athan_Fajr_Old=adhan_Fajr;
                    adhan_Fajr=0;
                }
                updateTime();
                settings.saveValueFor("adhan_Fajr",adhan_Fajr)
            }
        }
    }


}


