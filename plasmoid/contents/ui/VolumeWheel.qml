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
import "../code/utils.js" as Utils

MouseArea{
	id: volumeWheelArea
	acceptedButtons: Qt.XButton1 | Qt.XButton2
	z: 99

	//HACK: Update volume when has occurred a change, and make more fluid the volume changes
	property real volumePrevious: mpris2.volume
	Connections{
		target: mpris2
		onVolumeChanged: volumeWheelArea.volumePrevious = mpris2.volume
	}

	onWheel: {
		wheel.accepted = true
		if(wheel.modifiers == Qt.NoModifier){
			if(wheel.angleDelta.y > 80){
				volumePrevious = volumePrevious.toPrecision(3) - volumePrevious.toPrecision(3) % 0.05
				volumePrevious = mpris2.setVolume(volumePrevious + 0.058).toPrecision(3)
			}else if(wheel.angleDelta.y < -80){
				volumePrevious = volumePrevious.toPrecision(3) - volumePrevious.toPrecision(3) % 0.05
				volumePrevious = mpris2.setVolume(volumePrevious - 0.05).toPrecision(3)
			}
		}
	}
}
