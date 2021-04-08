import QtQuick 2.5
import QtQuick.Layouts 1.1
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.extras 2.0 as PlasmaExtras


import QtQuick.Controls 1.1

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.extras 2.0 as PlasmaExtras
import org.kde.plasma.plasmoid 2.0


import QtQuick.Controls 2.2 as QQC2


Item {
    property real mediumSpacing: 1.5*units.smallSpacing
    property real textHeight: theme.defaultFont.pixelSize + theme.smallestFont.pixelSize + units.smallSpacing
    property real itemHeight: Math.max(units.iconSizes.medium, textHeight)

    Layout.minimumWidth: widgetWidth
    Layout.minimumHeight: (itemHeight + 2*mediumSpacing) * listView.count

    Layout.maximumWidth: Layout.minimumWidth
    Layout.maximumHeight: Layout.minimumHeight

    Layout.preferredWidth: Layout.minimumWidth
    Layout.preferredHeight: Layout.minimumHeight
    
    FoldersModel {
        id: foldersModel
    }
    
    Component.onCompleted: {
        /*foldersModel.clear()
        var folders = JSON.parse(plasmoid.configuration.folders)
        for (var i = 0; i < folders.length; i++) {
            foldersModel.append(folders[i])
        }*/
        reloadFolderModel()
    }
    
    Connections {
        target: plasmoid.configuration
        onFoldersChanged: {
            reloadFolderModel()
        }
    }
    
    PlasmaExtras.ScrollArea {
        anchors.fill: parent

        ListView {
            id: listView
            anchors.fill: parent

            model: foldersModel

            highlight: PlasmaComponents.Highlight {}
            highlightMoveDuration: 0
            highlightResizeDuration: 0

            delegate: Item {
                 height: itemHeight + 2*mediumSpacing
                width: parent.width
               

                property bool isHovered: false
                property bool isEjectHovered: false

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true

                    onEntered: {
                        listView.currentIndex = index
                        isHovered = true
                    }
                    onExited: {
                        isHovered = false
                    }
                    onClicked: {
                        //console.log('el modelo es : ', model.keys())                        
                        plasmoid.expanded = false
                            Qt.openUrlExternally("file://" + model.url)
                    }

                    Row {
                        x: mediumSpacing
                        y: mediumSpacing
                        width: parent.width - 2*mediumSpacing
                        height: itemHeight
                        spacing: mediumSpacing

                        Item { // Hack - since setting the dimensions of PlasmaCore.IconItem won't work
                            height: units.iconSizes.medium
                            width: height
                            anchors.verticalCenter: parent.verticalCenter

                            PlasmaCore.IconItem {
                                anchors.fill: parent
                                source: model.icon
                                active: isHovered
                            }
                        }

                        Column {
                            width: parent.width - units.iconSizes.medium - mediumSpacing
                            height: textHeight
                            spacing: 0
                            anchors.verticalCenter: parent.verticalCenter

                            PlasmaComponents.Label {
                                text: model.name
                                width: parent.width
                                height: theme.defaultFont.pixelSize
                                elide: Text.ElideRight
                            }
                            Item {
                                width: 1
                                height: units.smallSpacing
                            }
                            PlasmaComponents.Label {
                                text: model.info
                                font.pointSize: theme.smallestFont.pointSize
                                opacity: isHovered ? 1.0 : 0.6
                                width: parent.width
                                height: theme.smallestFont.pixelSize
                                elide: Text.ElideRight

                                Behavior on opacity { NumberAnimation { duration: units.shortDuration * 3 } }
                            }
                        }
                    }
                }
            }
        }
    }
    
    function reloadFolderModel() {
        foldersModel.clear()
        var folders = JSON.parse(plasmoid.configuration.folders)
        for (var i = 0; i < folders.length; i++) {
            foldersModel.append(folders[i])
        }
    }
    
}
