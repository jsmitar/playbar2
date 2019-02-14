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

PlasmaComponents.ToolButton {
    id: mediaSelector

    opacity: (parent.containsMouse || hovered) ? 1 : 0
    visible: repeater.count >= 1

    Behavior on opacity {
        NumberAnimation {
            duration: units.longDuration
        }
    }

    Behavior on anchors.leftMargin {
        NumberAnimation {
            duration: units.longDuration
        }
    }

    Behavior on anchors.topMargin {
        NumberAnimation {
            duration: units.longDuration
        }
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
            } else {
                var instance = source.match(/\.instance[0-9]+/)
                instance = instance ? instance[0].replace('.instance',
                                                          ' Instance:') : ''
                text = mpris2.getIdentity(source) + instance
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
            id: menuItemNext
            text: i18n('Next multimedia source')
            onClicked: {
                mpris2.nextSource()
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
                readonly property var sources: mpris2.sources.filter(
                                                   function (e) {
                                                       return e !== '@multiplex'
                                                   }).sort()

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
