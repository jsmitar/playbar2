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

//###########
// DefaultLayout
//###########
ColumnLayout{
	id: page

	spacing: units.smallSpacing
	width: 350
	height: implicitHeight

	Layout.fillHeight: true
	Layout.fillWidth: true
	Layout.minimumWidth: 350
	Layout.minimumHeight: implicitHeight

	TitleBar{
		Layout.columnSpan: 2
		Layout.maximumHeight: implicitHeight
	}
	GridLayout{
		id: osd
		rowSpacing: units.largeSpacing
		columnSpacing: units.largeSpacing
		Layout.fillHeight: true
		Layout.maximumHeight: implicitHeight

		columns: 2
		rows: 2

		CoverArt{
			id: cover
			Layout.rowSpan: 2
			Layout.alignment: Qt.AlignLeft | Qt.AlignTop
			focus: true
		}
		TrackInfo{
			Layout.fillHeight: true
			Behavior on width{
				NumberAnimation{
					duration: units.shortDuration
				}
			}
		}
		PlaybackWidget{
			id: playback
			Layout.alignment: Qt.AlignLeft | Qt.AlignBottom
			Layout.fillHeight: true
			Layout.fillWidth: true
		}
	}

	SliderVolume{
		Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
	}
	SliderSeek{
		Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
	}
}
