// -*- coding: iso-8859-1 -*-
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

import QtQuick 1.1
import org.kde.plasma.core 0.1 as PlasmaCore
import "plasmapackage:/code/control.js" as Control


Row{
    id: sliderSeek

    spacing: 8

	property bool labelVisible: true

	signal currentSeekPosition(int position)

	width: childrenRect.width

	height: childrenRect.height

    TimeLabel{
        id: lengthTime

		hover: false
        currentTime: mpris.length
		autoTimeTrigger: mpris.isMaximumLoad

		anchors{
			verticalCenter: slider.verticalCenter
			verticalCenterOffset: -1
		}
		visible: labelVisible
    }

	Slider{
		id: slider

		maximumValue: mpris.length
		value: mpris.position
		width: parent.width - ( labelVisible ? (lengthTime.width * 2 + spacing * 3) : 0 )
		height: 10

		onValueChanged: Control.seek(value, mpris.position)
		onSliderDragged: positionTime.timeChanged()

	}

	TimeLabel{
        id: positionTime

		hover: true
        topTime: mpris.length
        currentTime: slider.pressed ? slider.valueForPosition : mpris.position
		autoTimeTrigger: mpris.isMaximumLoad

		anchors{
			verticalCenter: slider.verticalCenter
			verticalCenterOffset: -1
		}

		onTimeChanged: {
			if(Control.openedPopup)
				parent.currentSeekPosition(currentTime)
		}

		visible: labelVisible
		negative: plasmoid.readConfig('timeNegative')
    }
}
