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
import org.kde.plasma.core 2.0 as PlasmaCore

Item{
    id: playbackitem

    property bool playing: mpris2.playbackStatus == 'Playing'

    property bool showStop: mpris2.source == 'spotify' ? false : playbarEngine.showStop

    property int buttonSize: units.iconSizes.small

    enabled: mpris2.sourceActive && mpris2.canControl

    visible: mpris2.sourceActive

    signal playPause()

    signal previous()

    signal next()

    signal stop()

    onPlayPause: {
		if(mpris2.source == 'spotify' ) {
			mpris2.startOperation('PlayPause')
			return
		}
		if(!playing) mpris2.startOperation('Play')
		else mpris2.startOperation('PlayPause')
	}

    onPrevious: {
		if(mpris2.canGoPrevious)
			mpris2.startOperation('Previous')
	}
    onNext: {
		if(mpris2.canGoNext)
			mpris2.startOperation('Next')
	}
    onStop: {
		if(mpris2.playbackStatus != "Stopped")
			mpris2.startOperation('Stop')
	}

}
