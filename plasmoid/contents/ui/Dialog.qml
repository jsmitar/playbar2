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
import org.kde.plasma.plasmoid 2.0
// import org.kde.plasma.components 2.0 as PlasmaComponents

PlasmaCore.Dialog{
	id: popupDialog

	title: mpris2.identity

	minimumWidth: if(loader.active) 343

	minimumHeight: if(loader.active) loader.item.implicitHeight

	maximumWidth: 343

	flags: Qt.WindowStaysOnTopHint

	type: PlasmaCore.Dialog.DialogWindow

	location: plasmoid.location

	backgroundHints: PlasmaCore.Dialog.StandardBackground

	hideOnWindowDeactivate: true

	onVisibleChanged: {
		debug("Dialog visible: "+visible )
		if(visible)
			mpris2.interval = mpris2.maximumLoad
		else
			mpris2.interval = mpris2.minimumLoad
	}

	MediaLayouts{ id: layouts }

	mainItem: if(loader.active) loader.item

	Loader{
		id: loader
		sourceComponent: layouts.resources[0]
		onLoaded: {
			debug("Layout loaded")
		}
	}
}
