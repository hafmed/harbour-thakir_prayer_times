import QtQuick 2.6
import Sailfish.Silica 1.0
import Sailfish.Pickers 1.0


Page {
    id: page

    property string selectedMusicFile

    ValueButton {
        anchors.centerIn: parent
        label: qsTr('Athan')
        value: selectedMusicFile ? selectedMusicFile : qsTr('None')
        onClicked: pageStack.push(musicPickerPage)
    }

    Component {
        id: musicPickerPage
        MusicPickerPage {
            title: qsTr('Select Athan file!')
            onSelectedContentPropertiesChanged: {
                selectedFajrAdhanFileUser=selectedContentProperties.filePath
                page.selectedMusicFile = selectedContentProperties.filePath
            }
        }
    }

}


//import QtQuick 2.6
//import QtMultimedia 5.0
//import Sailfish.Silica 1.0
//import harbour.thakir_prayer_times.folderlistmodel 1.0

//Dialog {
//    id: soundsDialog;
//    allowedOrientations: Orientation.Portrait | Orientation.Landscape;

//    canAccept: false;

//    property string selectedSound: '';

//    Audio {
//        id: sound;
//    }

//    SilicaListView {
//        id: soundsList;
//        anchors.fill: parent
//        quickScroll: true;
//        currentIndex: -1;

//        PullDownMenu {
//            quickSelect: true;
//            visible: soundsModel.path !== soundsModel.homePath();
//            MenuItem {
//                text: qsTr('Up');
//                onClicked: {
//                    soundsDialog.canAccept = false;
//                    soundsModel.path = soundsModel.parentPath;
//                }
//            }
//        }

//        FolderListModel {
//            id: soundsModel;
//            path: homePath();
//            nameFilters: ["*.mp3", "*.wav", "*.flac"];
//            showDirectories: true;
//            filterMode: FolderListModel.Inclusive;
//        }

//        header: DialogHeader {
//            acceptText: qsTr('Select');
//        }

//        model: soundsModel;

//        delegate: ListItem {
//            id: soundItem;
//            contentHeight: Theme.itemSizeSmall;
//            highlighted: model.index === soundsList.currentIndex && !model.isDir;
//            onClicked: {
//                //console.log('Tapped: ', soundsList.currentIndex, model.index, model.filePath, model.fileName);
//                if(model.isDir) {
//                    soundsModel.path = model.filePath;
//                    soundsDialog.canAccept = false;
//                    if(sound.playbackState === Audio.PlayingState) {
//                        sound.stop();
//                    }
//                } else {
//                    selectedSound = model.filePath;
//                    soundsList.currentIndex = model.index;
//                    soundsDialog.canAccept = highlighted;

//                    //console.log('highlighted:', highlighted);
//                    //console.log('sound playing:', sound.playbackState === Audio.PlayingState);
//                    if(highlighted) {
//                        if(sound.playbackState === Audio.PlayingState) {
//                            sound.stop();
//                        } else {
//                            sound.source = model.filePath;
//                            sound.play();
//                        }

//                        //console.log('sound playing:', sound.playbackState === Audio.PlayingState);
//                    } else {
//                        soundsList.currentIndex = -1;
//                        if(sound.playing) {
//                            sound.stop();
//                        }
//                    }
//                }
//            }

//            onFocusChanged: {
//                /*//console.log('Focus change', model.index, soundsList.currentIndex, soundsList.lastItem);
//                if(soundsList.lastItem > -1 && model.index !== soundsList.lastItem) {
//                    //console.log('deselecting', model.index, soundsList.lastItem, highlighted, soundsList.highlightFollowsCurrentItem);
//                    highlighted = false;
//                }*/
//            }

//            onCanceled: {
//                //console.log('Cancelled', model.index);
//            }

//            Image {
//                id: icon;
//                x: Theme.paddingLarge;
//                width: Theme.fontSizeLarge;
//                height: Theme.fontSizeLarge;
//                source: model.isDir ? 'image://theme/icon-m-folder' : 'image://theme/icon-l-music';
//            }
//            Label {
//                id: name;
//                x: (Theme.paddingLarge * 2) + Theme.fontSizeLarge;
//                //anchors.left: icon.right;
//                truncationMode: TruncationMode.Fade;
//                text: model.fileName;
//                width: parent.width;
//                color: model.index === soundsList.currentIndex ? Theme.highlightColor : Theme.secondaryColor;
//                //color: highlighted ? Theme.highlightColor : Theme.secondaryColor;
//            }
//        }
//        VerticalScrollDecorator {
//            flickable: soundsList;
//        }
//        ViewPlaceholder {
//            enabled: soundsList.count === 0;
//            text: qsTr('No sound files here.');
//        }
//    }

//    function deSelect(idx) {
//        //console.log('deSelect', idx);
//        /*for (var i = 0; i < soundsList.contentItem.children.length; ++i) {
//            //console.log('Child type:', soundsList.contentItem.children[i].highlighted);
//        }
//        if(soundsList.contentItem.children[idx].highligted) {
//            soundsList.contentItem.children[idx].highligted = false;
//        }*/
//    }

//    /*onAccepted: {
//        tmpSelectedSound = _selectedSound;
//    }*/
//}
