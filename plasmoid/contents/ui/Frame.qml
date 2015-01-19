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

Rectangle{
	id: frame

	property string bg: theme.highlightColor
	color: bg
	radius: 1
	smooth: true

	property alias containsMouse: mouseArea.containsMouse

	Component.onCompleted:{
		mouseArea.entered.connect(entered)
		mouseArea.exited.connect(exited)
	}

	signal entered()

	signal exited()

	function fadeIn(){ fadeInAnimation.start() }

	function fadeOut(){ fadeOutAnimation.start() }

	SequentialAnimation on opacity{
		id: fadeInAnimation
		running: false
		NumberAnimation { to: 0.8 ; duration: 150 }
	}

	SequentialAnimation on opacity{
		id: fadeOutAnimation
		running: true
		NumberAnimation { to: 0.01 ; duration: 300 }
	}

	MouseArea{
		id: mouseArea

		hoverEnabled: true
		acceptedButtons: Qt.NoButton
		anchors.fill: parent
	}

}
