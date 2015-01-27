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

Item{
	id: scroll

	property var target

	property bool scrolling

	property bool isScrollable: target.contentWidth > target.width | target.truncated

	SequentialAnimation{
		id: anim
		running: false
		alwaysRunToEnd: true
		loops: Animation.Infinite

		onStopped: {
			if( scrollArea.containsMouse && isScrollable ) anim.start()
			else scrolling = false
		}

		SmoothedAnimation{
			target: scroll.target
			property: 'x'
			from: 0
			to: - ( target.contentWidth - target.width + units.largeSpacing )
			velocity: 60
		}
		SmoothedAnimation{
			target: scroll.target
			property: 'x'
			to: 0
			velocity: 80
		}
	}

	MouseArea{
		id: scrollArea

		anchors.fill: parent
		acceptedButtons: Qt.NoButton
		hoverEnabled: true

		function initAutoScroll(){
			if(isScrollable && containsMouse){
				scrolling = true
				anim.start()
			}else{
				scrolling = false
				if(anim.running) anim.stop()
			}
		}
		onEntered: initAutoScroll()
		onExited: if(anim.running) anim.stop()

		Component.onCompleted: target.textChanged.connect(entered)
	}
}
