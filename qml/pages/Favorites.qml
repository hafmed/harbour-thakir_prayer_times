
import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.thakir_prayer_times.calculcpp 1.0
import harbour.thakir_prayer_times.settings 1.0


Page {
    property int nbreFavoritesSavedMax: 1

    property int numeroFav
    property int nbreFavoritesSaved: 0
    property string selectedname

    function readConfigFav(numeroFav) {
        cityname=settings.getValueFor("Favorites/cityname"+numeroFav,cityname)
        longi=settings.getValueFor("Favorites/longi"+numeroFav,longi)
        lat=settings.getValueFor("Favorites/lat"+numeroFav,lat)
        tzone=settings.getValueFor("Favorites/tzone"+numeroFav,tzone)
        dst=settings.getValueFor("Favorites/dst"+numeroFav,dst)
        method=settings.getValueFor("Favorites/method"+numeroFav,method)
        exmethods=settings.getValueFor("Favorites/exmethods"+numeroFav,exmethods)

        adjust_hijri=settings.getValueFor("Favorites/adjust_hijri"+numeroFav,adjust_hijri)
        adjust_fajr=settings.getValueFor("Favorites/adjust_fajr"+numeroFav,adjust_fajr)
        adjust_dhuhr=settings.getValueFor("Favorites/adjust_dhuhr"+numeroFav,adjust_dhuhr)
        adjust_asr=settings.getValueFor("Favorites/adjust_asr"+numeroFav,adjust_asr)
        adjust_maghrib=settings.getValueFor("Favorites/adjust_maghrib"+numeroFav,adjust_maghrib)
        adjust_isha=settings.getValueFor("Favorites/adjust_isha"+numeroFav,adjust_isha)

        adhan_Fajr=settings.getValueFor('Favorites/adhan_Fajr'+numeroFav, adhan_Fajr)
        selectedFajrAdhanFileUser=settings.getValueFor('Favorites/selectedFajrAdhanFileUser'+numeroFav, selectedSound)

        stylecompass=settings.getValueFor("Favorites/stylecompass"+numeroFav,stylecompass)

        noAthanInSilentProfileChecked=settings.getValueFor("Favorites/noAthanInSilentProfileChecked"+numeroFav,noAthanInSilentProfileChecked)
        volumeAthanSlidervalue=settings.getValueFor("Favorites/volumeAthanSlidervalue"+numeroFav,volumeAthanSlidervalue)

        alerteActiveChecked=settings.getValueFor("Favorites/alerteActiveChecked"+numeroFav,alerteActiveChecked)
        minAlerteBeforeAthanvalue=settings.getValueFor("Favorites/minAlerteBeforeAthanvalue"+numeroFav,minAlerteBeforeAthanvalue)

        silenctAfterAthanActiveChecked=settings.getValueFor("Favorites/silenctAfterAthanActiveChecked"+numeroFav,silenctAfterAthanActiveChecked)
        minSilentActiveAfterAthanvalue=settings.getValueFor("Favorites/minSilentActiveAfterAthanvalue"+numeroFav,minSilentActiveAfterAthanvalue)
        minSilentActivedurationvalue=settings.getValueFor("Favorites/minSilentActivedurationvalue"+numeroFav,minSilentActivedurationvalue)

        formatNumberHindiActiveChecked=settings.getValueFor("Favorites/formatNumberHindiActiveChecked"+numeroFav,formatNumberHindiActiveChecked)

        silentDuringTarawihChecked=settings.getValueFor("Favorites/silentDuringTarawihChecked"+numeroFav,silentDuringTarawihChecked)
        minSilentDuringTarawihvalue=settings.getValueFor("Favorites/minSilentDuringTarawihvalue"+numeroFav,minSilentDuringTarawihvalue)

        silentDuringSalatJommoaaChecked=settings.getValueFor("Favorites/silentDuringSalatJommoaaChecked"+numeroFav,silentDuringSalatJommoaaChecked)
        minSilentActiveBeforAthanJommoaavalue=settings.getValueFor("Favorites/minSilentActiveBeforAthanJommoaavalue"+numeroFav,minSilentActiveBeforAthanJommoaavalue)
        minSilentActiveAfterAthanJommoaavalue=settings.getValueFor("Favorites/minSilentActiveAfterAthanJommoaavalue"+numeroFav,minSilentActiveAfterAthanJommoaavalue)

        playAthkarSabahChecked=settings.getValueFor("Favorites/playAthkarSabahChecked"+numeroFav,playAthkarSabahChecked)
        playAthkarMassaChecked=settings.getValueFor("Favorites/playAthkarMassaChecked"+numeroFav,playAthkarMassaChecked)

        minplayAthkarSabah=settings.getValueFor("Favorites/minplayAthkarSabah"+numeroFav,minplayAthkarSabah)
        minplayAthkarMassa=settings.getValueFor("Favorites/minplayAthkarMassa"+numeroFav,minplayAthkarMassa)

    }

    function readConfigOrig() {
        cityname=settings.getValueFor("cityname",cityname)
        longi=settings.getValueFor("longi",longi)
        lat=settings.getValueFor("lat",lat)
        tzone=settings.getValueFor("tzone",tzone)
        dst=settings.getValueFor("dst",dst)
        method=settings.getValueFor("method",method)
        exmethods=settings.getValueFor("exmethods",exmethods)

        adjust_hijri=settings.getValueFor("adjust_hijri",adjust_hijri)
        adjust_fajr=settings.getValueFor("adjust_fajr",adjust_fajr)
        adjust_dhuhr=settings.getValueFor("adjust_dhuhr",adjust_dhuhr)
        adjust_asr=settings.getValueFor("adjust_asr",adjust_asr)
        adjust_maghrib=settings.getValueFor("adjust_maghrib",adjust_maghrib)
        adjust_isha=settings.getValueFor("adjust_isha",adjust_isha)

        adhan_Fajr=settings.getValueFor('adhan_Fajr',adhan_Fajr)
        selectedFajrAdhanFileUser=settings.getValueFor('selectedFajrAdhanFileUser',selectedSound)

        stylecompass=settings.getValueFor("stylecompass",stylecompass)

        noAthanInSilentProfileChecked=settings.getValueFor("noAthanInSilentProfileChecked",noAthanInSilentProfileChecked)
        volumeAthanSlidervalue=settings.getValueFor("volumeAthanSlidervalue",volumeAthanSlidervalue)

        alerteActiveChecked=settings.getValueFor("alerteActiveChecked",alerteActiveChecked)
        minAlerteBeforeAthanvalue=settings.getValueFor("minAlerteBeforeAthanvalue",minAlerteBeforeAthanvalue)

        silenctAfterAthanActiveChecked=settings.getValueFor("silenctAfterAthanActiveChecked",silenctAfterAthanActiveChecked)
        minSilentActiveAfterAthanvalue=settings.getValueFor("minSilentActiveAfterAthanvalue",minSilentActiveAfterAthanvalue)
        minSilentActivedurationvalue=settings.getValueFor("minSilentActivedurationvalue",minSilentActivedurationvalue)

        formatNumberHindiActiveChecked=settings.getValueFor("formatNumberHindiActiveChecked",formatNumberHindiActiveChecked)

        silentDuringTarawihChecked=settings.getValueFor("silentDuringTarawihChecked",silentDuringTarawihChecked)
        minSilentDuringTarawihvalue=settings.getValueFor("minSilentDuringTarawihvalue",minSilentDuringTarawihvalue)

        silentDuringSalatJommoaaChecked=settings.getValueFor("silentDuringSalatJommoaaChecked",silentDuringSalatJommoaaChecked)
        minSilentActiveBeforAthanJommoaavalue=settings.getValueFor("minSilentActiveBeforAthanJommoaavalue",minSilentActiveBeforAthanJommoaavalue)
        minSilentActiveAfterAthanJommoaavalue=settings.getValueFor("minSilentActiveAfterAthanJommoaavalue",minSilentActiveAfterAthanJommoaavalue)

        playAthkarSabahChecked=settings.getValueFor("playAthkarSabahChecked",playAthkarSabahChecked)
        playAthkarMassaChecked=settings.getValueFor("playAthkarMassaChecked",playAthkarMassaChecked)

        minplayAthkarSabah=settings.getValueFor("minplayAthkarSabah",minplayAthkarSabah)
        minplayAthkarMassa=settings.getValueFor("minplayAthkarMassa",minplayAthkarMassa)

    }

    function saveSettingsFav(numeroFav) {
        settings.saveValueFor("Favorites/cityname"+numeroFav,cityname)
        settings.saveValueFor("Favorites/longi"+numeroFav,longi)
        settings.saveValueFor("Favorites/lat"+numeroFav,lat)
        settings.saveValueFor("Favorites/tzone"+numeroFav,tzone)
        settings.saveValueFor("Favorites/dst"+numeroFav,dst)
        settings.saveValueFor("Favorites/method"+numeroFav,method)
        settings.saveValueFor("Favorites/exmethods"+numeroFav,exmethods)

        settings.saveValueFor("Favorites/adjust_hijri"+numeroFav,adjust_hijri)
        settings.saveValueFor("Favorites/adjust_fajr"+numeroFav,adjust_fajr)
        settings.saveValueFor("Favorites/adjust_dhuhr"+numeroFav,adjust_dhuhr)
        settings.saveValueFor("Favorites/adjust_asr"+numeroFav,adjust_asr)
        settings.saveValueFor("Favorites/adjust_maghrib"+numeroFav,adjust_maghrib)
        settings.saveValueFor("Favorites/adjust_isha"+numeroFav,adjust_isha)

        settings.saveValueFor('Favorites/adhan_Fajr'+numeroFav, adhan_Fajr)
        settings.saveValueFor('Favorites/selectedFajrAdhanFileUser'+numeroFav, selectedFajrAdhanFileUser)

        settings.saveValueFor("Favorites/stylecompass"+numeroFav,stylecompass)

        settings.saveValueFor("Favorites/noAthanInSilentProfileChecked"+numeroFav,noAthanInSilentProfileChecked)
        settings.saveValueFor("Favorites/volumeAthanSlidervalue"+numeroFav,volumeAthanSlidervalue)

        settings.saveValueFor("Favorites/alerteActiveChecked"+numeroFav,alerteActiveChecked)
        settings.saveValueFor("Favorites/minAlerteBeforeAthanvalue"+numeroFav,minAlerteBeforeAthanvalue)

        settings.saveValueFor("Favorites/silenctAfterAthanActiveChecked"+numeroFav,silenctAfterAthanActiveChecked)
        settings.saveValueFor("Favorites/minSilentActiveAfterAthanvalue"+numeroFav,minSilentActiveAfterAthanvalue)
        settings.saveValueFor("Favorites/minSilentActivedurationvalue"+numeroFav,minSilentActivedurationvalue)

        settings.saveValueFor("Favorites/formatNumberHindiActiveChecked"+numeroFav,formatNumberHindiActiveChecked)

        settings.saveValueFor("Favorites/silentDuringTarawihChecked"+numeroFav,silentDuringTarawihChecked)
        settings.saveValueFor("Favorites/minSilentDuringTarawihvalue"+numeroFav,minSilentDuringTarawihvalue)

        settings.saveValueFor("Favorites/silentDuringSalatJommoaaChecked"+numeroFav,silentDuringSalatJommoaaChecked)
        settings.saveValueFor("Favorites/minSilentActiveBeforAthanJommoaavalue"+numeroFav,minSilentActiveBeforAthanJommoaavalue)
        settings.saveValueFor("Favorites/minSilentActiveAfterAthanJommoaavalue"+numeroFav,minSilentActiveAfterAthanJommoaavalue)

        settings.saveValueFor("Favorites/playAthkarSabahChecked"+numeroFav,playAthkarSabahChecked)
        settings.saveValueFor("Favorites/playAthkarMassaChecked"+numeroFav,playAthkarMassaChecked)

        settings.saveValueFor("Favorites/minplayAthkarSabah"+numeroFav,minplayAthkarSabah)
        settings.saveValueFor("Favorites/minplayAthkarMassa"+numeroFav,minplayAthkarMassa)

    }

    function saveDefaultSettings() {
        settings.saveValueFor("cityname","Mekka")
        settings.saveValueFor("longi","39.823333")
        settings.saveValueFor("lat","21.423333")
        settings.saveValueFor("tzone","+3")
        settings.saveValueFor("dst",'0')
        settings.saveValueFor("method","5")
        settings.saveValueFor("exmethods","0")

        settings.saveValueFor("adjust_hijri","0")
        settings.saveValueFor("adjust_fajr","1")
        settings.saveValueFor("adjust_dhuhr","1")
        settings.saveValueFor("adjust_asr","1")
        settings.saveValueFor("adjust_maghrib","1")
        settings.saveValueFor("adjust_isha","1")

        settings.saveValueFor('adhan_Fajr',"0")
        settings.saveValueFor('selectedFajrAdhanFileUser',selectedSound)

        settings.saveValueFor("stylecompass","2")

        settings.saveValueFor("noAthanInSilentProfileChecked","0")
        settings.saveValueFor("volumeAthanSlidervalue","75")

        settings.saveValueFor("alerteActiveChecked","0")
        settings.saveValueFor("minAlerteBeforeAthanvalue","10")

        settings.saveValueFor("silenctAfterAthanActiveChecked","0")
        settings.saveValueFor("minSilentActiveAfterAthanvalue","10")
        settings.saveValueFor("minSilentActivedurationvalue","10")

        settings.saveValueFor("formatNumberHindiActiveChecked","1")

        settings.saveValueFor("silentDuringTarawihChecked","0")
        settings.saveValueFor("minSilentDuringTarawihvalue","57")

        settings.saveValueFor("silentDuringSalatJommoaaChecked","0")
        settings.saveValueFor("minSilentActiveBeforAthanJommoaavalue","30")
        settings.saveValueFor("minSilentActiveAfterAthanJommoaavalue","35")

        settings.saveValueFor("playAthkarSabahChecked","0")
        settings.saveValueFor("playAthkarMassaChecked","0")

        settings.saveValueFor("minplayAthkarSabah","10")
        settings.saveValueFor("minplayAthkarMassa","5")



    }

    ListModel {
        id: modelFav
    }
    SilicaFlickable {
        anchors.fill: parent
        SilicaListView {
            id: view
            anchors.fill: parent
            model: modelFav
            clip: true

            header: PageHeader {
                title: qsTr("List of Favorites")
                description : modelFav.count!==0 ? qsTr("Press-and-hold on favorite") : ""
            }

            ViewPlaceholder {
                enabled: view.count == 0
                text: qsTr("You haven't saved any configuration to favorites!")
                hintText:  qsTr("Pull down to add favorites")
            }

            PullDownMenu {
                MenuItem {
                    id: menuItem_Load_default_config
                    text: qsTr("Load default configuration")
                    onClicked: {
                        saveDefaultSettings();
                        readConfigOrig();
                        pop();
                    }
                }
                MenuItem {
                    id: menuItem_ClearAll
                    text: qsTr("Delete all Favorites")
                    visible: modelFav.count!==0
                    onClicked: {
                        //settings.clearAll();
                        settings.romoveValueFor("Favorites");
                        view.model.clear();
                    }
                }
                MenuItem {
                    id: menuItem_Fav
                    text: qsTr("Save current configuration in a favorite")
                    onClicked: {
                        nbreFavoritesSavedMax=0
                        for (var a = 1; a <= modelFav.count; a++) {
                            var num;
                            if (view.model.get(a-1).name.charAt(10)!==":"){
                                num = view.model.get(a-1).name.substring(9,11)
                            }else{
                                num = view.model.get(a-1).name.substring(9,10)
                            }
                            if (num  > nbreFavoritesSavedMax) nbreFavoritesSavedMax=num
                            console.log("num="+num)
                        }
                        console.log("nbreFavoritesSavedMax="+nbreFavoritesSavedMax)
                        nbreFavoritesSaved=Math.round(settings.getValueFor("Favorites/nbreFavoritesSaved",nbreFavoritesSaved))
                        nbreFavoritesSaved=nbreFavoritesSaved+1;

                        nbreFavoritesSavedMax=nbreFavoritesSavedMax+1;
                        saveSettingsFav(nbreFavoritesSavedMax);

                        modelFav.append({"name":"Favorite_"+nbreFavoritesSavedMax+":"+cityname});
                        settings.saveValueFor("Favorites/Favorite_"+nbreFavoritesSavedMax,"Favorite_"+nbreFavoritesSavedMax+":"+cityname)

                        settings.saveValueFor("Favorites/nbreFavoritesSaved",nbreFavoritesSavedMax);
                    }
                }
            }
            VerticalScrollDecorator {}

            delegate: ListItem {
                id: favoritesItem
                menu: contextMenu
                width: ListView.view.width
                contentHeight: listLabel.height+30

                onClicked: console.log("Clicked " + view.model.get(index).name)
                onPressed: selectedname=view.model.get(index).name

                Label {
                    id: listLabel
                    text: name
                    anchors.centerIn: parent
                    color: highlighted ? Theme.highlightColor : Theme.primaryColor
                }

                function deleteFav() {
                    remorseAction(qsTr("Favorite is deleting"), function() {
                        view.model.remove(index);
                        var v=modelFav.count-index+2
                        //-
                        var num;
                        if (selectedname.charAt(10)!==":"){
                            num = selectedname.substring(9,11)
                        }else{
                            num = selectedname.substring(9,10)
                        }
                        settings.saveValueFor("Favorites/Favorite_"+num,"")
                        settings.romoveValueFor("Favorites/Favorite_"+num)
                        settings.saveValueFor("Favorites/nbreFavoritesSaved",modelFav.count)
                        for (var a = 1; a <= modelFav.count; a++) {
                            settings.saveValueFor("Favorites/Favorite_"+a,view.model.get(a-1).name)
                        }
                        //-
                    })
                }

                Component {
                     id: contextMenu
                     ContextMenu {
                         MenuItem {
                             text: qsTr("Load this favorite")
                             onClicked: {
                                 var num;
                                 if (selectedname.charAt(10)!=":"){
                                     num = selectedname.substring(9,11)
                                 }else{
                                     num = selectedname.substring(9,10)
                                 }
                                 readConfigFav(num);
                                 pop();
                             }
                         }
//                         MenuItem {
//                             text: qsTr("Rename this favorite")
//                             onClicked: engine.copyFiles([ fileModel.fileNameAt(index) ]);
//                         }
                         MenuItem {
                             text: qsTr("Delete this favorite")
                             onClicked:  {
                                favoritesItem.deleteFav();
                             }
                         }
                     }
                 }
            }

            Component.onCompleted: {
                var a;
                modelFav.clear();
                nbreFavoritesSaved=Math.round(settings.getValueFor("Favorites/nbreFavoritesSaved",nbreFavoritesSaved))
                console.log("nbreFavoritesSaved= " + nbreFavoritesSaved)
                for (a = 1; a <= nbreFavoritesSaved; a++) {
                     var tempNew;
                    if (a!=1){
                        var t=a-1
                        tempNew=settings.getValueFor("Favorites/Favorite_"+a,"")
                        var tempOld=settings.getValueFor("Favorites/Favorite_"+t,"")
                        var temp1;
                        var temp2;
                        if (tempNew.charAt(10)!==":"){
                            temp1 = tempNew.substring(9,11)
                        }else{
                            temp1 = tempNew.substring(9,10)
                        }
                        if (tempOld.charAt(10)!==":"){
                            temp2 = tempOld.substring(9,11)
                        }else{
                            temp2 = tempOld.substring(9,10)
                        }
                        if (temp1!==temp2 && tempNew!=="") modelFav.append({"name":settings.getValueFor("Favorites/Favorite_"+a,"")});
                    }else{
                        tempNew=settings.getValueFor("Favorites/Favorite_"+a,"")
                        if (tempNew!=="") modelFav.append({"name":settings.getValueFor("Favorites/Favorite_"+a,"")});
                    }
                }

                //----HAF 5-1-2016--------------------------------------------
                 for (a = nbreFavoritesSaved+1; a <= 100; a++) {
                     settings.romoveValueFor("Favorites/Favorite_"+a)
                 }
                //------------------------------------------------------------
            }
        }
    }
}
