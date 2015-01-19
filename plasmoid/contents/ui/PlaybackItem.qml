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

import QtQuick 2.3
import "plasmapackage:/code/control.js" as Control

Item{
    id: playbackitem

    property bool playing: mpris.playbackStatus == 'Playing'

	//DEPRECATED
    property bool showStop: mpris.source == 'spotify' ? false : plasmoid.readConfig('showStop')

    property bool vertical: false

    property real spacing: -2

    property int buttonSize: 22

    signal playPause()

    signal previous()

    signal next()

    signal stop()

	function showStopChanged(source){
		if( source == undefined ) source = mpris.source
		if( source != 'spotify' )
			//DEPRECATED
			showStop = plasmoid.readConfig('showStop')
		else showStop = false
	}

    onPlayPause: {
		if(mpris.source == 'spotify' ) {
			Control.startOperation('PlayPause')
			return
		}
		if(!playing) Control.startOperation('Play')
		else Control.startOperation('PlayPause')
	}

    onPrevious: Control.startOperation('Previous')

    onNext: Control.startOperation('Next')

    onStop: if(mpris.playbackStatus != "Stopped") Control.startOperation('Stop')

	Component.onCompleted: {
		mpris.sourceChanged.connect(showStopChanged)
		//DEPRECATED
		plasmoid.addEventListener('configChanged', showStopChanged)
	}

	Component.onDestruction: {
		mpris.sourceChanged.disconnect(showStopChanged)
	}
}
