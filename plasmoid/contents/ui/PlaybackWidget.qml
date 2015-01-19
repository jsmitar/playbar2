// -*- coding: iso-8859-1 -*-
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

import QtQuick 1.1
import org.kde.plasma.core 0.1 as PlasmaCore

PlaybackItem{
    id: playbackWidget

	property int buttonSize: 26

	property alias spacing: content.spacing

	width: content.width + ( model.itemAt(2).visible ? 0 : 20 )

	height: childrenRect.height

	Component.onCompleted: {
		model.itemAt(0).clicked.connect(previous)
		model.itemAt(1).clicked.connect(playPause)
		model.itemAt(2).clicked.connect(stop)
		model.itemAt(3).clicked.connect(next)
	}

	Component.onDestruction: {
		model.itemAt(0).clicked.disconnect(previous)
		model.itemAt(1).clicked.disconnect(playPause)
		model.itemAt(2).clicked.disconnect(stop)
		model.itemAt(3).clicked.disconnect(next)
	}

	ListModel{
		id: playmodel
		ListElement{
			idIcon: "media-skip-backward"
		}
		ListElement{
			idIcon: "media-playback-start"
		}
		ListElement{
			idIcon: "media-playback-stop"
		}
		ListElement{
			idIcon: "media-skip-forward"
		}
	}

	Component{
		id: buttonDelegate

		IconWidget{

			svg: update()
			iconSource: idIcon
			size: buttonSize

			anchors.verticalCenter: parent.verticalCenter

			visible: index == 2 ? showStop : true

			// DEPRECATED
			Component.onCompleted: {
				plasmoid.addEventListener('configChanged', function(){svg = update()} )
			}
		}
	}

	Row{
		id: content
		spacing: 5
		anchors.horizontalCenter: parent.horizontalCenter

		states:[
			State{
				name: "Playing"
				when: playing
				PropertyChanges{
					target: model.itemAt(1)
					elementId: "media-playback-pause"
				}
			}
		]

		Repeater{
			id: model
			model: playmodel
			delegate: buttonDelegate
		}
	}
}
