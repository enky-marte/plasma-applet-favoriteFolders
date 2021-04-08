import QtQuick 2.2
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore


Item {
    
    property int widgetWidth: plasmoid.configuration.widgetWidth

    Plasmoid.compactRepresentation: PlasmaCore.IconItem {
        //source: 'folder-open'
        source: plasmoid.configuration.icon
        width: units.iconSizes.medium
        height: units.iconSizes.medium
        active: mouseArea.containsMouse

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            onClicked: plasmoid.expanded = !plasmoid.expanded
            hoverEnabled: true
        }
    }

    Plasmoid.fullRepresentation: FullRepresentation {}

    Plasmoid.preferredRepresentation: Plasmoid.compactRepresentation
//     Plasmoid.preferredRepresentation: Plasmoid.fullRepresentation
}

