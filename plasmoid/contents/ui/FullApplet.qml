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
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.plasmoid 2.0

Loader {
    id: fullApplet
    source: systray ? 'SystrayLayout.qml' : plasmoid.configuration.FullAppletLayout
    asynchronous: false

    width: item ? item.width : 0
    height: item ? item.height : 0

    Layout.minimumWidth: item ? item.Layout.minimumWidth : -1
    Layout.minimumHeight: item ? item.Layout.minimumHeight : -1
    Layout.maximumWidth: item ? item.Layout.maximumWidth : -1
    Layout.maximumHeight: item ? item.Layout.maximumHeight : -1
    Layout.preferredWidth: item ? item.Layout.preferredWidth : -1
    Layout.preferredHeight: item ? item.Layout.preferredHeight : -1

    Layout.fillWidth: true
    Layout.fillHeight: true
    Layout.margins: playbarEngine.backgroundHint === playbar.noBackground ? units.smallSpacing : 0

    //!HACK The class PlasmaComponents::PageStack try write on status but Loader::status is read-only
    property int status

    signal loadDefaultLayout
    signal loadVerticalLayout

    Connections {
        target: playbarEngine

        onExpandedStyleChanged: {
            if (systray) return

            if (playbarEngine.expandedStyle === playbar.horizontalLayout) {
                plasmoid.configuration.FullAppletLayout = 'DefaultLayout.qml'
            } else {
                plasmoid.configuration.FullAppletLayout = 'VerticalLayout.qml'
            }

            if (plasmoid.formFactor !== PlasmaCore.Types.Planar) {
                plasmoid.expanded = false
                fullApplet.sourceComponent = undefined
            }

            connectLayoutChangeRequests.start()
        }
    }

    Connections {
        target: playbarEngine

        onShowVolumeSliderChanged: {
            if (plasmoid.formFactor !== PlasmaCore.Types.Planar)
                playbarEngine.expandedStyleChanged()
        }

        onShowSeekSliderChanged: {
            if (plasmoid.formFactor !== PlasmaCore.Types.Planar)
                playbarEngine.expandedStyleChanged()
        }
    }

    onLoadDefaultLayout: {
        if (item)
            item.shouldChangeLayout.disconnect(loadDefaultLayout)
        plasmoid.configuration.FullAppletLayout = 'DefaultLayout.qml'
    }

    onLoadVerticalLayout: {
        if (item)
            item.shouldChangeLayout.disconnect(loadVerticalLayout)
        plasmoid.configuration.FullAppletLayout = 'VerticalLayout.qml'
    }

    Timer {
        id: connectLayoutChangeRequests
        running: false
        repeat: false
        interval: 300

        onTriggered: {
            if (item) {
                if (item.objectName === 'DefaultLayout') {
                    item.shouldChangeLayout.connect(loadVerticalLayout)
                } else {
                    item.shouldChangeLayout.connect(loadDefaultLayout)
                }
            }

            if (plasmoid.formFactor !== PlasmaCore.Types.Planar)
                source = plasmoid.configuration.FullAppletLayout
        }
    }

    onLoaded: {
        if (!systray)
            connectLayoutChangeRequests.start()
    }

    Keys.onReleased: {
        if (!event.modifiers) {
            event.accepted = true

            if (event.key === Qt.Key_Space || event.key === Qt.Key_K) {
                root.action_playPause()
            } else if (event.key === Qt.Key_P) {
                root.action_previous()
            } else if (event.key === Qt.Key_N) {
                root.action_next()
            } else if (event.key === Qt.Key_S) {
                root.action_stop()
            } else if (event.key === Qt.Key_Left || event.key === Qt.Key_J) {
                //seek back 5s
                mpris2.seek(Math.max(0, mpris2.position - 5))
            } else if (event.key === Qt.Key_Right || event.key === Qt.Key_L) {
                //seek forward 5s
                mpris2.seek(Math.min(mpris2.length, mpris2.position + 5))
            } else if (event.key === Qt.Key_Home) {
                mpris2.seek(0)
            } else if (event.key === Qt.Key_End) {
                mpris2.seek(mpris2.length - 3)
            } else if (event.key >= Qt.Key_0 && event.key <= Qt.Key_9) {
                //jump to percentage, ie. 0 = beginnign, 1 = 10% of total length etc
                mpris2.seek(mpris2.length * (event.key - Qt.Key_0) / 10)
            } else {
                event.accepted = false
            }
        }
    }
}
