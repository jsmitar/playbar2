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

Flow {
    id: playbackControl

    flow: vertical ? Flow.TopToBottom : Flow.LeftToRight
    spacing: 0

    Layout.minimumWidth: !vertical ? popupIconSize + loader.width : units.iconSizes.small
    Layout.minimumHeight: vertical ? popupIconSize + loader.height : units.iconSizes.small

    readonly property int _minSize: vertical ? (parent ? parent.width : units.iconSizes.small)
                                             : (parent ? parent.height : units.iconSizes.small)

    readonly property int _iconSize:
    Math.min(units.roundToIconSize(_minSize - units.smallSpacing), units.iconSizes.large)

    readonly property size iconSize: vertical ? Qt.size(Math.max(_minSize, _iconSize), _iconSize)
                                              : Qt.size(_iconSize, Math.max(_minSize, _iconSize))

    readonly property int popupIconSize: units.roundToIconSize(loaded && loader.item.visible
            ? Math.min(units.iconSizes.smallMedium, _minSize - units.smallSpacing / 2.2)
            : units.roundToIconSize(_minSize))

    readonly property bool loaded: loader.status === Loader.Ready


    property bool containsMouse: false

    onContainsMouseChanged: {
        if (containsMouse)
            toolTip.showToolTip()
        else
            toolTip.hideToolTip()
    }

    Component.onCompleted: toolTip.visualParent = playbackControl

    onParentChanged: {
        if (parent && parent.objectName === 'org.kde.desktop-CompactApplet') {
            //! NOTE: disable the standard toolTip
            parent.active = false
            containsMouse = Qt.binding(function () { return parent.containsMouse })
        }
    }

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
                return iconSize
            })
        }
    }

    Item {
        id: popupContainer

        width: vertical ? _minSize : parent.width - loader.width
        height: vertical ? parent.height - loader.height : _minSize

        MediaPlayerArea {
            anchors.fill: parent
        }

        PopupButton {
            id: popup

            controlsVisible: loaded && loader.item.visible

            size: popupIconSize

            opened: plasmoid.expanded
            anchors.centerIn: parent
            onClicked: {
                if (mpris2.sourceActive)
                    plasmoid.expanded = !plasmoid.expanded
                else if (mpris2.recentSources.length > 0)
                    action_player0()
            }
        }
    }
}
