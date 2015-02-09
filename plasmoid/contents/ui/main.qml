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

	Plasmoid.compactRepresentation: CompactApplet{ id: compact}
	Plasmoid.fullRepresentation: FullApplet{id: full}

	Plasmoid.preferredRepresentation: plasmoid.formFactor == 0 ? Plasmoid.fullRepresentation : Plasmoid.compactRepresentation

	Plasmoid.icon: internal.icon
	Plasmoid.toolTipMainText: internal.title
	Plasmoid.toolTipSubText: internal.subText
	Plasmoid.backgroundHints: plasmoid.configuration.BackgroundHint


	Connections{
		target: plasmoid
		onFormFactorChanged: {
		debug("FormFactor: " + plasmoid.formFactor)
			if(plasmoid.formFactor == 0){
				Plasmoid.preferredRepresentation = Plasmoid.fullRepresentation
				mpris2.interval = mpris2.maximumLoad
			}
		}
	}

	function debug(str){ console.debug("PlayBar2: " + str) }

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
	}

	Component.onCompleted:{
		debug("Location: " + Plasmoid.location)
		plasmoid.formFactorChanged()
    }

	QtObject{
		id: internal

		property string icon:
			mpris2.artUrl != "" ? Qt.resolvedUrl(mpris2.artUrl) : "media-playback-start"
		property string title:
		    mpris2.title != "" ? mpris2.title : "PlayBar"
		property string artist:
		    mpris2.artist != "" ? i18nc("ToolTip: track artist %1", "<b>By</b> %1, ", mpris2.artist) : ""
		property string album:
		    mpris2.album != ""? i18nc("ToolTip: track album %1", "<b>On</b> %1", mpris2.album) : ""
		property string subText:
		    (artist == "" & album == "") ? i18n("Client MPRIS2, allows you to control your favorite media player") : artist + album
	}
}





