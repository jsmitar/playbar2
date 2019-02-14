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
    id: sliderSeek

    property int maxLabelWidth: Math.max(labelRight.Layout.minimumWidth,
                                         labelLeft.Layout.minimumWidth)

    spacing: units.smallSpacing

    visible: playbarEngine.showSeekSlider

    Layout.fillWidth: true
    Layout.minimumHeight: implicitHeight + units.smallSpacing


    states: State {
        when: mpris2.position > mpris2.length
        PropertyChanges {
            target: labelLeft
            type: 'length'
            position: 0
        }
        PropertyChanges {
            target: labelRight
            type: 'position'
            position: mpris2.position
        }
    }

    TimeLabel {
        id: labelLeft

        property bool labelSwitch: plasmoid.configuration.TimeLabelSwitch

        type: labelSwitch ? 'length' : 'position'
        position: labelSwitch ? 0 : slider.value
        interactive: true

        onClicked: plasmoid.configuration.TimeLabelSwitch = !labelSwitch

        horizontalAlignment: Text.AlignHCenter
        Layout.alignment: Qt.AlignHCenter
        Layout.minimumWidth: units.largeSpacing * (mpris2.length >= 3600 ? 2.8 : 2.2)
    }

    PlasmaComponents.Slider {
        id: slider

        maximumValue: mpris2.length
        value: mpris2.position
        stepSize: 1
        activeFocusOnPress: false
        updateValueWhileDragging: true
        enabled: mpris2.canSeek || mpris2.canControl

        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.minimumWidth: 100

        onPressedChanged: {
            if (!pressed && value !== mpris2.position)
                mpris2.seek(value)
        }

        onValueChanged: {
            if (pressed)
                mpris2.waitGetPosition()
        }

        Connections {
            target: mpris2
            onPositionChanged: {
                if (!slider.pressed)
                    slider.value = mpris2.position
            }
        }

        MouseArea {
            id: wheelArea
            acceptedButtons: Qt.NoButton
            hoverEnabled: false
            anchors.fill: parent

            onWheel: {
                wheel.accepted = true
                if (wheel.angleDelta.y > 50)
                    slider.value = mpris2.seek(slider.value + 10)
                else if (wheel.angleDelta.y < -50)
                    slider.value = mpris2.seek(slider.value - 10)
                else
                    return
            }
        }
    }

    TimeLabel {
        id: labelRight

        property bool labelSwitch: plasmoid.configuration.TimeLabelSwitch

        position: slider.value
        interactive: true
        type: labelSwitch ? 'position' : 'remaining'

        onClicked: plasmoid.configuration.TimeLabelSwitch = !labelSwitch

        horizontalAlignment: Text.AlignHCenter
        Layout.minimumWidth: units.largeSpacing * (mpris2.length >= 3600 ? 2.8 : 2.2)
        Layout.alignment: Qt.AlignHCenter
    }
}
