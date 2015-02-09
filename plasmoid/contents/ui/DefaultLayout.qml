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
	width: 330

	Layout.fillHeight: false
	Layout.fillWidth: true
	Layout.minimumHeight: implicitHeight
	Layout.minimumWidth: 330

	TitleBar{
		Layout.columnSpan: 2
		Layout.minimumHeight: implicitHeight
	}
	RowLayout{
		spacing: units.largeSpacing
		Layout.fillHeight: true
		CoverArt{
			id: cover
			Layout.preferredWidth: height
			Layout.preferredHeight: units.iconSizes.huge * 1.5
			focus: true
		}
		ColumnLayout{
			Layout.fillWidth: true
			Layout.alignment: Qt.AlignTop

			TrackInfo{
				Layout.alignment: Qt.AlignTop
				Layout.fillWidth: true
				Behavior on width{
					NumberAnimation{
						duration: units.shortDuration
					}
				}
			}
			PlaybackWidget{
				Layout.fillWidth: true
				Layout.fillHeight: false
				Layout.alignment: Qt.AlignBottom | Qt.AlignLeft
			}
		}
	}
// 	RowLayout{
// 		Layout.fillWidth: true
// 		Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter


		VolumeSlider{
			Layout.fillWidth: true
			Layout.fillHeight: true
			Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
			Layout.minimumHeight: implicitHeight + units.smallSpacing
		}
// 	}

	SliderSeek{
		Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
		Layout.fillWidth: true
		Layout.minimumHeight: implicitHeight + units.smallSpacing
	}
}
