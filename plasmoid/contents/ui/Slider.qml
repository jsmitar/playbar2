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
import org.kde.plasma.components 0.1
import org.kde.qtextracomponents 0.1 as QtExtra
import "plasmapackage:/code/control.js" as Control

Item{
	id: slider

	property alias maximumValue: range.maximumValue

	property alias value: range.value

	property bool pressAndChange: false

	property alias pressed: seekArea.pressed

	property alias enabledWheel: wheelMouse.enabled

	property double valueForPosition: range.value

	property bool dragActive: seekArea.drag.active

	property int intervalDragCall: 1000

	property int orientation: QtHorizontal


	signal valueChanged(real value)

	signal sliderDragged()

	signal controlBarWheelEvent(variant wheel)


//#####################################################

	property bool horizontal: orientation == QtHorizontal

	//NOTE: Vertical State
	states: State{
		when: orientation == QtVertical

		//range
		PropertyChanges{
			target: range
			positionAtMaximum: content.height
			positionAtMinimum: 0
		}
		//bar
		PropertyChanges{
			target: bar
			height: range.position

			anchors{
				topMargin: 0
				bottomMargin: -1
			}
		}
		AnchorChanges{
			target: bar
			anchors{
				top: undefined
				right: parent.right
			}
		}
		//seek
		PropertyChanges{
			target: seek
			height: 2
			width: bar.width
			x: 0
			y: !seekArea.drag.active ? bar.height : 0
		}
		AnchorChanges{
			target: seek
			anchors{
				verticalCenter: undefined
				horizontalCenter: bar.horizontalCenter
				left: undefined
				right: undefined
				bottom: !seekArea.pressed ? bar.top : undefined
			}
		}
		//seekArea
		PropertyChanges{
			target: seekArea
			drag{
				axis: Drag.YAxis
				maximumX: 0
				minimumY: 0
				maximumY: barBg.height
			}
		}
		//wheelMouse
		PropertyChanges{
			target: wheelMouse
			anchors{
				leftMargin: -8
				rightMargin: -4
			}
		}
		AnchorChanges{
			target: wheelMouse
			anchors{
				top: content.top
			}
		}
	}

//#####################################################

	RangeModel{
		id: range

		minimumValue: 0
		maximumValue: 0
		value: 0
		positionAtMinimum: 0
		positionAtMaximum: content.width

	}

	Rectangle{
		id: content

		color: theme.textColor
		radius: 2
		smooth: true
		anchors.fill: parent

		Rectangle{
			id: barBg

			smooth: true
			radius: 2
			anchors.fill: parent
			color: theme.backgroundColor
			opacity: 0.7

		}

		Rectangle{
			id: bar

			anchors{
				left: parent.left
				top: parent.top
				bottom: parent.bottom
				//topMargin: -1
				//bottomMargin: -1
			}
			radius: 2
			smooth: true
			color: theme.highlightColor
			width: range.position

			Behavior on width{ enabled: horizontal ; NumberAnimation{duration: 150} }
			Behavior on height{ enabled: !horizontal ; NumberAnimation{duration: 150} }
		}

		Rectangle{
			id: seek
			width: 2
			height: parent.height
			color: theme.highlightColor

			border{
				color: color
				width: 4
			}

			opacity: 0
			radius: 0.1
			smooth: true

			anchors{
				verticalCenter: bar.verticalCenter
				leftMargin: -2
				left: !seekArea.pressed ? bar.right : undefined
			}

			Behavior on opacity{ NumberAnimation{duration: 150} }

		}

		//ATTENTION: This will be removed in QtQuick 2.0
		QtExtra.MouseEventListener{
			id: wheelMouse

			enabled: false
			visible: enabled

			height: 30
			anchors{
				left: parent.left
				right: parent.right
				bottom: parent.bottom
				rightMargin: -30
				bottomMargin: -4
			}
			onWheelMoved: {
				if(wheel.delta > 0)
					range.setValue(range.value + 0.05)
				else
					range.setValue(range.value - 0.05)
				valueChanged(range.value)
			}
			Component.onCompleted: controlBarWheelEvent.connect(wheelMoved)
		}

		MouseArea{
			id: seekArea

			anchors.fill: parent

			hoverEnabled: true

			drag{
				//target: seek
				axis: Drag.XAxis
				minimumX: 0
				maximumX: barBg.width
			}
			onEntered: seek.opacity = 1

			onExited: if(!pressed) seek.opacity = 0

			onPressed: {
				if(horizontal) seek.x = mouseX
				else seek.y = mouseY
			}

			onReleased: {
				if(!containsMouse) seek.opacity = 0
				if(horizontal)
					valueChanged(range.valueForPosition(mouseX))
				else
					valueChanged(range.valueForPosition( drag.maximumY - mouseY))
			}

			function xPosition(mouseX){
				if(mouseX > drag.maximumX) seek.x = drag.maximumX
				else if(mouseX < 0) seek.x = 0
				else seek.x = mouseX

				var currentValue = range.valueForPosition(seek.x)
				if(currentValue / intervalDragCall != valueForPosition / intervalDragCall)
				{
					valueForPosition = currentValue
					sliderDragged()
				}

				if (pressAndChange) valueChanged(range.valueForPosition(seek.x))
			}

			function yPosition(mouseY){
				if(mouseY > drag.maximumY) seek.y = drag.maximumY
				else if(mouseY < 0) seek.y = 0
				else seek.y = mouseY

				//invert y axis
				mouseY = drag.maximumY - mouseY

				var currentValue = range.valueForPosition(content.height - seek.y)
				if(currentValue / intervalDragCall != valueForPosition / intervalDragCall)
				{
					valueForPosition = currentValue
					sliderDragged()
				}

				if (pressAndChange) valueChanged(range.valueForPosition(content.height - seek.y))
			}

			onPositionChanged: {
				if(!pressed) return
				if(orientation == QtHorizontal) xPosition(mouseX)
				else yPosition(mouseY)
			}
		}
	}
}
