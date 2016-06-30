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
import org.kde.plasma.extras 2.0 as PlasmaExtras
import '../code/utils.js' as Utils

PlasmaExtras.Paragraph {
	id: time

	// seconds
	property int topTime: mpris2.length
	// seconds
	property int currentTime: mpris2.position

	property bool showPosition: true

	property bool showRemaining: true

	property bool labelSwitch: plasmoid.configuration.TimeLabelSwitch

	property alias interactive: mouseArea.hoverEnabled

	property int min: 0

	property int sec: 0

	text: '0:00'

	enabled: mpris2.sourceActive & mpris2.length > 0

	function positionUpdate( negative ) {
		if ( negative ) sec = Math.abs( ( topTime - currentTime ) )
		else sec = currentTime

		min = sec / 60
		sec = sec - min * 60

		if ( negative ) text = '-' + min + ':'
		else text = min + ':'
		text += sec < 10 ? '0' + sec : sec
	}

	function lengthUpdate() {
		sec = topTime / 10
		min = sec / 6
		sec = sec - min * 6
		text = min + ':' + ( sec < 10 ? '0' + sec : sec )
	}

	onCurrentTimeChanged: {
                if ( showPosition & showRemaining )
                        positionUpdate( labelSwitch )
                else if ( labelSwitch & showPosition )
                        positionUpdate( false )
                else if ( labelSwitch & showRemaining )
                        positionUpdate( true )
	}

	onTopTimeChanged: {
                if ( !showPosition )
                        lengthUpdate()
	}

	MouseArea {
		id: mouseArea

		anchors.fill: parent
		acceptedButtons: Qt.LeftButton
		enabled: hoverEnabled

		onEntered: color = theme.viewHoverColor
		onExited: color = theme.textColor

		onClicked: {
			if ( !exited || containsMouse ) {
				labelSwitch = !labelSwitch
				plasmoid.configuration.TimeLabelSwitch = labelSwitch
				if ( showPosition )
                                        positionUpdate( labelSwitch )
			}
		}
	}
}
