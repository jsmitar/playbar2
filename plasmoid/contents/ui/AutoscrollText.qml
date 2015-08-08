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

Item {
	id: scroll

	property var target

	property bool scrolling: false

	property bool isScrollable: false

	focus: false

	SequentialAnimation {
		id: anim
		running: false
		alwaysRunToEnd: true
		loops: Animation.Infinite

		onStopped: {
			if ( scrollArea.containsMouse && !running ) anim.restart()
			else scrolling = false
		}

		SmoothedAnimation {
			id: animA
			target: scroll.target
			property: 'x'
			from: 0
			to: - ( target.contentWidth - target.width + units.smallSpacing )
			velocity: 60
		}
		SmoothedAnimation {
			id: animB
			target: scroll.target
			property: 'x'
			to: 0
			velocity: 80
		}
		Component.onCompleted: {
			isScrollable = target.contentWidth > target.width || target.truncated
			target.textChanged.connect( function() {
				isScrollable = target.contentWidth > target.width || target.truncated
				scrolling = false
			} )
		}
	}

	MouseArea {
		id: scrollArea

		anchors.fill: parent
		acceptedButtons: Qt.NoButton
		hoverEnabled: true

		function initAutoScroll() {
			isScrollable = target.contentWidth > target.width || target.truncated
			if ( isScrollable && !anim.running ) {
				scrolling = true
				anim.start()
			} else if ( scrolling && !anim.running ) {
				anim.start()
			}
		}
		onEntered: initAutoScroll()
		onExited: if ( anim.running ) anim.stop()
	}
}
