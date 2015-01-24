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

Item{
	id: playbackControl

	PlaybackBar{
		id: playbackBar
		buttonSize: parent.width / 4
		anchors {
			centerIn: parent
		}
	}

	Layout.minimumWidth  : units.iconSizes.medium * 4 + units.smallSpacing * 2
	Layout.minimumHeight : playbackBar.buttonSize
}
