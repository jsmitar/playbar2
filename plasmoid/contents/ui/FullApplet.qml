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
import QtQuick.Layouts 1.1
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore

Loader {
        source: 'DefaultLayout.qml'
 	Layout.fillWidth: true
 	Layout.fillHeight: true

//!HACK The class PlasmaComponents::PageStack try write on status but Loader::status is read-only
 	property int status

        signal loadDefaultLayout
        signal loadVerticalLayout

        onLoadDefaultLayout: {
                if ( item ) item.shouldChangeLayout.disconnect( loadDefaultLayout )
                Layout.minimumWidth = 50
                Layout.minimumHeight = 50
                Layout.preferredWidth = 50
                Layout.preferredHeight = 50
                source = 'DefaultLayout.qml'
        }

        onLoadVerticalLayout: {
                if ( item ) item.shouldChangeLayout.disconnect( loadVerticalLayout )
                Layout.minimumWidth = 50
                Layout.minimumHeight = 50
                Layout.preferredWidth = 50
                Layout.preferredHeight = 50
                source = 'VerticalLayout.qml'
        }

        Timer {
                id: connectLayoutChangeRequests
                running: false
                repeat: false
                interval: 1000
                onTriggered: {
                        if ( item.objectName === 'DefaultLayout' ) {
                                item.shouldChangeLayout.connect( loadVerticalLayout )
                        } else {
                                item.shouldChangeLayout.connect( loadDefaultLayout )
                        }
                }
        }

        onLoaded: {
                Layout.minimumWidth =
                        Qt.binding( function() { return item.Layout.minimumWidth } )
                Layout.minimumHeight =
                        Qt.binding( function() { return item.Layout.minimumHeight } )
                Layout.preferredWidth =
                        Qt.binding( function() { return item.Layout.preferredWidth } )
                Layout.preferredHeight =
                        Qt.binding( function() { return item.Layout.preferredHeight } )

                connectLayoutChangeRequests.start()
        }
}
