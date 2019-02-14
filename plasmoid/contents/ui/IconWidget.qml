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
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.extras 2.0 as PlasmaExtras

PlasmaCore.SvgItem {
    id: iconWidget

    property alias iconSource: iconWidget.elementId

    property int size: units.iconSizes.medium

    implicitWidth: size

    implicitHeight: size

    smooth: true

    signal clicked

    opacity: enabled ? 1 : 0.5

    PlasmaExtras.PressedAnimation {
        id: animA
        running: mouseArea.pressed
        targetItem: iconWidget
        duration: units.shortDuration
        alwaysRunToEnd: true
    }

    PlasmaExtras.ReleasedAnimation {
        id: animB
        running: false
        targetItem: iconWidget
        alwaysRunToEnd: true
        duration: units.longDuration
    }

    MouseArea {
        id: mouseArea

        acceptedButtons: Qt.LeftButton
        anchors.fill: parent

        onPressedChanged: if (!pressed && iconWidget.scale < 1.0)
                              animB.start()
        onExited: animB.start()

        Component.onCompleted: clicked.connect(iconWidget.clicked)
    }
}
