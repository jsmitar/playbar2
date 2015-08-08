/*
*   Author: audoban <audoban@openmailbox.org>
*
*   This program is free software; you can redistribute it and/or modify
*   it under the terms of the GNU Library General Public License as
*   published by the Free Software Foundation; either version 2 or
*   (at your option ) any later version.
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

IconWidget {
	id: icon

	size: units.iconSizes.small

	svg: PlasmaCore.Svg { imagePath: 'icons/audio' }

	iconSource: updateIcon()

	readonly property bool muted: mpris2.volume.toPrecision( 2 ) == 0.0

	readonly property var level: [
	'audio-volume-muted',
	'audio-volume-low',
	'audio-volume-medium',
	'audio-volume-high'
	]

	property real volumePrevious: 0

	function updateIcon() {
		if ( mpris2.volume == 0 ) return level[0]
		else if ( mpris2.volume <= 0.3 ) return level[1]
		else if ( mpris2.volume <= 0.6 ) return level[2]
		else return level[3]
	}

	onClicked: {
		if ( !muted ) {
			volumePrevious = mpris2.volume
			mpris2.setVolume( 0.000001 )
		} else mpris2.setVolume( volumePrevious )
	}
}
