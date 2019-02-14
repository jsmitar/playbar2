/*
*   Author: audoban <audoban@openmailbox.org>
*
*   This program is free software; you can redistribute it and/or modify
*   it under the terms of the GNU Library General Public License as
*   published by the Free Software Foundation; either version 3 or
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
import QtQuick 2.7

MouseArea {
    id: volumeWheelArea

    z: 99
    acceptedButtons: Qt.MiddleButton | Qt.BackButton | Qt.ForwardButton

    onClicked: {
        switch (mouse.button) {
            case Qt.MiddleButton:
                root.action_playPause()
                break
            case Qt.BackButton:
                root.action_previous()
                break
            case Qt.ForwardButton:
                root.action_next()
                break
        }
    }

    onWheel: {
        wheel.accepted = true
        if (wheel.modifiers == Qt.NoModifier) {
            if (wheel.angleDelta.y > 50)
                mpris2.setVolume(Number((mpris2.volume + 0.1).toFixed(1)))
            else if (wheel.angleDelta.y < -50)
                mpris2.setVolume(Number((mpris2.volume - 0.1).toFixed(1)))
        }
    }
}
