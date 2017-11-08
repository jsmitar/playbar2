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
import QtQuick.Layouts 1.2
import QtQuick.Controls 1.4
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import QtGraphicalEffects 1.0

Item {
    id: bg

    width: units.iconSizes.enormous
    height: units.iconSizes.enormous

    Layout.fillWidth: true
    Layout.fillHeight: true

    PlasmaCore.IconItem {
        id: noCover

        anchors.fill: parent
        source: 'nocover'
        smooth: true
        opacity: mpris2.sourceActive ? 1 : 0.3
        visible: cover.status === Image.Null || cover.status === Image.Error
    }

    Image {
        id: cover

        source: mpris2.artUrl
        fillMode: Image.PreserveAspectFit
        anchors.fill: parent
        mipmap: true
        asynchronous: true
        cache: false

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

    PlasmaComponents.ToolButton {
        id: mediaSelector

        readonly property int paintedWidth: noCover.visible ? noCover.paintedWidth : cover.paintedWidth
        readonly property int paintedHeight: noCover.visible ? noCover.paintedHeight : cover.paintedHeight

        anchors {
            left: cover.left
            top: cover.top
            leftMargin: (bg.width - paintedWidth) / 2 + units.smallSpacing
            topMargin: (bg.height - paintedHeight) / 2 + units.smallSpacing
        }

        opacity: (toggleWindow.containsMouse || hovered) ? 1 : 0
        visible: repeater.count >= 2

        Behavior on opacity {
            NumberAnimation { duration: units.longDuration }
        }

        Behavior on anchors.leftMargin {
            NumberAnimation { duration: units.longDuration }
        }

        Behavior on anchors.topMargin {
            NumberAnimation { duration: units.longDuration }
        }

        iconName: mpris2.icon(mpris2.currentSource)
        onClicked: menu.open()

        PlasmaComponents.ContextMenu {
            id: menu
            visualParent: mediaSelector

            function caption(source) {
                var text = 'None'

                if (source === "@multiplex") {
                    text = i18n("Select automatically")
                } else if (source && mpris2.currentSource === source) {
                    text = mpris2.capitalize(source)
                } else {
                    var e = mpris2.recentSources.find(function (e) {
                        return e.source === source
                    });

                    if (!e)
                        text = source[0].toUpperCase() + source.substr(1)
                    else
                        text = e.identity
                }

                return text
            }

            function changeSource(source) {
                if (mpris2.currentSource !== source) {
                    if (mpris2.sourceActive)
                        mpris2.disconnectSource(mpris2.currentSource)

                    mpris2.connectSource(source)
                    playbarEngine.setSource(source)
                }
            }


            PlasmaComponents.MenuItem {
                id: menuItemAuto
                readonly property string source: '@multiplex'
                text: menu.caption(source)
                onClicked: {
                    sourceChanged()
                    menu.changeSource(source)
                }
                checkable: true
                Binding {
                    target: menuItemAuto
                    property: 'checked'
                    value: mpris2.currentSource === menuItemAuto.source
                }
            }

            //!BEGIN: Media players menu items
            readonly property Item _items: Item {
                Repeater {
                    id: repeater
                    readonly property var sources: mpris2.sources.filter(function(e){ return e !== '@multiplex' })

                    model: sources.length
                    onItemAdded: menu.addMenuItem(item)
                    onItemRemoved: menu.removeMenuItem(item)

                    delegate: PlasmaComponents.MenuItem {
                        id: menuItem
                        readonly property string source: repeater.sources[index]
                        text: menu.caption(source)
                        onClicked: {
                            sourceChanged()
                            menu.changeSource(source)
                        }
                        checkable: true

                        Binding {
                            target: menuItem
                            property: 'checked'
                            value: mpris2.currentSource === menuItem.source
                        }
                    }
                }
            }
            //!END: Media players menu items
        }

    }
}
