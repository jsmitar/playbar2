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
import org.kde.plasma.core 2.0 as PlasmaCore

//###########
// DefaultLayout
//###########

Item {
	readonly property double num_aureo: 1.618033988749895

 	Layout.fillHeight: true
 	Layout.fillWidth: true
 	Layout.minimumWidth: page.implicitHeight * num_aureo
 	Layout.minimumHeight: page.implicitHeight
 	Layout.preferredWidth: page.implicitHeight * num_aureo
 	Layout.preferredHeight: page.implicitHeight


GridLayout {
	id: page
	width: parent.width
	height: parent.height

 	rowSpacing: units.smallSpacing
 	columnSpacing: units.largeSpacing
 	Layout.minimumWidth: implicitHeight * num_aureo
 	Layout.minimumHeight: implicitHeight
 	Layout.maximumHeight: implicitHeight
 	Layout.fillWidth: true
 	Layout.fillHeight: false

	columns: 2
	rows: 5

	TitleBar {
		Layout.row: 0
		Layout.columnSpan: 2
	}
	CoverArt {
		id: cover
		Layout.row: 1
 		Layout.rowSpan: 2
		Layout.alignment: Qt.AlignLeft | Qt.AlignTop
		focus: true
	}
	TrackInfo {
		Layout.row: 1
		Layout.column: 1
 		Layout.fillHeight: false
 		layer.enabled: true
	}
	PlaybackWidget {
		id: playback
		Layout.row: 2
		Layout.column: 1
		Layout.alignment: Qt.AlignLeft | Qt.AlignTop
	}
	SliderVolume {
		Layout.row: 3
		Layout.columnSpan: 2
		Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
	}
	SliderSeek {
		Layout.row: 4
		Layout.columnSpan: 2
		Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
	}

	layer.enabled: playbarEngine.backgroundHint === 0 && plasmoid.formFactor === PlasmaCore.Types.Planar
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
