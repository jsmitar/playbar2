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

Item {
    id: scroll

    property var target

    property bool scrolling: false

    property bool isScrollable: false

    property bool autoScroll: false

    property int velocity: 60

    property bool vertical: false

    property bool reverse: false

    readonly property int contentSize: target.contentWidth

    readonly property int size: target.width

    focus: false

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        acceptedButtons: Qt.NoButton
        hoverEnabled: true
        onEntered: start()
    }

    function start() {
        if (!anim.running && _isScrollable()) {
            scrolling = true
            anim.start()
        }
    }

    function restart() {
        stop()
        if (_isScrollable()) {
            scrolling = true
            anim.restart()
        }
    }

    function stop() {
        anim.stop()
        if (vertical) target.y = 0
        else target.x = 0
    }

    function _isScrollable() {
        return isScrollable = contentSize > size || target.truncated
    }

    Connections {
        target: scroll.target
        onWidthChanged: scroll.stop()
        onHeightChanged: scroll.stop()
        onTextChanged: scroll.stop()
    }

    SequentialAnimation {
        id: anim
        running: false

        loops: autoScroll ? 2 : 1

        onStopped: {
            if (_isScrollable() && mouseArea.containsMouse)
                anim.restart()
            else
                scrolling = false
        }

        PauseAnimation {
            duration: 300
        }

        SmoothedAnimation {
            id: end
            target: scroll.target
            property: scroll.vertical ? 'y' : 'x'
            from: 0
            // It goes to the end of the text
            to: (size - contentSize - theme.mSize(theme.defaultFont).width) *  (scroll.reverse ? -1 : 1)
            velocity: scroll.velocity
        }

        SmoothedAnimation {
            id: begin
            target: scroll.target
            property: scroll.vertical ? 'y' : 'x'
            // it goes to the beginning of the text
            to: 0
            velocity: scroll.velocity * 1.1
        }
    }
}
