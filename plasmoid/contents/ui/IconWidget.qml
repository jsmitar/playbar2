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

import QtQuick 2.3
import org.kde.plasma.core 2.0 as PlasmaCore

PlasmaCore.SvgItem {
	id: iconWidget

	property alias iconSource: iconWidget.elementId

	property int size: units.iconSizes.medium

	implicitWidth: size

	implicitHeight: size

	smooth: true

	signal clicked()

	opacity: enabled ? 1 : 0.5

	Behavior on opacity {
		NumberAnimation { duration: units.shortDuration }
	}

	SequentialAnimation on scale{
		id: animA
		running: false
		alwaysRunToEnd: true
		NumberAnimation { to: 0.9; duration: units.shortDuration }
	}
	SequentialAnimation on scale{
		id: animB
		running: !mouseArea.pressed && scale == 0.9
		alwaysRunToEnd: true
		NumberAnimation { to: 1; duration: units.shortDuration }
	}

	MouseArea{
		id: mouseArea

		acceptedButtons: Qt.LeftButton
		anchors.fill: parent
		onPressed: animA.start()

		Component.onCompleted: clicked.connect(iconWidget.clicked)
	}
}
