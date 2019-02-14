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

PlaybackItem {
    id: playbackbar

    visible: mpris2.sourceActive && (playbarEngine.compactStyle === playbar.playbackButtons)

    enabled: visible

    width: visible ? controls.width : 0

    height: visible ? controls.height : 0

    MediaPlayerArea {
        anchors.fill: parent
    }

    ListModel {
        id: playmodel

        ListElement {
            icon: 'media-skip-backward'
        }
        ListElement {
            icon: 'media-playback-start'
        }
        ListElement {
            icon: 'media-playback-stop'
        }
        ListElement {
            icon: 'media-skip-forward'
        }
    }

    Component {
        id: iconWidgetDelegate

        Item {
            width: buttonSize.width
            height: buttonSize.height
            visible: !(index === 2) | showStop

            IconWidget {
                id: button
                svg: PlasmaCore.Svg {
                    imagePath: 'icons/media'
                }
                iconSource: icon
                enabled: mpris2.sourceActive

                size: Math.min(buttonSize.width, buttonSize.height)
                anchors.centerIn: parent
            }
        }
    }

    Flow {
        id: controls

        flow: vertical ? Flow.TopToBottom : Flow.LeftToRight
        spacing: 0

        move: Transition {
            NumberAnimation {
                property: vertical ? 'y' : 'x'
                easing.type: Easing.Linear
                duration: units.longDuration
            }
        }

        Repeater {
            id: model

            model: playmodel
            delegate: iconWidgetDelegate

            onItemAdded: {
                switch (index) {
                case 0:
                    item.children[0].clicked.connect(mpris2.previous)
                    item.children[0].enabled = Qt.binding(function () { return mpris2.canGoPrevious })
                    break
                case 1:
                    item.children[0].clicked.connect(mpris2.playPause)
                    item.children[0].enabled = Qt.binding(function () { return mpris2.canPlayPause })
                    item.children[0].iconSource = Qt.binding(function() {
                        return mpris2.playing ? 'media-playback-pause'
                                              : 'media-playback-start'
                    })
                    //NOTE: update icon playing state
                    break
                case 2:
                    item.children[0].clicked.connect(mpris2.stop)
                    item.children[0].enabled = Qt.binding(function () { return mpris2.canControl })
                    break
                case 3:
                    item.children[0].clicked.connect(mpris2.next)
                    item.children[0].enabled = Qt.binding(function () { return mpris2.canGoNext })
                    break
                }
            }
        }
    }
}
