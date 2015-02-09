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
import org.kde.plasma.extras 2.0 as PlasmaExtras

Flow{
	id: playbackControl

	spacing: units.smallSpacing / 2
	flow: vertical ? Flow.TopToBottom : Flow.LeftToRight

	Layout.minimumWidth: !vertical ? playbackBar.width + playbackBar.buttonSize + spacing : units.iconSizes.small
	Layout.minimumHeight : vertical ? playbackBar.height + playbackBar.buttonSize + spacing : units.iconSizes.small
	anchors.fill: parent

	property int _buttonSize: vertical ? (parent && parent.width ? parent.width : 0 ): (parent && parent.height ? parent.height : 0 )

	PlaybackBar{
		id: playbackBar
		buttonSize: parent._buttonSize
	}
	Item{
		width: _buttonSize
		height: _buttonSize
		PopupButton{
			id: popup

			size: mpris2.sourceActive ? _buttonSize * (plasmoid.configuration.FlatButtons ? 0.7 : 0.5) : _buttonSize
			anchors.centerIn: parent
			opened: popupDialog.visible

			onClicked: {
				popupDialog.setVisible(!popupDialog.visible)
			}
		}
		Dialog{
			id: popupDialog
			visualParent: playbackControl
		}
	}

}
