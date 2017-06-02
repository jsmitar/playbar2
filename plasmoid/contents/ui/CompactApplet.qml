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
import QtQuick.Layouts 1.2

Flow {
    id: playbackControl

    flow: vertical ? Flow.TopToBottom : Flow.LeftToRight
    spacing: 0

    Layout.minimumWidth: !vertical ? popupContainer.width + loader.width : units.iconSizes.small
    Layout.minimumHeight: vertical ? popupContainer.height + loader.height : units.iconSizes.small

    property int _buttonSize: vertical ? (parent ? parent.width : units.iconSizes.small) : (parent ? parent.height : units.iconSizes.small)

    property bool loaded: loader.status === Loader.Ready

    Loader {
        id: loader

        width: status === Loader.Ready ? item.width : 0
        height: status === Loader.Ready ? item.height : 0

        source: {
            switch (playbarEngine.compactStyle) {
            case playbar.playbackButtons:
                return 'PlaybackBar.qml'
            case playbar.seekbar:
                return 'SeekBar.qml'
            case playbar.trackinfo:
                return 'TrackInfoBar.qml'
            }
            return ''
        }

        onLoaded: {
            item.buttonSize = Qt.binding(function () {
                return playbackControl._buttonSize
            })
        }
    }

    Item {
        id: popupContainer
        width: _buttonSize
        height: _buttonSize

        VolumeWheel {
            anchors.fill: parent
        }

        PopupButton {
            id: popup

            controlsVisible: loaded && loader.item.visible

            size: loaded
                  && loader.item.visible ? _buttonSize * 0.5 : _buttonSize * 0.9
            opened: plasmoid.expanded
            anchors.centerIn: parent
            onClicked: {
                if (mpris2.sourceActive)
                    plasmoid.expanded = !plasmoid.expanded
            }
        }
        Timer {
            //HACK: For PopupApplet in Systray Area
            //running: loaded && loader.item.visible
            interval: 250
            onTriggered: {
                if ((!vertical && loader.item.width > playbackControl.width)
                        || (vertical
                            && loader.item.height > playbackControl.height)) {
                    loader.item.visible = false
                    playbarEngine.systrayArea = true
                } else {
                    playbarEngine.systrayArea = false
                }
            }
        }
    }
}
