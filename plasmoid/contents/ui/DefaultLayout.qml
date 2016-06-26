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
import QtGraphicalEffects 1.0

//###########
// DefaultLayout
//###########
Item {
        id: content
	objectName: 'DefaultLayout'

	signal shouldChangeLayout

	onWidthChanged: if ( width < height + units.iconSizes.medium ) shouldChangeLayout()

 	Layout.fillWidth: true
 	Layout.fillHeight: true
 	Layout.minimumWidth: units.iconSizes.enormous * 3
 	Layout.minimumHeight: page.implicitHeight
 	Layout.preferredWidth: units.iconSizes.enormous * 3
 	Layout.preferredHeight: page.implicitHeight

 	Component.onDestruction: debug( objectName, 'destructed' )

GridLayout {
	id: page

        anchors.fill: parent

 	rowSpacing: units.smallSpacing
 	columnSpacing: units.largeSpacing
 	Layout.minimumWidth: implicitHeight * 1.6
 	Layout.minimumHeight: implicitHeight
 	Layout.fillWidth: true
 	Layout.fillHeight: false

	columns: 2
	rows: 5

	TitleBar {
                id: titleBar
		Layout.row: 0
		Layout.columnSpan: 2
	}
	CoverArt {
		id: cover
		Layout.row: 1
		Layout.column: 0
 		Layout.rowSpan: 2
 		Layout.fillWidth: false
 		Layout.fillHeight: true
		Layout.alignment: Qt.AlignCenter
	}
	TrackInfo {
                id: trackInfo
		Layout.row: 1
		Layout.column: 1
 		Layout.fillWidth: true
 		Layout.fillHeight: false
		Layout.alignment: Qt.AlignLeft | Qt.AlignBottom
 		layer.enabled: true
	}
	PlaybackWidget {
		id: controls
		Layout.row: 2
		Layout.column: 1
		Layout.fillWidth: true
		Layout.fillHeight: true
		Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
	}
	SliderVolume {
                id: volume
		Layout.row: 3
		Layout.columnSpan: 2
		Layout.fillHeight: true
		Layout.alignment: Qt.AlignCenter
	}
	SliderSeek {
                id: seek
		Layout.row: 4
		Layout.columnSpan: 2
		Layout.fillHeight: false
		Layout.alignment: Qt.AlignCenter
	}

	layer.enabled: playbarEngine.backgroundHint === playbar.customColors
	layer.effect: DropShadow {
		source: page
		radius: 8.0
		fast: true
		spread: 0.3
		color: ( playbarEngine.backgroundHint === 0 )
			? playbarEngine.backgroundColor : theme.complementaryBackgroundColor
		anchors.fill: source
	}
}
}
