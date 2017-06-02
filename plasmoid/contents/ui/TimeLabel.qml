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
import org.kde.plasma.components 2.0 as PlasmaComponents
import "../code/utils.js" as Utils

PlasmaComponents.Label {
    id: time

    // seconds
    property int topTime: mpris2.length

    property int currentTime: 0

    property alias interactive: mouseArea.enabled

    property int min: 0

    property int sec: 0

    property bool minusFrontOfZero: true

    opacity: 0.8

    font: theme.smallestFont

    signal clicked

    text: (minusFrontOfZero ? '-' + min : min) + ':' + (sec < 10 ? '0' + sec : sec)

    enabled: topTime > 0

    function positionUpdate() {
        min = currentTime / 60
        sec = currentTime - min * 60
    }

    function remainingUpdate() {
        min = (topTime - currentTime) / 60
        sec = topTime - currentTime - min * 60
    }

    function lengthUpdate() {
        min = topTime / 60
        sec = topTime - min * 60
    }

    MouseArea {
        id: mouseArea

        anchors.fill: parent
        acceptedButtons: Qt.LeftButton
        hoverEnabled: enabled

        onClicked: if (containsMouse)
                       parent.clicked()
    }
}
