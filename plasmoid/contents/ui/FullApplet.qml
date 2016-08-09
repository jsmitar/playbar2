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
    source: plasmoid.configuration.FullAppletLayout
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
        interval: 100
        onTriggered: {
            if (item.objectName === 'DefaultLayout') {
                item.shouldChangeLayout.connect(loadVerticalLayout)
            } else {
                item.shouldChangeLayout.connect(loadDefaultLayout)
            }
        }
    }

    onLoaded: {
        connectLayoutChangeRequests.start()
    }
}
