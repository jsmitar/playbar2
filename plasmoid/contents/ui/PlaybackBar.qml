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

PlaybackItem{
	id: playbackbar

	property bool flatButtons: plasmoid.configuration.FlatButtons

	visible: mpris2.sourceActive

	width: visible ? childrenRect.width : 0

	height: visible ? childrenRect.height : 0

	onPlayingChanged: {
		if(!model.itemAt(1)) return

		if(playing)
			model.itemAt(1).iconSource = "media-playback-pause"
		else
			model.itemAt(1).iconSource = "media-playback-start"
	}

	ListModel{
		id: playmodel

		ListElement{
			icon: "media-skip-backward"
		}
		ListElement{
			icon: "media-playback-start"
		}
		ListElement{
			icon: "media-playback-stop"
		}
		ListElement{
			icon: "media-skip-forward"
		}

	}

	Component{
		id: toolButtonDelegate

		PlasmaComponents.ToolButton{
			iconSource: icon
			layer.smooth: true
			visible: index == 2 ? showStop : true
			width: buttonSize
			height: buttonSize
		}
	}

	Component{
		id: iconWidgetDelegate

		IconWidget{
			svg: PlasmaCore.Svg{ imagePath: "icons/media" }
			iconSource: icon
			visible: !(index == 2) | showStop
			enabled: mpris2.sourceActive
			size: buttonSize
		}
	}

	Flow {
		id: buttons

		flow: vertical ? Flow.TopToBottom : Flow.LeftToRight
		spacing: 0

		move: Transition {
			NumberAnimation {
				property: "y"
				easing.type: Easing.Linear
				duration: units.longDuration
			}
		}

		Repeater{
			id: model
			model: playmodel
			delegate: flatButtons ? iconWidgetDelegate : toolButtonDelegate

			onItemAdded: {
				switch(index){
					case 0:
						item.clicked.connect(previous)
						break
					case 1:
						item.clicked.connect(playPause)
						//NOTE: update icon playing state
						playingChanged()
						break
					case 2:
						item.clicked.connect(stop)
						break
					case 3:
						item.clicked.connect(next)
						break
				}
			}
		}
	}

	MouseArea{
		id: volumeWheelArea
		acceptedButtons: Qt.XButton1 | Qt.XButton2
		z: 99
		anchors.fill: buttons

		//HACK: Update volume when has occurred a change, and make more fluid the volume changes
		property real volumePrevious: mpris2.volume
		Connections{
			target: mpris2
			onVolumeChanged: volumeWheelArea.volumePrevious = mpris2.volume
		}

		onWheel: {
			wheel.accepted = true
			if(wheel.modifiers == Qt.NoModifier){
				if(wheel.angleDelta.y > 40)
					volumePrevious = mpris2.setVolume(volumePrevious + 0.05)
				else if(wheel.angleDelta.y < -40)
					volumePrevious = mpris2.setVolume(volumePrevious - 0.05)
			}
		}
	}
}
