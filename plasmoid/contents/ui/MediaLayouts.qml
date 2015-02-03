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

Item{
	id: layouts

	resources: [defaultLayout]

	//###########
	// DefaultLayout
	//###########
	Component{
		id: defaultLayout

		ColumnLayout{
			id: page

			spacing: units.smallSpacing
			width: 330

			Layout.fillHeight: false
			Layout.fillWidth: true
			Layout.minimumHeight: implicitHeight

			TitleBar{
				Layout.columnSpan: 2
				Layout.minimumHeight: implicitHeight
			}
			RowLayout{
				spacing: units.largeSpacing
				Layout.columnSpan: 2
				CoverArt{
					Layout.preferredWidth: height
					Layout.preferredHeight: units.iconSizes.huge * 1.5
					focus: true
				}
				TrackInfo{
					Layout.alignment: Qt.AlignTop
					Layout.fillWidth: true
					Behavior on width{
						NumberAnimation{
							duration: units.shortDuration
						}
					}
				}
			}
			RowLayout{
				PlaybackWidget{
					Layout.fillWidth: false
					Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
				}
				VolumeSlider{
					Layout.fillWidth: true
					Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
					Layout.minimumHeight: implicitHeight + units.smallSpacing
				}
			}
			SliderSeek{
				Layout.columnSpan: 2
				Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
				Layout.fillWidth: true
				Layout.minimumHeight: implicitHeight + units.smallSpacing
			}
		}
	}
}
