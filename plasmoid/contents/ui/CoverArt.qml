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
import org.kde.plasma.components 2.0  as PlasmaComponents
import org.kde.plasma.core 2.0 as PlasmaCore


Item{
	id: coverArt

	property int size: units.iconSizes.enormous

	width: bg.width

	height: bg.height

	visible: false

	Rectangle{
		id: bg

		width: size + 4
		height: size + 4
		color: theme.complementaryBackgroundColor

		Image{
			id: cover

			source: mpris2.artUrl
			fillMode: Image.PreserveAspectFit
			visible: status == Image.Ready ? true : false
			cache: true
			asynchronous: true
			anchors{
				centerIn: parent
			}

			sourceSize.width: size
			sourceSize.height: size

			horizontalAlignment: Image.AlignHCenter
			verticalAlignment: Image.AlignVCenter

			onStatusChanged: {
				coverArt.visible = status == Image.Ready
				if(status == Image.Error)
					debug("Err on CoverArt: " +mpris2.artUrl)
			}
		}

	}
}
