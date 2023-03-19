import QtQuick 2.6
import Sailfish.Silica 1.0
import Sailfish.Pickers 1.0 // File-Loader

import harbour.thakir_prayer_times.settings 1.0

Page {
    id: pageSettings

    Component {
        id: fontPickerPage
        FilePickerPage {
            title: qsTr("Select font")
            nameFilters: [ '*.ttf', '*.otf' ]
            onSelectedContentPropertiesChanged: {
                tempFontPath = selectedContentProperties.filePath
                tempFontName = selectedContentProperties.fileName
                if (valueButtonselectorFontQuran.label!==qsTr("[Load]")) selectorFontQuran.currentIndex=1
            }
        }
    }
    Component {
        id: filePickerPage1
        FilePickerPage {
            title: qsTr("Load Quran XML file")
            nameFilters: [ '*.xml' ]
            onSelectedContentPropertiesChanged: {
                tempXmlPath = selectedContentProperties.filePath
                tempXmlName = selectedContentProperties.fileName
                if (valueButtonselectorxmlQuran.label!==qsTr("[Load]")) selectorxmlQuran.currentIndex=1
                calculcpp.readxml(tempXmlPath) // correct bug in xml file from https://tanzil.net/download
            }
        }
    }
    Component {
        id: filePickerPage2
        FilePickerPage {
            title: qsTr("Load Quran translation XML file")
            nameFilters: [ '*.xml' ]
            onSelectedContentPropertiesChanged: {
                tempXmlPathTranslate = selectedContentProperties.filePath
                tempXmlNameTranslate = selectedContentProperties.fileName
                if (valueButtonselectorxmlQurantranslate.label!==qsTr("[Load]")) selectorTaffssir.currentIndex=2
                calculcpp.readxml(tempXmlPathTranslate) // correct bug in xml file from https://tanzil.net/download
            }
        }
    }

    SilicaFlickable{
        anchors.fill: parent
        contentHeight: column.height // tell overall height

        Column {
            id: column
            width: pageSettings.width
            spacing: Theme.paddingLarge

            Row {
                width: parent.width

                Label {
                    id: idLabelSettingsHeader
                    width: parent.width / 5 * 4
                    leftPadding: Theme.paddingLarge  + Theme.paddingSmall
                    font.pixelSize: Theme.fontSizeExtraLarge
                    color: Theme.highlightColor
                    text: qsTr("Settings Quran")
                }
            }
            Item {
                width: parent.width
                height: Theme.paddingLarge
            }
            Row {
                width: parent.width
                spacing: Theme.paddingLarge
                ComboBox {
                    id: selectorxmlQuran
                    width: parent.width / 2
                    label: qsTr("Quran")
                    currentIndex: Number(storageItem.getSettings("indexselectorxmlQuran", 0))
                    menu: ContextMenu {
                        MenuItem {
                            text: qsTr("Simple plain")
                        }
                        MenuItem {
                            text: qsTr("Custom (xml file)")
                        }
                    }
                }
                ValueButton {
                    id: valueButtonselectorxmlQuran
                    visible: selectorxmlQuran.currentIndex === 1
                    width: parent.width / 2
                    labelColor: Theme.highlightColor
                    label: tempXmlName==="[Load]"?  qsTr("[Load]"):tempXmlName
                    onClicked: {
                        //console.log("tempXmlName="+tempXmlName)
                        pageStack.push(filePickerPage1)
                    }
                }
            }
            Row {
                width: parent.width
                spacing: Theme.paddingLarge
                ComboBox {
                    id: selectorTaffssir
                    width: parent.width / 2
                    label: qsTr("Taffssir/Translations")
                    currentIndex: Number(storageItem.getSettings("indexselectorTaffssir", 0))
                    menu: ContextMenu {
                        MenuItem {
                            text: qsTr("ar.muyassar")
                        }
                        MenuItem {
                            text: qsTr("ar.jalalayn")
                        }
                        MenuItem {
                            text: qsTr("Custom (xml file)")
                        }
                    }
                }
                ValueButton {
                    id: valueButtonselectorxmlQurantranslate
                    visible: selectorTaffssir.currentIndex === 2
                    width: parent.width / 2
                    labelColor: Theme.highlightColor
                    label: tempXmlNameTranslate==="[Load]"?  qsTr("[Load]"):tempXmlNameTranslate
                    onClicked: {
                        //console.log("tempXmlNametranslate="+tempXmlNameTranslate)
                        pageStack.push(filePickerPage2)
                    }
                }
            }
            ComboBox {
                id: selectornameKria
                width: parent.width
                label: qsTr("Recitations")
                currentIndex: Number(storageItem.getSettings("indexselectornameKria", 0))
                menu: ContextMenu {
                    MenuItem {
                        id: kiraa_0
                        text: qsTr("Sheikh Saad Al-Ghamdi")
                    }
                    MenuItem {
                        id: kiraa_1
                        text: qsTr("Sheikh Ali bin Abdul Rahman Al-Hudhaifi")
                    }
                    MenuItem {
                        id: kiraa_2
                        text: qsTr("Sheikh Abdul Rahman Al-Sudais")
                    }
                    MenuItem {
                        id: kiraa_3
                        text: qsTr("Sheikh Muhammad Siddiq Al-Minshawi")
                    }
                    MenuItem {
                        id: kiraa_4
                        text: qsTr("Sheikh Fares Abbad")
                    }
                    MenuItem {
                        id: kiraa_5
                        text: qsTr("Sheikh Abdul Basit Abdul Samad -Recitation-")
                    }
                    MenuItem {
                        id: kiraa_6
                        text: qsTr("Sheikh Abdul Basit Abdul Samad -Tajweed-")
                    }
                    MenuItem {
                        id: kiraa_7
                        text: qsTr("Sheikh Maher Al-Muaiqly")
                    }
                    MenuItem {
                        id: kiraa_8
                        text: qsTr("Sheikh Mahmoud Khalil Al-Hosary")
                    }
                }
            }

            Row {
                width: parent.width
                spacing: Theme.paddingLarge
                ComboBox {
                    id: selectorFontQuran
                    width:  parent.width / 2
                    label: qsTr("Fonts")
                    currentIndex: Number(storageItem.getSettings("indexselectorFontQuran", 0))
                    menu: ContextMenu {
                        MenuItem {
                            text: qsTr("System font")
                        }
                        MenuItem {
                            text: qsTr("Custom (font file)")
                        }
                    }
                }
                ValueButton {
                    id: valueButtonselectorFontQuran
                    visible: selectorFontQuran.currentIndex === 1
                    width: parent.width / 2
                    labelColor: Theme.highlightColor
                    label: tempFontName==="[Load]"?  qsTr("[Load]"):tempFontName
                    onClicked: {
                        //console.log("tempFontName="+tempFontName)
                        pageStack.push(fontPickerPage)
                    }
                }
            }
            ComboBox {
                id: selectorTextsize
                width: parent.width
                label: qsTr("Fontsize")
                currentIndex: Number(storageItem.getSettings("indexselectorTextsize", 3))
                menu: ContextMenu {
                    MenuItem {
                        id: item_0
                        font.pixelSize: Theme.fontSizeTiny
                        text: qsTr("tiny")
                    }
                    MenuItem {
                        id: item_1
                        font.pixelSize: Theme.fontSizeExtraSmall
                        text: qsTr("extra small")
                    }
                    MenuItem {
                        id: item_2
                        font.pixelSize: Theme.fontSizeSmall
                        text: qsTr("small")
                    }
                    MenuItem {
                        id: item_3
                        font.pixelSize: Theme.fontSizeMedium
                        text: qsTr("medium")
                    }
                    MenuItem {
                        id: item_4
                        font.pixelSize: Theme.fontSizeLarge
                        text: qsTr("large")
                    }
                    MenuItem {
                        id: item_5
                        font.pixelSize: Theme.fontSizeExtraLarge
                        text: qsTr("extra large")
                    }
                }
            }
            ComboBox {
                id: selectorBlankingPreventor
                width: parent.width
                label: qsTr("Screen blanking")
                currentIndex: Number(storageItem.getSettings("indexselectorBlankingPreventor", 0))
                menu: ContextMenu {
                    MenuItem {
                        text: qsTr("system")
                    }
                    MenuItem {
                        text: qsTr("disabled")
                    }
                }
            }

            Column {
                //anchors.bottom: pageSettings.bottom
                width: parent.width
                Separator {
                    id: navigationRowSeparator
                    width: parent.width
                    color: Theme.primaryColor
                    horizontalAlignment: Qt.AlignHCenter
                }
                Label {
                    width: parent.width
                    horizontalAlignment: Text.AlignHCenter
                    text: "You can download xml file from:"
                    color: "red"
                    linkColor: "#ffffff"
                    wrapMode: Text.Wrap
                    truncationMode: TruncationMode.Fade
                    onLinkActivated: {
                        Qt.openUrlExternally(link)
                    }
                }
                Label {
                    width: parent.width
                    horizontalAlignment: Text.AlignHCenter
                    text: "<a href=\"https://tanzil.net/download\">https://tanzil.net/download/</a> or"
                    color: "red"
                    linkColor: "#ffffff"
                    wrapMode: Text.Wrap
                    truncationMode: TruncationMode.Fade
                    onLinkActivated: {
                        Qt.openUrlExternally(link)
                    }
                }
                Label {
                    width: parent.width
                    horizontalAlignment: Text.AlignHCenter
                    text: "<a href=\"https://tanzil.net/trans/\">https://tanzil.net/trans/</a>"
                    color: "red"
                    linkColor: "#ffffff"
                    wrapMode: Text.Wrap
                    truncationMode: TruncationMode.Fade
                    onLinkActivated: {
                        Qt.openUrlExternally(link)
                    }
                }
                Label {
                    width: parent.width
                    horizontalAlignment: Text.AlignHCenter
                    text: "and load it in this application."
                    color: "red"
                    linkColor: "#ffffff"
                    wrapMode: Text.Wrap
                    truncationMode: TruncationMode.Fade
                }
            }
        }
    }
    function writeDB_Settings_Quran() {
        if ( selectorFontQuran.currentIndex === 1 && tempFontPath !== "" ) { //SF standard font
            customFontName = tempFontName
            customFontPath = tempFontPath
            currentFontIndex = 1
            localFont.source = tempFontPath
        }
        else { // normal font
            currentFontIndex = 0
            localFont.source = tempFontPath
        }

        if (selectorTextsize.currentIndex === 0) { settingsTextsize = Theme.fontSizeTiny }
        else if (selectorTextsize.currentIndex === 1) { settingsTextsize = Theme.fontSizeExtraSmall }
        else if (selectorTextsize.currentIndex === 2) { settingsTextsize = Theme.fontSizeSmall }
        else if (selectorTextsize.currentIndex === 3) { settingsTextsize = Theme.fontSizeMedium }
        else if (selectorTextsize.currentIndex === 4) { settingsTextsize = Theme.fontSizeLarge }
        else if (selectorTextsize.currentIndex === 5) { settingsTextsize = Theme.fontSizeExtraLarge }

        selectorxmlQuranindex = selectorxmlQuran.currentIndex
        selectorTaffssirindex = selectorTaffssir.currentIndex

        if ( selectorFontQuran.currentIndex === 0 ) {
            usesystemfont = "true"
        } else  {
            usesystemfont = "false"
            customFontPath= tempFontPath
        }

        if ( selectorBlankingPreventor.currentIndex === 0 ) {
            displayPreventBlanking = 0
        } else if ( selectorBlankingPreventor.currentIndex === 1 ) {
            displayPreventBlanking = 1
        }


        customXmlPath = tempXmlPath
        customXmlPathTranslate = tempXmlPathTranslate

        switch(selectornameKria.currentIndex) {
          case 0:
              nameKria="Ghamadi_40kbps"
            break;
          case 1:
              nameKria="Hudhaify_64kbps"
            break;
          case 2:
              nameKria="Abdurrahmaan_As-Sudais_64kbps"
            break;
          case 3:
              nameKria="Minshawy_Mujawwad_64kbps"
            break;
          case 4:
              nameKria="Fares_Abbad_64kbps"
            break;
          case 5:
              nameKria="Abdul_Basit_Murattal_64kbps"
            break;
          case 6:
              nameKria="Abdul_Basit_Mujawwad_128kbps"
            break;
          case 7:
              nameKria="Maher_AlMuaiqly_64kbps"
            break;
          case 8:
              nameKria="Husary_64kbps"
            break;
              //-----bis to add see bb10!
          default:
            // code block
        }

        //save settings Quran
        storageItem.setSettings("usesystemfont", usesystemfont)
        storageItem.setSettings("customFontName", customFontName)
        storageItem.setSettings("customFontPath", customFontPath)
        storageItem.setSettings("xmlName", tempXmlName)
        storageItem.setSettings("xmlPath", tempXmlPath)
        //storageItem.setSettings('filePath', tempXmlPath)


        storageItem.setSettings("xmlNameTranslate", tempXmlNameTranslate)
        storageItem.setSettings("xmlPathTranslate", tempXmlPathTranslate)
        //storageItem.setSettings('filePath', tempXmlPath)

        storageItem.setSettings("fontsize", settingsTextsize)
        storageItem.setSettings("fontName", tempFontName)
        storageItem.setSettings("fontPath", tempFontPath)
        //storageItem.setInfos('filePath', tempXmlPath)
        storageItem.setSettings("screenBlanking", displayPreventBlanking)

        storageItem.setSettings("indexselectorxmlQuran", selectorxmlQuran.currentIndex)
        storageItem.setSettings("indexselectorTaffssir", selectorTaffssir.currentIndex)
        storageItem.setSettings("indexselectorFontQuran", selectorFontQuran.currentIndex)
        storageItem.setSettings("indexselectorTextsize", selectorTextsize.currentIndex)
        storageItem.setSettings("indexselectorBlankingPreventor", selectorBlankingPreventor.currentIndex)

        storageItem.setSettings("indexselectornameKria", selectornameKria.currentIndex)
        storageItem.setSettings("nameKria", nameKria)

    }

    onStatusChanged: {
        //console.log("ok=PageStatus.Active changed settings Quran ="+status)
        if (status !== PageStatus.Inactive) {
            //console.log("---------------------+++++++++++++++++++++++++++++++------------------------*******--------------")
            if (selectorxmlQuran.currentIndex===1 && valueButtonselectorxmlQuran.label===qsTr("[Load]")) {
                selectorxmlQuran.currentIndex=0
            }
            if (selectorTaffssir.currentIndex===2 && valueButtonselectorxmlQurantranslate.label===qsTr("[Load]")) {
                selectorTaffssir.currentIndex=0
            }
            if (selectorFontQuran.currentIndex===1 && valueButtonselectorFontQuran.label===qsTr("[Load]")) {
                selectorFontQuran.currentIndex=0
            }
            writeDB_Settings_Quran()
        }
    }
    Component.onCompleted: {

    }

}
