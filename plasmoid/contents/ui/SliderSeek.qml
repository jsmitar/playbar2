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
import QtQuick.Layouts 1.0
import org.kde.plasma.components 2.0 as PlasmaComponents

RowLayout{

	spacing: units.smallSpacing

	TimeLabel{
		currentTime: sliderSeek.value
		interactive: false

		Layout.fillHeight: false
		Layout.minimumWidth: units.largeSpacing * 2
	}

	PlasmaComponents.Slider{
		id: sliderSeek

		activeFocusOnPress: false
		updateValueWhileDragging: true
		maximumValue: mpris2.length
		value: mpris2.position
		stepSize: 100
		visible: maximumValue != 0
		onValueChanged: if(pressed) mpris2.seek(value)

		Layout.fillWidth: true
		Layout.fillHeight: false
	}

	TimeLabel{
		currentTime: sliderSeek.value
		interactive: true
		showRemaining: true
		showPosition: false
		labelSwitch: plasmoid.configuration.TimeLabelSwitch
		horizontalAlignment: Text.AlignRight

		Layout.fillHeight: false
		Layout.minimumWidth: units.largeSpacing * 2
		Layout.alignment: Qt.AlignRight
	}
}
