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
import QtQuick.Layouts 1.1

Flow {
	id: playbackControl

	spacing: units.smallSpacing / 2
	flow: vertical ? Flow.TopToBottom : Flow.LeftToRight
	anchors.fill: parent

	Layout.minimumWidth: !vertical && loaded
                ? loader.item.width  + loader.item.buttonSize + spacing
                : units.iconSizes.small
	Layout.minimumHeight: vertical && loaded
                ? loader.item.height + loader.item.buttonSize + spacing
                : units.iconSizes.small

	property int _buttonSize: vertical
                ? ( parent && parent.width ? parent.width : 0 )
                : ( parent && parent.height ? parent.height : 0 )

	property bool loaded: loader.status === Loader.Ready

	VolumeWheel {
		id: volumeWheelArea

		parent: loaded && playbarEngine.compactStyle !== playbar.seekBar
                        ? loader.item : popupContainer
		anchors.fill: parent
	}

	Loader {
                id: loader

                width:  loader.status === Loader.Ready ? item.width : 0
                height:  loader.status === Loader.Ready ? item.height : 0

                sourceComponent: {
                        switch ( playbarEngine.compactStyle ) {
                        case playbar.playbackButtons:
                                return Qt.createComponent( 'PlaybackBar.qml' )
                        case playbar.seekBar:
                                return Qt.createComponent( 'SeekBar.qml' )
                        }
                        return null
                }

                onLoaded: {
                        item.buttonSize = Qt.binding(
                        function() { return playbackControl._buttonSize } )
                }
        }

	Item {
		id: popupContainer
		width: _buttonSize
		height: _buttonSize

		VolumeWheel { anchors.fill: parent }

		PopupButton {
			id: popup

                        controlsVisible: loaded && loader.item.visible

			size: loaded && loader.item.visible
                                ? _buttonSize * ( playbarEngine.buttonsAppearance !== 0 ? 0.5 : 0.7 )
                                : _buttonSize
			anchors.centerIn: parent
			opened: plasmoid.expanded

			onClicked: {
                                if ( mpris2.sourceActive )
				plasmoid.expanded = !plasmoid.expanded
			}
		}
	}

	Timer {
		//HACK: For PopupApplet in Notification Area
		running: loaded && loader.item.visible
		interval: 100
		onTriggered: {
			if ( ( !vertical && loader.item.width > playbackControl.width ) ||
				( vertical && loader.item.height > playbackControl.height ) ) {
				loader.item.visible = false
			}
		}
	}


}
