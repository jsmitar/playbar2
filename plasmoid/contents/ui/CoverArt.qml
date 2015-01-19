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
import org.kde.plasma.components 0.1 as PlasmaComponents
import org.kde.plasma.core 0.1 as PlasmaCore

Item{
	id: coverArt

	property int size: 80

	implicitWidth: size + 8

	implicitHeight: size + 8

	states: [
		State{
			name: 'nocover'
			when: cover.source == "" || cover.status == Image.NULL || cover.status == Image.Error
			PropertyChanges{
				target: nocover
				visible: true
			}
			PropertyChanges{
				target: bg
				opacity: 0.8
			}
			PropertyChanges{ target: bgMask; opacity: 0.5 }
		},
		State{
			name: 'busy'
			when: cover.status == Image.Loading
			PropertyChanges{
				target: nocover
				visible: true
				smooth: true
				rotation: 180
			}
			PropertyChanges{
				target: bg
				opacity: 0.8
			}
		},
		State{
			name: 'cover'
			when: cover.status == Image.Ready
			PropertyChanges{
				target: nocover
				visible: false
			}
			PropertyChanges{
				target: bg
				color: theme.textColor
			}
		}
	]

	transitions: Transition {
		NumberAnimation{ property: 'opacity'; duration: 500 }
		RotationAnimation { duration: 1000; direction: RotationAnimation.Counterclockwise; }
	}

    Rectangle{
		id: bg

		color: theme.textColor
		width: size
		height: size
		radius: 2
		clip: true

		anchors.centerIn: parent

		border{
			color: bg.color
            width: 4
        }
		Rectangle{
			id: bgMask
			anchors.fill: parent
			color: theme.backgroundColor

			opacity: 0.1
			border{
				color: color
				width: 4
			}
		}
    }

    PlasmaCore.SvgItem{
        id: nocover

        svg: PlasmaCore.Svg{
				imagePath: plasmoid.file("theme", "playbar/nocover.svgz")
				usingRenderingCache: true
				Component.onCompleted: {
					theme.themeChanged.connect(repaintNeeded); repaintNeeded()
				}
			}
		anchors.fill: bg
    }

	Image{
		id: cover

		source: Qt.resolvedUrl(mpris.artUrl)
		fillMode: Image.PreserveAspectFit
		sourceSize: Qt.size(size, size)
		anchors.fill: bg

		visible: status == Image.Ready ? true : false
		cache: true

		onStatusChanged: {
			if(status == Image.Error)
				print("Err: " +mpris.artUrl)
		}
	}

	MouseArea{
		anchors.fill: parent
		hoverEnabled: true
		onClicked: action_raise()
	}

}
