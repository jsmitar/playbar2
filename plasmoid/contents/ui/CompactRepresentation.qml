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

Flow{
	id: playbackControl

	spacing: units.smallSpacing
	flow: vertical ? Flow.TopToBottom : Flow.LeftToRight

	PlaybackBar{
		id: playbackBar
		buttonSize: vertical ? parent.width : parent.height
	}
	Layout.minimumWidth  : vertical ? 0 : playbackBar.width
	Layout.minimumHeight : vertical ? playbackBar.height : 0
// 	Layout.maximumHeight : playbackBar.buttonSize
}
