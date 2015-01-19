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
import "plasmapackage:/code/control.js" as Control

Item{
	id: notification

	property int maximumWidth: 0

	property int minimumWidth: 0

	property int duration: 600

	property int value: 0

	property int horizontalOffset: 0

	property int verticalOffset: 0

	enabled: true

	opacity: 0

	rotation: vertical ? 90 : 0

	anchors{
		horizontalCenterOffset: !vertical && frame.width < minimumWidth ? horizontalOffset : (!vertical ? 3 : 0)
		verticalCenterOffset: vertical && frame.width < minimumWidth ? verticalOffset : (vertical ? 3 : 0)
	}

	function sourceNotify(){
		if( mpris.identity.match('vlc|VLC') )
			title.text = "VLC"
		else
			title.text = mpris.identity
		fadeIn.start()
	}

	function controlBarWheelNotify(){
		title.text = parseInt(Control.currentVolume*100)+'%'
		fadeIn.restart()
	}

	SequentialAnimation on opacity{
		id: fadeIn

		NumberAnimation { to: 1 ; duration: 150 }
		PauseAnimation{ duration: 700 }
		NumberAnimation { to: 0 ; duration: 300 }
	}

	Behavior on value {
		NumberAnimation{ duration: 100 }
	}

	Component.onCompleted: {
		Control.sourceNotify = sourceNotify
		Control.controlBarWheelNotify = controlBarWheelNotify
		plasmoid.addEventListener('configChanged', function() {
			title.font.pointSize = plasmoid.readConfig('buttonSize')/2
		})
		sourceNotify()
	}

	Rectangle{
		id: frame

		color: theme.highlightColor
		radius: 2
		border{
			width: 2
			color: color
		}
		implicitWidth: title.width
 		implicitHeight: title.implicitHeight
		opacity: 0.7

		anchors{
			centerIn: parent
			horizontalCenterOffset: -1
		}
	}

	Text{
		id: title

		anchors{
			centerIn: parent
		}

		width: implicitWidth > maximumWidth ? maximumWidth - 4 : implicitWidth

		clip: true
		smooth: true

		style: Text.Raised
		styleColor: theme.backgroundColor
		color: theme.textColor
		maximumLineCount: 1

		font{
			weight: Font.DemiBold
			pointSize: plasmoid.readConfig('buttonSize')/2
		}

		Behavior on text{
			PropertyAnimation{ duration: 50 }
		}
	}

}
