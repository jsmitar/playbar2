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
import org.kde.plasma.components 2.0 as PlasmaComponents

PlasmaComponents.Label {
    id: time

    property alias type: time.state

    readonly property int length: mpris2.length

    property int position: 0

    property alias interactive: mouseArea.enabled

    property int hour: 0

    property int min: 0

    property int sec: 0

    property var _update: lengthUpdate

    state: type
    opacity: 0.8
    font: theme.smallestFont

    signal clicked

    text: (type == 'remaining' ? '-' : '')
          + (hour > 0 ? hour + ':': '')
          + (hour > 0 && min < 10 ? '0' + min : min)
          + ':' + (sec < 10 ? '0' + sec : sec)

    enabled: length > 0

    onPositionChanged: _update()
    onLengthChanged: _update()
    onTypeChanged: _update()

    states: [
        State {
            name: 'length'
            PropertyChanges {
                target: time
                _update: lengthUpdate
            }
        },
        State {
            name: 'position'
            PropertyChanges {
                target: time
                _update: positionUpdate
            }
        },
        State {
            name: 'remaining'
            PropertyChanges {
                target: time
                _update: remainingUpdate
            }
        }
    ]

    function positionUpdate() {
        hour = position / 3600
        min = position / 60 - hour * 60
        sec = position - hour * 3600 - min * 60
    }

    function remainingUpdate() {
        var remain = length - position
        hour = remain / 3600
        min = remain / 60 - hour * 60
        sec = remain - hour * 3600 - min * 60
    }

    function lengthUpdate() {
        hour = length / 3600
        min = length / 60 - hour * 60
        sec = length - hour * 3600 - min * 60
    }

    MouseArea {
        id: mouseArea

        anchors.fill: parent
        acceptedButtons: Qt.LeftButton
        hoverEnabled: enabled

        onClicked: {
            if (containsMouse) {
                time.clicked()
                time._update()
            }
        }
    }
}
