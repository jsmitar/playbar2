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
import org.kde.plasma.core 2.0 as PlasmaCore
import "../code/utils.js" as Utils

Rectangle{
	id: bg

	width: units.iconSizes.enormous
	height: units.iconSizes.enormous
	color: Utils.adjustAlpha(theme.complementaryBackgroundColor, 0.3)
	radius: 2
	opacity: 0.3

	Layout.minimumWidth: height
	Layout.minimumHeight: units.iconSizes.enormous
	Layout.preferredWidth: units.iconSizes.enormous 
	Layout.preferredHeight: units.iconSizes.enormous 
	Layout.maximumWidth: height
	Layout.maximumHeight: units.iconSizes.enormous
	Layout.fillHeight: true
	Layout.fillWidth: false
	
	border{
		width: 1
		color: color
	}

	OpacityAnimator on opacity{
		id: appear
		running: false
		alwaysRunToEnd: true
		from: 0.3
		to: 1.0
		duration: units.longDuration
	}

	OpacityAnimator on opacity{
		id: fade
		running: false
		alwaysRunToEnd: true
		from: 1.0
		to: 0.3
		duration: units.longDuration
	}


	Image{
		id: cover

		source: mpris2.artUrl
		fillMode: Image.PreserveAspectFit
		anchors.centerIn: parent

		width: parent.width - 2
		height: parent.height - 2
		clip: true

		sourceSize.width: parent.width - 2
		sourceSize.height: parent.height - 2

		horizontalAlignment: Image.AlignHCenter
		verticalAlignment: Image.AlignVCenter

		onStatusChanged: {
			if( status === Image.Ready )
				appear.start()
			else if( status === Image.Null || status === Image.Error ){
				fade.start()
				debug("Fade on CoverArt", status )
			}
		}
	}
	
	PlasmaCore.IconItem {
		id: noCover
		
		anchors.centerIn: parent
		width: parent.width - 2
		height: parent.height - 2
		
		source: "tools-rip-audio-cd"
		smooth: true
		
		visible: cover.status !== Image.Ready || !mpris2.sourceActive
		
	}
	
	MouseArea{
		id: toggleWindow
		anchors.fill: parent
		acceptedButtons: Qt.LeftButton
		onClicked: action_raise()
	}
}
