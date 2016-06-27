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
// VerticalLayout
//###########
Item {
        id: content
	objectName: 'VerticalLayout'

	signal shouldChangeLayout

	onWidthChanged: if ( height + units.iconSizes.medium < width ) shouldChangeLayout()

 	Layout.fillWidth: true
 	Layout.fillHeight: true
        Layout.minimumWidth: Math.max( units.iconSizes.enormous * 1.6, cover.height )
 	Layout.minimumHeight: page.implicitHeight
 	Layout.preferredWidth: units.iconSizes.enormous * 1.6

 	Component.onDestruction: debug( objectName, 'destructed' )

ColumnLayout {
	id: page

        anchors.fill: parent

 	spacing: units.smallSpacing
 	Layout.minimumWidth: implicitWidth
 	Layout.minimumHeight: implicitHeight
 	Layout.fillWidth: true
 	Layout.fillHeight: true

	TitleBar {
                id: titleBar
	}
	CoverArt {
		id: cover
		Layout.alignment: Qt.AlignCenter
		Layout.fillWidth: false
	}
        TrackInfo {
                id: trackInfo
 		Layout.fillHeight: false
 		Layout.fillWidth: true
                Layout.minimumWidth: units.iconSizes.enormous
 		layer.enabled: true
	}
	PlaybackWidget {
		id: controls
		Layout.fillWidth: false
		Layout.fillHeight: false
		buttonSize: units.iconSizes.medium
		Layout.alignment: Qt.AlignCenter
	}
	SliderVolume {
                id: volume
 		Layout.fillHeight: false
		Layout.alignment: Qt.AlignCenter
	}
	SliderSeek {
                id: seek
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
