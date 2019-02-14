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
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.extras 2.0 as PlasmaExtras
import "../code/utils.js" as Utils

RowLayout {
    Layout.minimumHeight: implicitHeight + units.smallSpacing
    Layout.maximumHeight: implicitHeight + units.smallSpacing
    Layout.fillWidth: true
    Layout.fillHeight: false
    visible: false

    PlasmaExtras.Heading {
        id: titleBar
        Layout.fillWidth: true
        level: 2
        lineHeight: 1.2
        text: mpris2.identity
        enabled: mpris2.sourceActive
    }

    PlasmaComponents.ToolButton {
        id: menuButton
        visible: false
        property var contextMenu
        Layout.fillWidth: false
        Layout.fillHeight: false
        Layout.alignment: Qt.AlignRight | Qt.AlignTop
        enabled: mpris2.sourceActive
        iconSource: 'configure'
        onClicked: {
            if (!contextMenu)
                contextMenu = contextMenuComponent.createObject(menuButton)
            contextMenu.open()
        }
    }

    Component {
        id: contextMenuComponent

        PlasmaComponents.ContextMenu {
            visualParent: menuButton

            PlasmaComponents.MenuItem {
                icon: Utils.iconApplication
                text: i18n('Open %1', mpris2.identity)
                onClicked: action_raise()
            }
            PlasmaComponents.MenuItem {
                icon: 'media-playback-stop'
                text: i18n('Stop')
                onClicked: action_stop()
            }
            PlasmaComponents.MenuItem {
                icon: 'window-close'
                text: i18n('Quit')
                onClicked: action_quit()
            }
            PlasmaComponents.MenuItem {
                icon: 'go-next'
                text: i18n('Next multimedia source')
                onClicked: action_nextSource()
            }
        }
    }
}
