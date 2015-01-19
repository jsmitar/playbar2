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
import "plasmapackage:/code/control.js" as Control

Item{
	id: layout

	property bool isSpotify: mpris.source == 'spotify'

	property bool noSource:
		mpris.connectedSources == ""

	property variant idLayout: undefined

	LayoutsResources{id: layouts}

	height: childrenRect.height
	width: childrenRect.width

	signal layoutChanged()

	Component.onCompleted: {
		plasmoid.addEventListener('configChanged', function(){
				idLayout = layouts.resources[plasmoid.readConfig('PlayBarLayout')]
			}
		)
	}

	Loader{
		id: loader

		sourceComponent: if(noSource) undefined
			else if(isSpotify) layouts.spotifyLayout
			else idLayout

		onLoaded:{
			layoutChanged()
		}
	}
}
