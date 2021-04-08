import QtQuick 2.2
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

import ".."

Item {
    id: configGeneral
    property string cfg_folders: plasmoid.configuration.folders
    property int dialogMode: -1
    
    FoldersModel {
        id: foldersModel
    }
    
    Component.onCompleted: {
        
        foldersModel.clear()
        var folders = JSON.parse(cfg_folders)
        for (var i = 0; i < folders.length; i++) {
            foldersModel.append(folders[i])
        }
    }   
    
    
    ColumnLayout {
        Layout.fillHeight: true
        Layout.fillWidth: true
        anchors.fill: parent
        RowLayout {
            Layout.fillHeight: true
            TableView {
                id: foldersTable
                model: foldersModel
                Layout.fillHeight: true
                Layout.fillWidth: true
                TableViewColumn {
                    role: "name"
                    title: i18n("Name")
                    width: foldersTable.width/2 - 15
                }
            
                TableViewColumn {
                    role: "info"
                    title: i18n("Information")
                    width: foldersTable.width/2 - 15
                }
                
                onClicked: {
                    edit.enabled = true
                    remove.enabled = true
                    moveUp.enabled = true
                    moveDown.enabled = true
                }
            }
            ColumnLayout {
                id: buttonsColumn
                Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                Layout.fillHeight: true
                
                Button {
                    text: i18n("Add")
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignLeft
                    iconName: "list-add"
                    onClicked: {
                        addFolder()
                    }
                }
                Button {
                    id: edit
                    text: i18n("Edit")
                    iconName: "edit-entry"
                    Layout.fillWidth: true
                    enabled: false
                    onClicked: {
                        editFolder()
                    }
                }
                Button {
                    id: remove
                    text: i18n("Remove")
                    iconName: "list-remove"
                    Layout.fillWidth: true
                    enabled: false
                    onClicked: {
                        if (foldersTable.currentRow == -1)
                            return
                        foldersTable.model.remove(foldersTable.currentRow)
                        cfg_folders = JSON.stringify(getFoldersArray())
                    }
                }
                Button {
                    id: moveUp
                    text: i18n("Move up")
                    iconName: "go-up"
                    enabled: false
                    Layout.fillWidth: true
                    onClicked: {
                        if (foldersTable.currentRow == -1
                                || foldersTable.currentRow == 0) {
                            this.enabled == false
                            return
                        }
                        foldersTable.model.move(foldersTable.currentRow,
                                                foldersTable.currentRow - 1, 1)
                        foldersTable.selection.clear()
                        foldersTable.selection.select(
                                    foldersTable.currentRow - 1)
                        cfg_folders = JSON.stringify(getFoldersArray())
                    }
                }
                Button {
                    id: moveDown
                    text: i18n("Move down")
                    Layout.alignment: Qt.AlignLeft | Qt.AlignBottom
                    iconName: "go-down"
                    Layout.fillWidth: true
                    enabled: false
                    onClicked: {
                        if (foldersTable.currentRow == -1
                                || foldersTable.currentRow == foldersTable.model.count - 1) {
                            this.enabled == false
                            return
                        }
                        foldersTable.model.move(foldersTable.currentRow,
                                                foldersTable.currentRow + 1, 1)
                        foldersTable.selection.clear()
                        foldersTable.selection.select(
                                    foldersTable.currentRow + 1)
                        cfg_folders = JSON.stringify(getFoldersArray())
                    }
                }
            }
        }
        
    }
    
    Dialog {
        id: folderDialog
        visible: false
        title: i18n("Folder")
        standardButtons: StandardButton.Cancel | StandardButton.Save

        onAccepted: {
            var itemObject = {
                "name": folderName.text,
                "url": folderUrl.text,
                "info": folderInfo.text,
                "icon": folderIcon.text
            }

            if (dialogMode == -1) {
                foldersModel.append(itemObject)
            } else {
                foldersModel.set(dialogMode, itemObject)
            }

            cfg_folders= JSON.stringify(getFoldersArray())
        }

        ColumnLayout {
            GridLayout {
                columns: 2

                Label {
                    text: i18n("Name:")
                }

                TextField {
                    id: folderName
                    Layout.minimumWidth: theme.mSize(
                                             theme.defaultFont).width * 40
                }

                Label {
                    text: i18n("Folder URL:")
                }

                TextField {
                    id: folderUrl
                    Layout.minimumWidth: theme.mSize(
                                             theme.defaultFont).width * 40
                }

                Label {
                    text: i18n("Information:")
                }

                TextField {
                    id: folderInfo
                    Layout.minimumWidth: theme.mSize(
                                             theme.defaultFont).width * 40
                }
                Label {
                    text: i18n("Icon:")
                }

                TextField {
                    id: folderIcon
                    Layout.minimumWidth: theme.mSize(
                                             theme.defaultFont).width * 40
                }
                
                IconPicker {
                    currentIcon: folderIcon.text
                    defaultIcon: "folder-open"
                    onIconChanged: folderIcon.text = iconName
                    enabled: true
                }
            }
        }
    }    
    
    function addFolder() {
        dialogMode = -1
        folderName.text = ""
        folderUrl.text = ""
        folderInfo.text = ""
        folderIcon.text="folder"
        folderDialog.visible = true
        folderName.focus = true
    }

    function editFolder() {
        dialogMode = foldersTable.currentRow

        folderName.text = foldersModel.get(dialogMode).name
        folderUrl.text = foldersModel.get(dialogMode).url
        folderInfo.text = foldersModel.get(dialogMode).info
        folderIcon.text = foldersModel.get(dialogMode).icon
        folderDialog.visible = true
        folderName.focus = true
    }
    
    function getFoldersArray() {
        var foldersArray = []
        for (var i = 0; i < foldersModel.count; i++) {
            foldersArray.push(foldersModel.get(i))
        }
        return foldersArray
    }
    
    
    
    
    
}
