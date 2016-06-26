/*
 *   Author: audoban <audoban@openmailbox.org>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU Library General Public License as
 *   published by the Free Software Foundation; either version 2 or
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

import QtQuick 2.4
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.plasmoid 2.0

PlaybackItem {
        id: seekBar

        property int buttonsAppearance: playbarEngine.buttonsAppearance

	visible: mpris2.sourceActive && ( playbarEngine.compactStyle === playbar.seekBar )

        enabled: visible

        width: visible ? control.width : 0

        height: visible ? control.height : 0

        Component {
                id: toolButtonDelegate

                PlasmaComponents.ToolButton {
                        iconSource: 'media-playback-start'
                        layer.smooth: true
                        width: buttonSize
                        height: buttonSize
                        onClicked: seekBar.playPause()
                }
        }

        Component {
                id: iconWidgetDelegate

                IconWidget {
                        svg: PlasmaCore.Svg { imagePath: 'icons/media' }
                        iconSource: 'media-playback-start'
                        enabled: mpris2.sourceActive
                        size: buttonSize
                        onClicked: seekBar.playPause()
                }
        }

        onPlayingChanged: {
                if ( buttonLoader.status !== Loader.Ready ) return

                if ( playing )
                        buttonLoader.item.iconSource = 'media-playback-pause'
                else
                        buttonLoader.item.iconSource = 'media-playback-start'
        }

        Flow {
                id: control

                flow: vertical ? Flow.TopToBottom : Flow.LeftToRight
                spacing: units.smallSpacing

                Loader {
                        id: buttonLoader
                        sourceComponent: buttonsAppearance === playbar.flat
                                ? iconWidgetDelegate : toolButtonDelegate
                        onLoaded: {
                                seekBar.playingChanged()
                        }
                        VolumeWheel {
                                anchors.fill: parent
                        }
                }

                PlasmaComponents.Slider {
                        id: slider

                        orientation: vertical ? Qt.Vertical : Qt.Horizontal
                        activeFocusOnPress: false
                        maximumValue: mpris2.length
                        value: 0
                        stepSize: 100
                        updateValueWhileDragging: true

                        width: vertical ? buttonSize : 100
                        height: vertical ? 100 : buttonSize
                        enabled: maximumValue != 0

                        onPressedChanged: {
                                if ( !pressed && value !== mpris2.position )
                                        mpris2.seek( value )
                        }

                        onValueChanged: {
                                if ( pressed )
                                        mpris2.waitGetPosition()
                        }

                        Connections {
                                target: mpris2
                                onPositionChanged: {
                                        if ( !slider.pressed )
                                                slider.value = mpris2.position
                                }
                        }

                        MouseArea {
                                id: wheelArea
                                acceptedButtons: Qt.NoButton
                                hoverEnabled: false
                                anchors.fill: parent
                                onWheel: {
                                        if ( wheel.angleDelta.y > 50 )
                                                slider.value = mpris2.seek( slider.value + 1000 )
                                        else if ( wheel.angleDelta.y < -50 )
                                                slider.value = mpris2.seek( slider.value - 1000 )
                                        else return
                                }
                        }

        // 		Colorize {
        //                         enabled: playbarEngine.backgroundHint === playbar.customColors
        //                         visible: enabled
        //                         anchors.fill: slider
        //                         source: slider
        //                         property var frontColor: Utils.rgbToHsl(playbarEngine.frontColor)
        //                         hue: frontColor.h
        //                         saturation: frontColor.s
        //                         lightness: frontColor.l
        //                 }
                }
        }
}
