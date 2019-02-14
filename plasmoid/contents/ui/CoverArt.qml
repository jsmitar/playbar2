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
import QtQuick.Layouts 1.2
import QtQuick.Controls 1.4
import org.kde.plasma.core 2.0 as PlasmaCore
import QtGraphicalEffects 1.0

Item {
    id: bg

    readonly property int paintedWidth: noCover.visible ? noCover.paintedWidth : cover.paintedWidth
    readonly property int paintedHeight: noCover.visible ? noCover.paintedHeight : cover.paintedHeight

    readonly property int coverLeftMargin: (bg.width - paintedWidth) / 2 + units.smallSpacing
    readonly property int coverTopMargin: (bg.height - paintedHeight) / 2 + units.smallSpacing

    readonly property alias containsMouse: toggleWindow.containsMouse

    property alias noCoverIcon: noCover.source
    property bool forceNoCover: false

    width: units.iconSizes.enormous
    height: units.iconSizes.enormous
    Layout.fillWidth: true
    Layout.fillHeight: true

    Timer {
        id: timer
        repeat: false
        interval: 250

        onTriggered: {
            noCover.visible = cover.status === Image.Null || cover.status === Image.Error || forceNoCover
        }
    }

    PlasmaCore.IconItem {
        id: noCover

        anchors.fill: parent
        source: 'nocover'
        smooth: true
    }

    Image {
        id: cover

        source: Qt.resolvedUrl(mpris2.artUrl)
        fillMode: Image.PreserveAspectFit
        anchors.fill: parent
        mipmap: true
        cache: false
        visible: !forceNoCover

        sourceSize.width: width
        sourceSize.height: height

        horizontalAlignment: Image.AlignHCenter
        verticalAlignment: Image.AlignVCenter

        layer.enabled: true
        layer.effect: OpacityMask {
            source: cover
            width: cover.width
            height: cover.height
            cached: false
            maskSource: Item {
                width: cover.width
                height: cover.height
                Rectangle {
                    anchors.centerIn: parent
                    width: cover.paintedWidth
                    height: cover.paintedHeight
                    border.width: 0
                    radius: units.gridUnit * 0.3
                }
            }
        }

        onStatusChanged: {
            if (status === Image.Loading) {
                animB.stop()
                animA.start()
            } else if (status === Image.Ready) {
                animA.stop()
                animB.start()
            }
            timer.restart()
        }

        OpacityAnimator on opacity {
            id: animA
            running: false
            to: 0.0
            duration: units.shortDuration
        }

        OpacityAnimator on opacity {
            id: animB
            running: false
            to: 1.0
            duration: units.longDuration * 1.5
        }
    }

    MouseArea {
        id: toggleWindow
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton
        onClicked: action_raise()
        hoverEnabled: true
    }

}
