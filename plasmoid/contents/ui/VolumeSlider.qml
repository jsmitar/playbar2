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
import org.kde.plasma.components 2.0 as PlasmaComponents

RowLayout{
	id: volumeSlider

	spacing: units.smallSpacing

	Layout.fillWidth: true

	property alias labelVisible: label.visible
	property alias iconVisible: icon.visible

	enabled: mpris2.sourceActive

	//TODO: Add a vertical Layout
	// 	property alias orientation: slider.orientation
	// 	property bool labelAbove: true

	property int maxLabelWidth: Math.max(icon.width, label.Layout.minimumWidth)
	Item{
		width: maxLabelWidth
		height: implicitHeight
		VolumeIcon{
			id: icon
			anchors.centerIn: parent
		}
	}

	PlasmaComponents.Slider{
		id: slider

		value: mpris2.volume
		maximumValue: enabled ? 1.0 : 0
		stepSize: 0.01
		tickmarksEnabled: false

		Layout.fillWidth: true
		Layout.minimumWidth: 80

		onValueChanged: if(pressed) mpris2.setVolume(value)
		Connections{
			target: mpris2
			onVolumeChanged: {
				if(!slider.pressed) slider.value = mpris2.volume
					wheelArea.previousValue = mpris2.volume
			}
		}
		MouseArea{
			id: wheelArea
			acceptedButtons: Qt.XButton1 | Qt.XButton2
			anchors.fill: parent

			property real previousValue: mpris2.volume

			onWheel: {
				accepted: true
				if(wheel.angleDelta.y > 100)
					previousValue = mpris2.setVolume(previousValue + 0.05)
				else if(wheel.angleDelta.y < -100)
					previousValue = mpris2.setVolume(previousValue - 0.05)
				else return
				slider.value = previousValue
			}
		}
	}

	VolumeLabel{
		id: label

		value: slider.pressed ? slider.value : mpris2.volume
		horizontalAlignment: Text.AlignHCenter

		Layout.minimumWidth: units.largeSpacing * 2.5
		Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
	}
}
