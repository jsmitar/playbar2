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
import org.kde.plasma.core 2.0 as PlasmaCore


GridLayout{
	id: page

	Layout.minimumWidth: implicitWidth
	Layout.minimumHeight: implicitHeight

	//Layout.maximumWidth: implicitWidth
	//Layout.maximumHeight: implicitHeight

	Layout.preferredWidth: implicitWidth
	Layout.preferredHeight: implicitHeight

	Layout.fillWidth: true
	Layout.fillHeight: true

	rowSpacing: units.smallSpacing
	columnSpacing: units.largeSpacing
	columns: 2

// 	onWidthChanged: debug("size: "+implicitWidth+"x"+implicitHeight)

	TitleBar{
		Layout.columnSpan: 2
		Layout.fillHeight: false
		Layout.maximumWidth: implicitWidth
		Layout.maximumHeight: implicitHeight
		Layout.preferredWidth : implicitWidth
		Layout.preferredHeight: implicitHeight
	}

	CoverArt{
		id: coverArt

		Layout.alignment: Qt.AlignTop

	}
	TrackInfo{
		Layout.alignment: Qt.AlignTop
		Layout.fillHeight: true
		Layout.fillWidth: true
		Layout.minimumWidth: units.iconSizes.huge
		Layout.minimumHeight: units.iconSizes.huge
	}

}
