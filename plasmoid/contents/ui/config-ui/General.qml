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
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.0


Item {
	id: general
	width: childrenRect.width
	height: childrenRect.height
	implicitWidth: pageColumn.implicitWidth
	implicitHeight: pageColumn.implicitHeight

	property alias cfg_FlatButtons: cfg1.checked
	property alias cfg_ShowStop: cfg2.checked
	property int cfg_ButtonSize: 22

	Column {
		id: pageColumn
		anchors.fill: parent
		spacing: units.smallSpacing

		CheckBox{
			id: cfg1
			text: i18n("Flat buttons")
		}
		CheckBox{
			id: cfg2
			text: i18n("Show stop")
		}
// 		RowLayout {
// 			spacing: units.largeSpacing
//
// 			Label{
// 				text: i18n("Size of the buttons:")
// 				Layout.alignment: Qt.AlignVCenter
// 			}
//
// 			SpinBox{
// 				id: cfg3
//
// 				value: units.iconSizes.medium
// 				suffix: i18n(" pixels")
// 				minimumValue: 18
// 				maximumValue: 128
// 			}
// 		}
	}
}
