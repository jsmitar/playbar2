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
import QtQuick 2.6
import QtQuick.Layouts 1.2

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.plasmoid 2.0

PlaybackItem {
    id: infoBar

    visible: mpris2.sourceActive
    && (playbarEngine.compactStyle === playbar.trackinfo)

    enabled: visible

    width: visible ? control.width : 0

    height: visible ? control.height : 0

    readonly property int minWidth: Math.min(buttonSize.width, buttonSize.height)
    readonly property int maxWidth: Math.max(buttonSize.width, buttonSize.height)

    onPlayingChanged: {
        if (playing)
            button.iconSource = 'media-playback-pause'
        else
            button.iconSource = 'media-playback-start'
    }

    MediaPlayerArea {
        anchors.fill: parent
    }

    Flow {
        id: control

        flow: vertical ? Flow.TopToBottom : Flow.LeftToRight

        Item {
            width: buttonSize.width
            height: buttonSize.height

            property alias iconSource: button.iconSource

            IconWidget {
                id: button

                svg: PlasmaCore.Svg {
                    imagePath: 'icons/media'
                }
                iconSource: 'media-playback-start'
                enabled: mpris2.sourceActive

                size: Math.min(buttonSize.width, buttonSize.height)
                onClicked: infoBar.playPause()
                anchors.centerIn: parent
            }
        }

        Item {
            id: content
            width: vertical ? buttonSize.width : size
            height: vertical ? size : buttonSize.height
            clip: true

            property int size: trackinfo.text ? playbarEngine.maxWidth : 0

            Behavior on size {
                NumberAnimation {
                    duration: units.longDuration
                }
            }

            MouseArea {
                id: toggleWindow
                anchors.fill: content
                acceptedButtons: Qt.LeftButton
                onClicked: action_raise()
            }

            PlasmaComponents.Label {
                id: trackinfo

                transform: Rotation {
                    readonly property int _origin: (leftEdge ? content.size : minWidth) / 2
                    origin.x: _origin; origin.y: _origin
                    angle: vertical ? (leftEdge ? 270 : 90) : 0
                }

                width: content.size
                height: maxWidth

                text: mpris2.title && mpris2.artist ? i18n('%1 <b>By</b> %2', mpris2.title, mpris2.artist)
                        : (mpris2.title ? mpris2.title : '')

                verticalAlignment: Text.AlignVCenter
                wrapMode: scroll.scrolling ? Text.NoWrap : Text.WrapAnywhere
                elide: scroll.scrolling ? Text.ElideNone : Text.ElideRight
                maximumLineCount: 1
                lineHeight: 1.1

                AutoscrollText {
                    id: scroll
                    target: trackinfo
                    anchors.fill: target
                    autoScroll: true
                    velocity: 30
                    vertical: root.vertical
                    reverse: root.leftEdge
                }
            }
        }
    }
}
