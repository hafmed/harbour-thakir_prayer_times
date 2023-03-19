// www.transifex.com/hafsoftdz/thakir-prayer-times.
// to use: import QtSensors 5.0
// in terminal ubuntu desktop:
// ssh -p 2223 -i ~/SailfishOS/vmshare/ssh/private_keys/SailfishOS_Emulator/root root@localhost
//  pkcon install qt5-qtdeclarative-import-sensors
// see : http://flyingsheeponsailfish.blogspot.ch/2013/11/deploying-additional-packages-to.html
// and https://lists.sailfishos.org/pipermail/devel/2014-January/002801.html
//-----------------------------------------
/*
Ver 1.0:

    Initial release.

Ver 1.5:

    Add Adhan (Click on remaining time button to stop Adhan);
    GPS;
    French translation.
*/
//-----------------------------------------
import QtQuick 2.6
//--for Quran-----
import QtQuick.XmlListModel 2.0
//----------------
import QtMultimedia 5.0
import Sailfish.Silica 1.0
import "pages"
import "cover"
import harbour.thakir_prayer_times.calculcpp 1.0
import harbour.thakir_prayer_times.settings 1.0
import harbour.thakir_prayer_times.downloadManager 1.0

import QtQuick.LocalStorage 2.0 // DB reading and writing

//import org.nemomobile.dbus 2.0
//import org.nemomobile.configuration 1.0 //deprecated
import Nemo.Configuration 1.0

//import harbour.thakir_prayer_times.insomniac 1.0

import Nemo.KeepAlive 1.2    //17-09-2019  de 1.1 to 1.2

//import harbour.thakir_prayer_times.uiconnection 1.0


