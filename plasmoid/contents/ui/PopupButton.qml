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
import org.kde.plasma.plasmoid 2.0

IconWidget{
	id: iconPopup

	property bool opened: false

	svg: svgSource.arrows

	iconSource: "down-arrow"

	QtObject{
		id: svgSource
		readonly property var arrows: PlasmaCore.Svg{ imagePath: "widgets/arrows" }
		readonly property var media: PlasmaCore.Svg{ imagePath: "icons/media" }
		function playbackIcon(){
			var icon
			if(mpris2.playbackStatus == "Playing")
				icon = "media-playback-start"
			else if(mpris2.playbackStatus == "Paused")
				icon = "media-playback-pause"
			else
				icon = "media-playback-start"
			return icon
		}
	}

	state: "default"

	rotation: opened & mpris2.sourceActive ? 180: 0

	Behavior on rotation{
		RotationAnimator{
			direction: opened ? RotationAnimation.Clockwise : RotationAnimation.Counterclockwise
			duration: units.longDuration
		}
	}

	states: [
	State{
		when: !mpris2.sourceActive || !playbackBarVisible
		PropertyChanges{
			target: iconPopup
			svg: svgSource.media
			iconSource: svgSource.playbackIcon()
			rotation: 0
		}
	},
	State{
		name: "default"
		when: plasmoid.location == PlasmaCore.Types.TopEdge
		PropertyChanges{
			target: iconPopup
			iconSource: "down-arrow"
		}
	},
	State{
		when: plasmoid.location == PlasmaCore.Types.BottomEdge
		PropertyChanges{
			target: iconPopup
			iconSource: "up-arrow"
		}
	},
	State{
		when: plasmoid.location == PlasmaCore.Types.LeftEdge
		PropertyChanges{
			target: iconPopup
			iconSource: "right-arrow"
		}
	},
	State{
		when: plasmoid.location == PlasmaCore.Types.RightEdge
		PropertyChanges{
			target: iconPopup
			iconSource: "left-arrow"
		}
	}
	]
}
