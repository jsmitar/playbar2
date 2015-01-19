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
//import org.kde.plasma.core 0.1 as PlasmaCore


IconWidget{
	id: iconPopup

	svg: update()

	elementId: closed

	property variant icons: [ "up-arrow", "down-arrow", "right-arrow", "left-arrow" ]

	property string opened: icons[0]

	property string closed: icons[1]

	function update(){
		if(plasmoid.readConfig("opaqueIcons") == true)
			return Svg(plasmoid.readConfig("arrows-opaque"))
		else return Svg(plasmoid.readConfig("arrows-clear"))
	}

	Component.onCompleted:{
		function locationChanged(){

			switch(plasmoid.location){
				case Floating:
				case Desktop:
				case TopEdge:
					opened = icons[0]
					closed = icons[1]
					break
				case BottomEdge:
					opened = icons[1]
					closed = icons[0]
					break
				case LeftEdge:
					opened = icons[3]
					closed = icons[2]
					break
				case RightEdge:
					opened = icons[2]
					closed = icons[3]
			}
		}

		plasmoid.addEventListener('configChanged', function(){svg = update()} )
		plasmoid.locationChanged.connect(locationChanged)
		locationChanged()
	}
}
