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
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

PlaybackItem {
    id: seekBar

    visible: mpris2.sourceActive && (playbarEngine.compactStyle === playbar.seekbar)

    enabled: visible

    width: visible ? control.width : 0

    height: visible ? control.height : 0

    readonly property int minWidth: Math.min(buttonSize.width, buttonSize.height)

    Flow {
        id: control

        flow: vertical ? Flow.TopToBottom : Flow.LeftToRight
        spacing: 0

        Item {
            width: buttonSize.width
            height: buttonSize.height

            IconWidget {
                id: button

                svg: PlasmaCore.Svg {
                    imagePath: 'icons/media'
                }
                iconSource: mpris2.playing ? 'media-playback-pause' : 'media-playback-start'
                enabled: mpris2.sourceActive

                size: minWidth
                onClicked: mpris2.playPause()
                anchors.centerIn: parent
            }

            MediaPlayerArea {
                anchors.fill: parent
            }
        }

        PlasmaComponents.Slider {
            id: slider

            orientation: vertical ? Qt.Vertical : Qt.Horizontal
            activeFocusOnPress: false
            maximumValue: mpris2.length
            value: 0
            stepSize: 1
            updateValueWhileDragging: true
            visible: mpris2.playbackStatus !== 'Stopped' && slider.enabled
            property int size: mpris2.playbackStatus === 'Stopped' || !slider.enabled ? 40 : playbarEngine.maxWidth

            Behavior on size {
                SequentialAnimation {
                    id: anim
                    PauseAnimation {
                        duration: 400
                    }
                    ScriptAction {
                        script: setVisible()
                        function setVisible() {
                            if (mpris2.playbackStatus !== 'Stopped' && slider.enabled)
                                slider.visible = true
                        }
                    }
                    NumberAnimation {
                        duration: units.longDuration
                    }
                    ScriptAction {
                        script: setNotVisible()
                        function setNotVisible() {
                            if (mpris2.playbackStatus === 'Stopped' || slider.size <= 50 || !slider.enabled)
                                slider.visible = false
                        }
                    }
                }
            }

            width: vertical ? buttonSize.width : size
            height: vertical ? size : buttonSize.height
            enabled: maximumValue != 0

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
    }
}
