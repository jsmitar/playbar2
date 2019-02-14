/*
*   Author: audoban <audoban@openmailbox.org>
*
*   This program is free software; you can redistribute it and/or modify
*   it under the terms of the GNU Library General Public License as
*   published by the Free Software Foundation; either version 3 or
*   (at your option ) any later version.
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
import org.kde.plasma.components 2.0 as PlasmaComponents

PlaybackItem {
    id: playbackWidget

    visible: true

    buttonSize: Qt.size(units.iconSizes.medium * 1.4, units.iconSizes.medium * 1.4)

    implicitWidth: buttons.width

    implicitHeight: buttons.height

    property alias spacing: buttons.spacing

    Layout.minimumHeight: buttons.implicitHeight
    Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom

    ListModel {
        id: playmodel

        ListElement {
            icon: 'media-skip-backward'
        }
        ListElement {
            icon: 'media-playback-start'
        }
        ListElement {
            icon: 'media-playback-stop'
        }
        ListElement {
            icon: 'media-skip-forward'
        }
    }

    Component {
        id: toolButtonDelegate

        PlasmaComponents.ToolButton {
            id: toolButton
            iconSource: icon
            visible: !(index === 2) | showStop
            property int size: !showStop && index === 1 ? buttonSize.width * 1.4 : buttonSize.width
            Layout.minimumWidth: size
            Layout.minimumHeight: size
        }
    }

    RowLayout {
        id: buttons

        spacing: units.smallSpacing
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter

        Repeater {
            id: model
            model: playmodel
            delegate: toolButtonDelegate

            onItemAdded: {
                switch (index) {
                case 0:
                    item.clicked.connect(mpris2.previous)
                    item.enabled = Qt.binding(function () { return mpris2.canGoPrevious })
                    break
                case 1:
                    item.clicked.connect(mpris2.playPause)
                    item.enabled = Qt.binding(function () { return mpris2.canPlayPause })
                    item.iconSource = Qt.binding(function() {
                        return mpris2.playing ? 'media-playback-pause'
                                              : 'media-playback-start'
                    })
                    //NOTE: update icon playing state
                    break
                case 2:
                    item.clicked.connect(mpris2.stop)
                    item.enabled = Qt.binding(function () { return mpris2.canControl })
                    break
                case 3:
                    item.clicked.connect(mpris2.next)
                    item.enabled = Qt.binding(function () { return mpris2.canGoNext })
                    break
                }
            }
        }
    }
}
