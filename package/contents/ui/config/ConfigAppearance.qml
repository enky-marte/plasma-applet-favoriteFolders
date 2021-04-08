import QtQuick 2.2
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1
import org.kde.kquickcontrols 2.0 as KQuickControls
import org.kde.plasma.core 2.0 as PlasmaCore 

Item {
    id: configAppearance
    Layout.fillWidth: true
    
    property string cfg_icon: plasmoid.configuration.icon
    property alias cfg_widgetWidth: widgetWidth.value
    
    property var mediumSpacing: 1.5*units.smallSpacing
    
    ColumnLayout {
        RowLayout {
            Label {
                text: i18n("Widget width")
            }
            SpinBox {
                id: widgetWidth
                minimumValue: units.iconSizes.medium + 2*mediumSpacing
                maximumValue: 1000
                decimals: 0
                stepSize: 10
                suffix: ' px'
            }
        }
        RowLayout {
            Label {
                text: i18n("Icon:")
            }

            IconPicker {
                currentIcon: cfg_icon
                defaultIcon: "folder-open"
                onIconChanged: cfg_icon = iconName
                enabled: true
            }
        }
    }
}

