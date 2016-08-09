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

Item {
    id: scroll

    property var target

    property bool scrolling: false

    property bool isScrollable: false

    focus: false

    Connections {
        target: scroll.target

        onWidthChanged: anim.stop()
        onTextChanged: anim.stop()
    }

    SequentialAnimation {
        id: anim
        running: false

        onStopped: {
            isScrollable = target.contentWidth > target.width
                    || target.truncated
            if (scrollArea.containsMouse && isScrollable)
                anim.restart()
            else
                scrolling = false
        }

        SmoothedAnimation {
            id: end
            target: scroll.target
            property: 'x'
            from: 0
            // It goes to the end of the text
            to: target.width - target.contentWidth - units.smallSpacing
            velocity: 60
        }

        SmoothedAnimation {
            id: begin
            target: scroll.target
            property: 'x'
            // it goes to the beginning of the text
            to: 0
            velocity: 80
        }
    }

    MouseArea {
        id: scrollArea

        anchors.fill: parent
        acceptedButtons: Qt.NoButton
        hoverEnabled: true

        onEntered: {
            isScrollable = target.contentWidth > target.width
                    || target.truncated
            if (isScrollable && !anim.running) {
                scrolling = true
                anim.start()
            } else if (scrolling && !anim.running) {
                anim.start()
            }
        }
    }
}
