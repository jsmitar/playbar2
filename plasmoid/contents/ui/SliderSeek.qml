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

	spacing: units.smallSpacing

	Layout.fillWidth: true
	Layout.fillHeight: true
	Layout.minimumHeight: implicitHeight + units.smallSpacing * 2

	property int maxLabelWidth: Math.max(labelRight.Layout.minimumWidth, labelLeft.Layout.minimumWidth)

	TimeLabel{
		id: labelLeft
		currentTime: slider.value
		interactive: false
		horizontalAlignment: Text.AlignHCenter

		Layout.minimumWidth: units.largeSpacing * 2.5
	}

	PlasmaComponents.Slider{
		id: slider

		activeFocusOnPress: false
		maximumValue: mpris2.length
		value: 0
		stepSize: 100
		enabled: maximumValue != 0
		onValueChanged: if(pressed) mpris2.seek(value)

		Layout.fillWidth: true
		Layout.fillHeight: true
		Connections{
			target: mpris2
			onPositionChanged: {
				if(!slider.pressed) slider.value = mpris2.position
				wheelArea.previousValue = mpris2.position
			}
		}
		MouseArea{
			id: wheelArea
			acceptedButtons: Qt.XButton1 | Qt.XButton2
			anchors.fill: parent

			property int previousValue: mpris2.position

			onWheel: {
				accepted: true
				if(wheel.angleDelta.y > 50)
					previousValue = mpris2.seek(previousValue + 500)
				else if(wheel.angleDelta.y < -50)
					previousValue = mpris2.seek(previousValue - 500)
				else return
				slider.value = previousValue
			}
		}
	}

	TimeLabel{
		id: labelRight
		currentTime: slider.value
		interactive: true
		showRemaining: true
		showPosition: false
		labelSwitch: plasmoid.configuration.TimeLabelSwitch
		horizontalAlignment: Text.AlignHCenter

		Layout.minimumWidth: units.largeSpacing * 2.5
		Layout.alignment: Qt.AlignHCenter
	}
}
