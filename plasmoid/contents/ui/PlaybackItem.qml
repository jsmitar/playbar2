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

    property bool playing: mpris2.playbackStatus == 'Playing'

    property bool showStop: mpris2.source == 'spotify' ? false : plasmoid.configuration.ShowStop

    property bool vertical: false

    property real spacing: -2

    property int buttonSize: 22

    signal playPause()

    signal previous()

    signal next()

    signal stop()

// 	function showStopChanged(source){
// 		if( source == undefined ) source = mpris2.source
// 		if( source != 'spotify' )
// 			showStop = plasmoid.configuration.ShowStop
// 		else showStop = false
// 	}

    onPlayPause: {
		if(mpris2.source == 'spotify' ) {
			mpris2.startOperation('PlayPause')
			return
		}
		if(!playing) mpris2.startOperation('Play')
		else mpris2.startOperation('PlayPause')
	}

    onPrevious: mpris2.startOperation('Previous')

    onNext: mpris2.startOperation('Next')

    onStop: if(mpris2.playbackStatus != "Stopped") mpris2.startOperation('Stop')

// 	Component.onCompleted: {
// 		mpris2.sourceChanged.connect(showStopChanged)
// 		DEPRECATED
// 		plasmoid.addEventListener('configChanged', showStopChanged)
// 	}
//
// 	Component.onDestruction: {
// 		mpris2.sourceChanged.disconnect(showStopChanged)
// 	}
}
