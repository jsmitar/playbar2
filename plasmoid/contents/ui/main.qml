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
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.plasmoid 2.0

Item {
    id: root

	property bool vertical: plasmoid.formFactor == PlasmaCore.Types.Vertical

	Plasmoid.compactRepresentation: CompactApplet{}
	Plasmoid.fullRepresentation: FullApplet{}

	Plasmoid.preferredRepresentation: plasmoid.expanded ? Plasmoid.fullRepresentation : Plasmoid.compactRepresentation

	Plasmoid.icon: Qt.resolvedUrl(mpris2.artUrl)
	Plasmoid.toolTipMainText: mpris2.title
	Plasmoid.toolTipSubText: i18n("<b>By</b> %1 <b>on</b> %2", mpris2.artist, mpris2.album)

	function debug(str){ console.debug("PlayBar2: " + str) }

	Mpris2{ id: mpris2 }

//

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
	}

	Component.onCompleted:{
		debug("FormFactor: " + Plasmoid.formFactor)
		debug("Location: " + Plasmoid.location)
    }
}






