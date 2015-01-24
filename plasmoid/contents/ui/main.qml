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
import QtQuick.Layouts 1.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.plasmoid 2.0
// import "plasmapackage:/code/control.js" as Control


Item {
    id: root

	width: units.iconSizes.huge * 4

	height: units.iconSizes.huge + 2 * units.smallSpacing

	property alias _w: root.width

	property alias _h: root.height

	property bool vertical: Plasmoid.formFactor == PlasmaCore.Types.Vertical

	Plasmoid.compactRepresentation: CompactRepresentation{}

	Plasmoid.fullRepresentation: FullRepresentation{}

	clip: true

// 	property bool popupOpen: popup.status == PlasmaComponents.DialogStatus.Open

// 	property bool showNotifications: plasmoid.readConfig('showNotifications')

	function debug(str){ console.debug(str) }


	Behavior on opacity{
		NumberAnimation{ duration: 250 }
	}

	Mpris2{ id: mpris2 }

	//###########################
	// 	Context menu actions

	function action_raise(){
		mpris2.startOperation('Raise')
	}

	function action_quit(){
		mpris2.startOperation('Quit')
	}

	function action_nextSource(){
		mpris2.nextSource()
// 		if(showNotifications) Control.sourceNotify()
	}

	//TODO: open file
	//###########################

	function setMaximumLoad(){
		mpris2.interval = mpris2.maximumLoad
	}

	function setMinimumLoad(){
		mpris2.interval = mpris2.minimumLoad
	}

	Component.onCompleted:{
		plasmoid.constraint = 0
		debug("root size: "+ _w + " " + _h)
		debug("FormFactor: " + Plasmoid.formFactor)

    }

	//ATTENTION: This will be removed in QtQuick 2.0 because will be unnecessary
	// Volume Area
	// DEPRECATED:
	MouseArea{
		id: volumeWheelArea

		acceptedButtons: Qt.XButton1 | Qt.XButton2
		enabled: mpris2.sourceActive

		onWheel: {
			if(!mpris2.sourceActive) return
			if(mpris2.source != 'spotify'){
				Control.controlBarWheelEvent(wheel)
				Control.controlBarWheelNotify()
			}
		}
	}
}