ApplicationWindow
{
    id: app;
    property bool reloadDBSettings : false
    Item {
        id: storageItem

        function getDatabase() {
            return storageItem.LocalStorage.openDatabaseSync("Quran", "0.1", "Thakir_prayer_times_Sailfish", 5000000); // 5 MB estimated size
        }

        function setSettings( setting, value ) {
            var db = getDatabase();
            var res = "";
            db.transaction(function(tx) {
                tx.executeSql('CREATE TABLE IF NOT EXISTS ' + 'settings_table' + '(setting TEXT UNIQUE, value TEXT)');
                var rs = tx.executeSql('INSERT OR REPLACE INTO ' + 'settings_table' + ' VALUES (?,?);', [setting,value]);
                if (rs.rowsAffected > 0) {
                    res = "OK";
                } else {
                    res = "Error";
                }
            }
            );
            return res;
        }

        function getSettings( setting, default_value ) {
            var db = getDatabase();
            var res="";
            try {
                db.transaction(function(tx) {
                    var rs = tx.executeSql('SELECT value FROM '+ 'settings_table' +' WHERE setting=?;', [setting]);
                    if (rs.rows.length > 0) {
                        res = rs.rows.item(0).value;
                    } else {
                        res = default_value;
                    }
                    if (res === null) {
                        res = default_value
                    }
                })
            } catch (err) {
                ////console.log("Database " + err);
                res = default_value;
            };
            ////console.log(setting + " = " + res)
            return res
        }

        function setInfos( categ_info, translat1_info, translat2_info ) {
            var db = getDatabase();
            var res = "";
            db.transaction(function(tx) {
                tx.executeSql('CREATE TABLE IF NOT EXISTS ' + 'info_table' + '(category_info TEXT UNIQUE, translation1_info TEXT, translation2_info TEXT)');
                var rs = tx.executeSql('INSERT OR REPLACE INTO ' + 'info_table' + ' VALUES (?,?,?);', [categ_info,translat1_info,translat2_info]);
                if (rs.rowsAffected > 0) {
                    res = "OK";
                } else {
                    res = "Error";
                }
            }
            );
            return res;
        }

        function setNote( note_id, bookNumber, bookNameLong, bookNameShort, chapterNumber, verseNumber, verse, noteText ) {
            var db = getDatabase();
            var res = "";
            db.transaction(function(tx) {
                tx.executeSql('CREATE TABLE IF NOT EXISTS ' + 'notes' + '(note_id INTEGER, bookNumber INTEGER, bookNameLong TEXT, bookNameShort TEXT, chapterNumber INTEGER, verseNumber INTEGER, verse TEXT, noteText TEXT)');
                var rs = tx.executeSql('INSERT OR REPLACE INTO ' + 'notes' + ' VALUES (?,?,?,?,?,?,?,?);', [ note_id, bookNumber, bookNameLong, bookNameShort, chapterNumber, verseNumber, verse, noteText ]);
                if (rs.rowsAffected > 0) {
                    res = "OK";
                } else {
                    res = "Error";
                }
            }
            );
            return res;
        }

        function getNote( note_id, default_value ) {
            var db = getDatabase();
            var res=[];
            try {
                db.transaction(function(tx) {
                    //var rs = tx.executeSql('SELECT note_id,bookNumber,bookNameLong,bookNameShort,chapterNumber,verseNumber,verse,noteText FROM '+ 'notes' +' WHERE note_id=?;', [note_id]);
                    var rs = tx.executeSql('SELECT * FROM '+ 'notes' +' WHERE note_id=?;', [note_id]);
                    if (rs.rows.length > 0) {
                        for (var i = 0; i < rs.rows.length; i++) {
                            res.push(rs.rows.item(i).note_id)
                            res.push(rs.rows.item(i).bookNumber)
                            res.push(rs.rows.item(i).bookNameLong)
                            res.push(rs.rows.item(i).bookNameShort)
                            res.push(rs.rows.item(i).chapterNumber)
                            res.push(rs.rows.item(i).verseNumber)
                            res.push(rs.rows.item(i).verse)
                            res.push(rs.rows.item(i).noteText)
                        }
                    } else {
                        res = default_value;
                    }
                })
            } catch (err) {
                ////console.log("Database " + err);
                res = default_value;
            };
            return res
        }

        function updateNote ( bookNumber, chapterNumber, verseNumber, noteText ) {
            var db = getDatabase();
            var res = "";
            db.transaction(function(tx) {
                tx.executeSql('CREATE TABLE IF NOT EXISTS ' + 'notes' + '(note_id INTEGER, bookNumber INTEGER, bookNameLong TEXT, bookNameShort TEXT, chapterNumber INTEGER, verseNumber INTEGER, verse TEXT, noteText TEXT)');
                var rs = tx.executeSql('UPDATE notes SET noteText="' + noteText + '" WHERE bookNumber=' + bookNumber + ' AND chapterNumber=' + chapterNumber + ' AND verseNumber=' + verseNumber + ';');
                if (rs.rowsAffected > 0) {
                    res = "OK";
                } else {
                    res = "Error";
                }
            }
            );
            return res;
        }

        function setBookmark( bookmark_id, bookNumber, bookNameLong, bookNameShort, chapterNumber, verseNumber, verse ) {
            var db = getDatabase();
            var res = "";
            db.transaction(function(tx) {
                tx.executeSql('CREATE TABLE IF NOT EXISTS ' + 'bookmarks' + '(bookmark_id INTEGER, bookNumber INTEGER, bookNameLong TEXT, bookNameShort TEXT, chapterNumber INTEGER, verseNumber INTEGER, verse TEXT)');
                var rs = tx.executeSql('INSERT OR REPLACE INTO ' + 'bookmarks' + ' VALUES (?,?,?,?,?,?,?);', [ bookmark_id, bookNumber, bookNameLong, bookNameShort, chapterNumber, verseNumber, verse ]);
                if (rs.rowsAffected > 0) {
                    res = "OK";
                } else {
                    res = "Error";
                }
            }
            );
            return res;
        }

        function getBookmark( bookmark_id, default_value ) {
            var db = getDatabase();
            var res=[];
            try {
                db.transaction(function(tx) {
                    //var rs = tx.executeSql('SELECT bookmark_id,bookNumber,bookNameLong,bookNameShort,chapterNumber,verseNumber,verse FROM '+ 'bookmarks' +' WHERE bookmark_id=?;', [bookmark_id]);
                    var rs = tx.executeSql('SELECT * FROM '+ 'bookmarks' +' WHERE bookmark_id=?;', [bookmark_id]);
                    if (rs.rows.length > 0) {
                        for (var i = 0; i < rs.rows.length; i++) {
                            res.push(rs.rows.item(i).bookmark_id)
                            res.push(rs.rows.item(i).bookNumber)
                            res.push(rs.rows.item(i).bookNameLong)
                            res.push(rs.rows.item(i).bookNameShort)
                            res.push(rs.rows.item(i).chapterNumber)
                            res.push(rs.rows.item(i).verseNumber)
                            res.push(rs.rows.item(i).verse)
                        }
                    } else {
                        res = default_value;
                    }
                })
            } catch (err) {
                ////console.log("Database " + err);
                res = default_value;
            };
            return res
        }

        function getAllBookmarks( default_value, orderType ) {
            var db = getDatabase();
            var res=[];
            try {
                db.transaction(function(tx) {
                    if (orderType === "orderBible") {
                        var rs = tx.executeSql('SELECT * FROM '+ 'bookmarks ORDER BY bookNumber, chapterNumber, verseNumber;')
                    } else {
                        rs = tx.executeSql('SELECT * FROM '+ 'bookmarks;')
                    }
                    if (rs.rows.length > 0) {
                        for (var i = 0; i < rs.rows.length; i++) {
                            res.push([rs.rows.item(i).bookmark_id,
                                      rs.rows.item(i).bookNumber,
                                      rs.rows.item(i).bookNameLong,
                                      rs.rows.item(i).bookNameShort,
                                      rs.rows.item(i).chapterNumber,
                                      rs.rows.item(i).verseNumber,
                                      rs.rows.item(i).verse])
                        }
                    } else {
                        res = default_value;
                    }
                })
            } catch (err) {
                ////console.log("Database " + err);
                res = default_value;
            };
            return res
        }

        function getInfos( categ_info, column_info, default_value ) {
            var db = getDatabase();
            var res="";
            try {
                db.transaction(function(tx) {
                    var rs = tx.executeSql('SELECT ' + column_info + ' AS some_info FROM '+ 'info_table' +' WHERE category_info=?;', [categ_info]);
                    if (rs.rows.length > 0) {
                        res = rs.rows.item(0).some_info;

                    } else {
                        res = default_value;
                    }
                })
            } catch (err) {
                ////console.log("Database " + err);
                res = default_value;
            };
            return res
        }

        // more general functions
        function removeFullTable (tableName) {
            var db = getDatabase();
            var res = "";
            db.transaction(function(tx) { tx.executeSql('DROP TABLE IF EXISTS ' + tableName) });
        }

        function getTableCount (tableName, default_value) {
            var db = getDatabase();
            var res="";
            try {
                db.transaction(function(tx) {
                    var rs = tx.executeSql('SELECT count(*) AS some_info FROM ' + tableName + ';');
                    if (rs.rows.length > 0) {
                        res = rs.rows.item(0).some_info;

                    } else {
                        res = default_value;
                    }
                })
            } catch (err) {
                ////console.log("Database " + err);
                res = default_value;
            };
            return res
        }
    }
    KeepAlive {
        id: keepAlive
        enabled: true
    }

    Timer {
        id: timercalcul
        interval: 10000 // every 15 secs update for now
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            calcul()
        }
        running: viewable
    }

    //    DBusInterface {
    //        id: profiled
    //        service: 'com.nokia.profiled'
    //        iface: 'com.nokia.profiled'
    //        path: '/com/nokia/profiled'

    //        function send()
    //        {
    //            profiled.typedCall('get_profile', [], function (result) {
    //                // This will be called when the result is available
    //                profileActive=result;
    //                //console.log('Got profile: ' + profileActive);
    //            });
    //        }
    //    }

    //-----15-02-2022-Quran------------------
    property string bismillah:""
    property int i:0
    property variant  sourcesh : Array()
    property string suraName
    property string suraNametext
    property int suraIndex
    property int ayaIndexPlaying
    property int ayaIndexfromtoPlaying
    property bool quranisShow: true
    property int currentIndexAyat
    property var nbreayainsura : [7,
        286,
        200,
        176,
        120,
        165,
        206,
        75,
        129,
        109,
        123,
        111,
        43,
        52,
        99,
        128,
        111,
        110,
        98,
        135,
        112,
        78,
        118,
        64,
        77,
        227,
        93,
        88,
        69,
        60,
        34,
        30,
        73,
        54,
        45,
        83,
        182,
        88,
        75,
        85,
        54,
        53,
        89,
        59,
        37,
        35,
        38,
        29,
        18,
        45,
        60,
        49,
        62,
        55,
        78,
        96,
        29,
        22,
        24,
        13,
        14,
        11,
        11,
        18,
        12,
        12,
        30,
        52,
        52,
        44,
        28,
        28,
        20,
        56,
        40,
        31,
        50,
        40,
        46,
        42,
        29,
        19,
        36,
        25,
        22,
        17,
        19,
        26,
        30,
        20,
        15,
        21,
        11,
        8,
        8,
        19,
        5,
        8,
        8,
        11,
        11,
        8,
        3,
        9,
        5,
        4,
        7,
        3,
        6,
        3,
        5,
        4,
        5,
        6]

    property variant name_Sura_trans:["Al-Faatiha",
    "Al-Baqara",
    "Aal-i-Imraan",
    "An-Nisaa",
    "Al-Maaida",
    "Al-An'aam",
    "Al-A'raaf",
    "Al-Anfaal",
    "At-Tawba",
    "Yunus",
    "Hud",
    "Yusuf",
    "Ar-Ra'd",
    "Ibrahim",
    "Al-Hijr",
    "An-Nahl",
    "Al-Israa",
    "Al-Kahf",
    "Maryam",
    "Taa-Haa",
    "Al-Anbiyaa",
    "Al-Hajj",
    "Al-Muminoon",
    "An-Noor",
    "Al-Furqaan",
    "Ash-Shu'araa",
    "An-Naml",
    "Al-Qasas",
    "Al-Ankaboot",
    "Ar-Room",
    "Luqman",
    "As-Sajda",
    "Al-Ahzaab",
    "Saba",
    "Faatir",
    "Yaseen",
    "As-Saaffaat",
    "Saad",
    "Az-Zumar",
    "Al-Ghaafir",
    "Fussilat",
    "Ash-Shura",
    "Az-Zukhruf",
    "Ad-Dukhaan",
    "Al-Jaathiya",
    "Al-Ahqaf",
    "Muhammad",
    "Al-Fath",
    "Al-Hujuraat",
    "Qaaf",
    "Adh-Dhaariyat",
    "At-Tur",
    "An-Najm",
    "Al-Qamar",
    "Ar-Rahmaan",
    "Al-Waaqia",
    "Al-Hadid",
    "Al-Mujaadila",
    "Al-Hashr",
    "Al-Mumtahana",
    "As-Saff",
    "Al-Jumu'a",
    "Al-Munaafiqoon",
    "At-Taghaabun",
    "At-Talaaq",
    "At-Tahrim",
    "Al-Mulk",
    "Al-Qalam",
    "Al-Haaqqa",
    "Al-Ma'aarij",
    "Nooh",
    "Al-Jinn",
    "Al-Muzzammil",
    "Al-Muddaththir",
    "Al-Qiyaama",
    "Al-Insaan",
    "Al-Mursalaat",
    "An-Naba",
    "An-Naazi'aat",
    "Abasa",
    "At-Takwir",
    "Al-Infitaar",
    "Al-Mutaffifin",
    "Al-Inshiqaaq",
    "Al-Burooj",
    "At-Taariq",
    "Al-A'laa",
    "Al-Ghaashiya",
    "Al-Fajr",
    "Al-Balad",
    "Ash-Shams",
    "Al-Lail",
    "Ad-Dhuhaa",
    "Ash-Sharh",
    "At-Tin",
    "Al-Alaq",
    "Al-Qadr",
    "Al-Bayyina",
    "Az-Zalzala",
    "Al-Aadiyaat",
    "Al-Qaari'a",
    "At-Takaathur",
    "Al-Asr",
    "Al-Humaza",
    "Al-Fil",
    "Quraish",
    "Al-Maa'un",
    "Al-Kawthar",
    "Al-Kaafiroon",
    "An-Nasr",
    "Al-Masad",
    "Al-Ikhlaas",
    "Al-Falaq",
    "An-Naas"]
    property string ayaIndexString
    property string suraIndexString
    property string nameKria : storageItem.getSettings("nameKria", "Ghamadi_40kbps")
    property string ayatDownloadDir : "/Downloads/Thakir_Quran/"
    property bool offlineAudio : true
    property bool quranIsPlaying
    property string usesystemfont: storageItem.getSettings("usesystemfont", "false")
    // 0=system blanking ON | 1=blanking disabled OFF
    property int displayPreventBlanking : parseInt(storageItem.getSettings( 'screenBlanking', 1 )) // 1=true, 0=false
    property int selectorxmlQuranindex : parseInt(storageItem.getSettings( 'indexselectorxmlQuran', 0 ))
    property int selectorTaffssirindex : parseInt(storageItem.getSettings( 'indexselectorTaffssir', 0 ))
    property int settingsTextsize : storageItem.getSettings("fontsize", Theme.fontSizeMedium)

    property string emptyLoadTitle : "[Load]"
    property int currentFontIndex : Number(storageItem.getSettings("indexSelectorFont", 0))
    property string customFontPath : storageItem.getSettings('fontPath', "" ) //"fonts/ScheherazadeNew-Regular.ttf"
    property string customFontName : storageItem.getSettings('fontName', emptyLoadTitle )
    property string tempFontPath : customFontPath
    property string tempFontName : customFontName

    property int currentXmlIndexQuran : Number(storageItem.getSettings("indexselectorxmlQuran", 0))
    property string customXmlPath : storageItem.getSettings('xmlPath', "" )
    property string customXmlName : storageItem.getSettings('xmlName', emptyLoadTitle )
    property string tempXmlPath : customXmlPath
    property string tempXmlName : customXmlName

    property int currentXmlIndexTaffssir : Number(storageItem.getSettings("indexselectorTaffssir", 0))
    property string customXmlPathTranslate : storageItem.getSettings('xmlPathTranslate', "" )
    property string customXmlNameTranslate : storageItem.getSettings('xmlNameTranslate', emptyLoadTitle )
    property string tempXmlPathTranslate : customXmlPathTranslate
    property string tempXmlNameTranslate : customXmlNameTranslate

    //---------------------------------------
    DisplayBlanking {
        id: idPreventorScreenBlanking
        preventBlanking: displayPreventBlanking === 1 &&  viewableQuran && applicationActive
    }
    FontLoader {
        id: localFont
        source: customFontPath
        onSourceChanged: {
            //console.log("font changed...localFont.name="+localFont.name)
            //console.log("font changed...customFontPath="+localFont.source)
            //console.log("font changed...status="+localFont.status)
        }
        onStatusChanged: {
         // if (localFont.status === FontLoader.Ready) console.log('font Loaded')
        }
    }
    // a mettre tjrs tout les variables ici (pas dans les autres pages *.qml) 23-10-2015
    property int displayInfo_dpiWidth: Screen.width
    property int displayInfo_dpiHeight: Screen.height //app.height
    property int displayInfo_dpiMarge: 0//Theme.horizontalPageMargin

    property var skipinterval
    property string indexregion
    property string indexpays
    property bool payhasstate

    property string indexcity
    property string coordinatesCity

    property string lang //"1" english "2" Arabic "6" francais

    property bool uiArabic: lang==="2"
    property bool hindinumber: false

    property string timefajr
    property string timesunrise
    property string timedhuhr
    property string timeasr
    property string timemaghrib
    property string timeisha

    property bool isfajrExtrem
    property bool issunriseExtrem
    property bool isdhuhrExtrem
    property bool isasrExtrem
    property bool ismaghribExtrem
    property bool isishaExtrem

    property string nextfajr

    property bool isRamathan:false  //pour config Ramathan
    property bool isJommoaa:false  //pour config Silent in Jommoaa 17-11-2018

    property int adjust_hijri:0
    property string event_hijri

    property int adjust_fajr:1
    property int adjust_dhuhr:1
    property int adjust_asr:1
    property int adjust_maghrib:1
    property int adjust_isha:1

    property string time_end_Isha
    property string timebegin_Tholoth_akhir
    property string timeimsak

    property string time_now
    property string time_hijri

    property string time_hijri_Arab
    property string time_now_Arab

    property string time_hijri_Arab_NbreHindi
    property string time_now_Arab_NbreHindi


    property string cityname: "Mekka" //"مكة المكرمة"

    property string method: '5'
    property string exmethods: '0'
    property string lat: "21.423333"
    property string longi: "39.823333"
    property string tzone: "+3"
    property string timeformat: '12'
    property string dst: '0'


    property string next_salat
    property string next_salat_ID
    property string remaining_time
    property int  pourcent_remaining_time


    property int  adhan_Fajr: 1
    property string selectedFajrAdhanFileUser: selectedSound
    property string selectedFajrAdhanFileUserName: settings.getValueFor("selectedFajrAdhanFileUserName","")

    property int stylecompass: 2

    // property bool viewable: cover.status === Cover.Active || applicationActive

    //property int i: 0
    //onViewableChanged: i=i+1

    //onViewableChanged: if (viewable==true ) calcul()

    property bool  athanIsPlaying

    property string  noAthanInSilentProfileChecked: "0"
    property string volumeAthanSlidervalue: "75"
    property int  athan_Fajr_Old

    property string  alerteActiveChecked: "0"
    property string minAlerteBeforeAthanvalue: "10"

    property string  silenctAfterAthanActiveChecked: "0"
    property string minSilentActiveAfterAthanvalue: "10"
    property string minSilentActivedurationvalue: "10"

    property string  formatNumberHindiActiveChecked: "1"

    property bool  remainTimeZero

    property string  minSilentDuringTarawihvalue: "57"
    property string  silentDuringTarawihChecked: "0"

    //---17-11-2018-------
    property string  minSilentActiveBeforAthanJommoaavalue: "30"
    property string  minSilentActiveAfterAthanJommoaavalue: "35"
    property string  silentDuringSalatJommoaaChecked: "0"

    //---11-11-2018-------
    property string  stopathanonrotationChecked: "0"
    property bool  athanHasStoped


    property int  run_periodsActiveAtlert
    property int  run_periodsActiveAthan
    property int  run_periodsActiveSilent
    property int  run_periodsActiveBackMode
    property bool  playhaftimersisActive

    property bool  run_periodsActiveAtlertIsActive
    property bool  run_periodsActiveAthanIsActive
    property bool  run_periodsActiveSilentIsActive
    property bool  run_periodsActiveBackModeIsActive

    property string  playAthkarSabahChecked: "0"
    property string  playAthkarMassaChecked: "0"

    property string  minplayAthkarSabah: "10"
    property string  minplayAthkarMassa: "5"

    //--------------------
    Connections {
        target: calculcpp
        onSendToQml: {
            ////console.log("from C++: remaining_time_haf_Sec()= " + count)
        }
        onSendToQmltempRemainingTime: {
            remaining_time=count
            ////console.log("from C++: remaining_time= " + count)
        }
        onSendToQmltempAlert: {
            run_periodsActiveAtlert=count
            run_periodsActiveAtlertIsActive=isactive
            ////console.log("from C++: Temps pour Alert= " + count+"("+isactive+")")
        }
        onSendToQmltempAthan: {
            run_periodsActiveAthan=count
            run_periodsActiveAthanIsActive=isactive
            ////console.log("from C++: Temps pour Athan= " + count+"("+isactive+")")
        }
        onSendToQmltempActiveSilent: {
            run_periodsActiveSilent=count
            run_periodsActiveSilentIsActive=isactive
            ////console.log("from C++: Temps pour Active Silent= " + count+"("+isactive+")")
        }
        onSendToQmltempReturntoNormalMode: {
            run_periodsActiveBackMode=count
            run_periodsActiveBackModeIsActive=isactive
            ////console.log("from C++: Temps pour Back mode= " + count+"("+isactive+")")
        }
        onSendToQmlplayhaftimersisActive: {
            playhaftimersisActive=count
            ////console.log("from C++: Temps pour Back mode= " + count)
        }
        onSendToQmlAthanIsPlaying: {
            athanIsPlaying=true
        }
        onSendToQmlAthanIsStoped: {
            athanIsPlaying=false
        }
        onSendToQmlRemainTimeZero: {
            remainTimeZero=true
        }
        onSendToQmlRemainTimeNotZero: {
            remainTimeZero=false
        }

    }
    ConfigurationValue {
        id: timeFormatConfig
        key: "/sailfish/i18n/lc_timeformat24h"
    }
    function calcul(){
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
        if (lang=="2"){
            time_hijri_Arab=time_hijri.replace(/Muharram/gi, "محرم").replace(/Safar/gi, "صفر").replace(/Rabi II/gi, "ربيع الثاني").replace(/Rabi I/gi, "ربيع الأول").replace(/Jumada II/gi, "جمادى الثاني").replace(/Jumada I/gi, "جمادى الأول").replace(/Rajab/gi, "رجب").replace(/Shaaban/gi, "شعبان").replace(/Ramadan/gi, "رمضان").replace(/Shawwal/gi, "شوال").replace(/Thul-Qiaadah/gi, "ذو القعدة").replace(/Thul-Hijja/gi, "ذو الحجة")
            time_now_Arab=time_now.replace(/am/gi, "ص").replace(/pm/gi, "م")
        }

        if (formatNumberHindiActiveChecked=="0"){
            time_hijri_Arab_NbreHindi=time_hijri_Arab.replace(/0/gi, "٠").replace(/1/gi, "١").replace(/2/gi, "٢").replace(/3/gi, "٣").replace(/4/gi, "٤").replace(/5/gi, "٥").replace(/6/gi, "٦").replace(/7/gi, "٧").replace(/8/gi, "٨").replace(/9/gi, "٩")   //.replace(/./gi, "٫")
            time_now_Arab_NbreHindi=time_now_Arab.replace(/0/gi, "٠").replace(/1/gi, "١").replace(/2/gi, "٢").replace(/3/gi, "٣").replace(/4/gi, "٤").replace(/5/gi, "٥").replace(/6/gi, "٦").replace(/7/gi, "٧").replace(/8/gi, "٨").replace(/9/gi, "٩")            //.replace(/./gi, "٫")

        }

        isJommoaa = calculcpp.isJommoaa()
        isRamathan = calculcpp.isRamathan(adjust_hijri)
        //event_hijri = calculcpp.getstrDaysEvent(adjust_hijri)

        timefajr = calculcpp.displayTimes_hhmm(0);
        timesunrise = calculcpp.displayTimes_hhmm(1);
        timedhuhr = calculcpp.displayTimes_hhmm(2);
        timeasr = calculcpp.displayTimes_hhmm(3);
        timemaghrib = calculcpp.displayTimes_hhmm(4);
        timeisha = calculcpp.displayTimes_hhmm(5);

        isfajrExtrem = calculcpp.isPrayerExtrem(0);
        issunriseExtrem = calculcpp.isPrayerExtrem(1);
        isdhuhrExtrem = calculcpp.isPrayerExtrem(2);
        isasrExtrem = calculcpp.isPrayerExtrem(3);
        ismaghribExtrem = calculcpp.isPrayerExtrem(4);
        isishaExtrem = calculcpp.isPrayerExtrem(5);

        timeimsak = calculcpp.displayTimes_imsaak_hhmm();
        nextfajr = calculcpp.displayTimes_nextfajr_hhmm();

        time_end_Isha = calculcpp.displayTimes_time_end_Isha_hhmm();
        timebegin_Tholoth_akhir = calculcpp.displayTimes_timebegin_Tholoth_akhir_hhmm();

        next_salat = calculcpp.next_salat_haf()
        next_salat_ID = calculcpp.next_salat_haf_id();
        remaining_time = calculcpp.remaining_time_haf()
        pourcent_remaining_time = calculcpp.remaining_ProgressBar_haf()

        //-----19-11-2018


    }
    Calculcpp {
        id: calculcpp
    }
    Settings {
        id: settings
    }
    DownloadManager {
        id: downloadManager
    }
    //    UIConnection {
    //        id: uiconnection
    //    }
    cover: CoverPage {
        id: cover
    }
    Timer {
        id: timerclock
        interval: 1000 // every 15 secs update for now
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            cover.updateTime()
        }
        running: viewable
    }




    property string selectedSound: "../sounds/Adhan/adhan_court.mp3";

    // Close enough to assume screen is off.
    property bool viewable: cover.status === Cover.Active
                            || cover.status === Cover.Activating
                            || applicationActive;

    /////----HAF 5-3-2022---------------
    property bool viewableQuran
    onVisibleChanged: {
        // when returned to this app from another app
        if (visible === true) {
            viewableQuran=true
        }else{
            viewableQuran=false
        }
    }
    /////--------------------------------
    onViewableChanged: {
        if (viewable==true ) {
            if (timeFormatConfig.value === "24") {
                timeformat="24";
            } else {
                timeformat="12";
            }
            settings.saveValueFor("timeformat",timeformat);
            calcul();
        }
        // if (!backgroundJobAlert.running && !backgroundJobAthan.running && !backgroundJobActiveSilent.running && !backgroundJobRestoreOriginalMode.running) {
        // return;
        // }

        if(viewable) {
            calcul();
            timerclock.restart();
            timercalcul.restart();
            event_hijri = calculcpp.getstrDaysEvent(adjust_hijri);
        }
    }


    Component.onCompleted: {
        timerclock.restart();
        timercalcul.restart();

        calculcpp.haftimersplayall()
        event_hijri = calculcpp.getstrDaysEvent(adjust_hijri);

    }

    Component.onDestruction: {
        //-----
    }

    initialPage: Component { PrayerTimes { } }
    //cover: Qt.resolvedUrl("cover/CoverPage.qml")
    allowedOrientations: Orientation.Portrait
    _defaultPageOrientations: Orientation.Portrait
}


