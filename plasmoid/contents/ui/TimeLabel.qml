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

    property int hour: 0

    property int min: 0

    property int sec: 0

    property bool timeNegative: true

    opacity: 0.8

    font: theme.smallestFont

    signal clicked

    text: (timeNegative ? '-' : '')
          + (hour > 0 ? hour + ':': '')
          + (hour > 0 && min < 10 ? '0' + min : min)
          + ':' + (sec < 10 ? '0' + sec : sec)

    enabled: topTime > 0

    function positionUpdate() {
        hour = currentTime / 3600
        min = currentTime / 60 - hour * 60
        sec = currentTime - hour * 3600 - min * 60
    }

    function remainingUpdate() {
        var remain = topTime - currentTime
        hour = remain / 3600
        min = remain / 60 - hour * 60
        sec = remain - hour * 3600 - min * 60
    }

    function lengthUpdate() {
        hour = topTime / 3600
        min = topTime / 60 - hour * 60
        sec = topTime - hour * 3600 - min * 60
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
