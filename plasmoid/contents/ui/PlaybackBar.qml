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

PlaybackItem {
	id: playbackbar

	property int buttonsAppearance: playbarEngine.buttonsAppearance

	visible: mpris2.sourceActive && ( playbarEngine.compactStyle === playbar.playbackButtons )

	enabled: visible

	width: visible ? controls.width : 0

	height: visible ? controls.height : 0

	onPlayingChanged: {
		if ( !model.itemAt( 1 ) ) return

		if ( playing )
			model.itemAt( 1 ).iconSource = 'media-playback-pause'
		else
			model.itemAt( 1 ).iconSource = 'media-playback-start'
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
		id: toolButtonDelegate

		PlasmaComponents.ToolButton {
			iconSource: icon
			layer.smooth: true
			visible: index == 2 ? showStop : true
			width: buttonSize
			height: buttonSize
		}
	}

	Component {
		id: iconWidgetDelegate

		IconWidget {
			svg: PlasmaCore.Svg { imagePath: 'icons/media' }
			iconSource: icon
			visible: !( index === 2 ) | showStop
			enabled: mpris2.sourceActive
			size: buttonSize
		}
	}

	Flow {
		id: controls

		flow: vertical ? Flow.TopToBottom : Flow.LeftToRight
		spacing: 0
		anchors.centerIn: parent

		move: Transition {
			NumberAnimation {
				property: 'y'
				easing.type: Easing.Linear
				duration: units.longDuration
			}
		}


		Repeater {
			id: model

			model: playmodel
			delegate: buttonsAppearance ? toolButtonDelegate : iconWidgetDelegate

			onItemAdded: {
				switch ( index ) {
					case 0:
						item.clicked.connect( previous )
						break
					case 1:
						item.clicked.connect( playPause )
						//NOTE: update icon playing state
						playingChanged()
						break
					case 2:
						item.clicked.connect( stop )
						break
					case 3:
						item.clicked.connect( next )
						break
				}
			}
		}
	}
}
