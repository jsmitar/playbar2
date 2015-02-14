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

PlasmaCore.Dialog{
	id: popupDialog

	title: mpris2.identity

	minimumWidth: 350

	minimumHeight: page.implicitHeight

	maximumWidth: 360

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

	mainItem: DefaultLayout{id: page}

// 	Loader{
// 		id: loader
// 		sourceComponent: DefaultLayout
// 		onLoaded: {
// 			debug("Layout loaded")
// 		}
// 	}
}
