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
import QtQuick.Layouts 1.1

Rectangle{
	id: bg

	width: units.iconSizes.enormous
	height: units.iconSizes.enormous
	visible: cover.visible
	color: theme.complementaryBackgroundColor
	radius: 2
	border{
		width: 2
		color: color
	}

	Layout.minimumWidth: units.iconSizes.huge
	Layout.minimumHeight: units.iconSizes.huge
	Layout.preferredWidth : units.iconSizes.enormous
	Layout.preferredHeight: units.iconSizes.enormous
	Layout.maximumWidth: height
	Layout.maximumHeight: units.iconSizes.enormous
	Layout.fillHeight: true
	Layout.fillWidth: false

	Image{
		id: cover

		source: mpris2.artUrl
		fillMode: Image.PreserveAspectFit
		visible: status == Image.Ready ? true : false
		anchors.centerIn: parent

		width: parent.width - 2
		height: parent.height - 2

		sourceSize.width: units.iconSizes.enormous - 2
		sourceSize.height: units.iconSizes.enormous - 2

		horizontalAlignment: Image.AlignHCenter
		verticalAlignment: Image.AlignVCenter

		onStatusChanged: {
			coverArt.visible = status == Image.Ready
			if(status == Image.Error)
				debug("Err on CoverArt: " +mpris2.artUrl)
		}
	}
}
