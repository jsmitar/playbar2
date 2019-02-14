/*
*   Author: audoban <audoban@openmailbox.org>
*
*   This program is free software; you can redistribute it and/or modify
*   it under the terms of the GNU Library General Public License as
*   published by the Free Software Foundation; either version 3 or
*   (at your option) any later version.
*
*   This program is distributed in the hope that it will be useful,
*   but WITHOUT ANY WARRANTY; without even the implied warranty of
*   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*   GNU General Public License for more details
*
*   You should have received a copy of the GNU Library General Public
*   License along with this program; if not, write to the
*   Free Software Foundation, Inc.,
*   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
*/
import QtQuick 2.7
import QtQuick.Layouts 1.2
import org.kde.plasma.components 2.0 as PlasmaComponents

RowLayout {
    id: sliderVolume

    property alias labelVisible: label.visible

    property alias iconVisible: icon.visible

    spacing: units.smallSpacing

    enabled: mpris2.sourceActive

    visible: playbarEngine.showVolumeSlider

    Layout.minimumHeight: implicitHeight + units.smallSpacing
    Layout.fillWidth: true

    //TODO: Add a vertical Layout
    // 	property alias orientation: slider.orientation
    // 	property bool labelAbove: true
    property int maxLabelWidth: Math.max(icon.width, label.Layout.minimumWidth)

    Item {
        width: maxLabelWidth
        height: implicitHeight

        Layout.minimumWidth: units.largeSpacing * 2.2
        Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter

        VolumeIcon {
            id: icon
            volume: slider.value
            anchors.centerIn: parent
        }
    }

    PlasmaComponents.Slider {
        id: slider

        value: mpris2.volume
        maximumValue: enabled ? 1.0 : 0
        stepSize: 0.01
        activeFocusOnPress: false
        updateValueWhileDragging: true

        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.minimumWidth: 100

        onValueChanged: {
            if (value.toFixed(2) != mpris2.volume.toFixed(2))
                mpris2.setVolume(value)
        }

        onPressedChanged: {
            if (!pressed && value.toFixed(2) != mpris2.volume.toFixed(2))
                mpris2.setVolume(value)
        }

        Connections {
            target: mpris2
            onVolumeChanged: {
                if (!slider.pressed)
                    slider.value = mpris2.volume
            }
        }
    }

    VolumeLabel {
        id: label

        volume: slider.value
        horizontalAlignment: Text.AlignHCenter

        Layout.minimumWidth: units.largeSpacing * 2.2
        Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
    }
}
