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
import QtGraphicalEffects 1.0
import org.kde.plasma.core 2.0 as PlasmaCore

//###########
// DefaultLayout
//###########
GridLayout {
    id: page
    objectName: 'DefaultLayout'

    columns: 2
    rows: 4
    rowSpacing: units.smallSpacing
    columnSpacing: units.largeSpacing

    Layout.fillWidth: true
    Layout.fillHeight: true
    Layout.minimumWidth: units.iconSizes.enormous * 3
    Layout.minimumHeight: page.implicitHeight
    Layout.preferredWidth: units.iconSizes.enormous * 3
    Layout.preferredHeight: page.implicitHeight

    signal shouldChangeLayout

    state: 'square'

    Connections {
        target: page
        enabled: plasmoid.formFactor === PlasmaCore.Types.Planar

        onWidthChanged: if (height + units.iconSizes.medium > width)
                            shouldChangeLayout()
    }

    CoverArt {
        id: cover
        Layout.row: 0
        Layout.column: 0
        Layout.rowSpan: 2
        Layout.fillWidth: false
        Layout.fillHeight: true
        Layout.minimumWidth: height
        Layout.minimumHeight: units.iconSizes.enormous
        Layout.alignment: Qt.AlignBottom
        Layout.maximumWidth: page.width / 2 - units.iconSizes.medium
        opacity: mpris2.sourceActive ? 1 : 0.3

        SourceSelectorButton {
            anchors {
                top: cover.top
                left: cover.left
                topMargin: cover.coverTopMargin
                leftMargin: cover.coverLeftMargin
            }
        }
    }
    TrackInfo {
        id: trackInfo
        Layout.row: 0
        Layout.column: 1
        Layout.fillWidth: true
        Layout.fillHeight: false
        Layout.alignment: Qt.AlignLeft | Qt.AlignBottom
    }
    PlaybackWidget {
        id: controls
        Layout.row: 1
        Layout.column: 1
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
    }
    SliderVolume {
        id: volume
        Layout.row: 2
        Layout.columnSpan: 2
        Layout.fillHeight: true
        Layout.alignment: Qt.AlignCenter
    }
    SliderSeek {
        id: seek

        Layout.row: 3
        Layout.columnSpan: 2
        Layout.fillHeight: false
        Layout.alignment: Qt.AlignCenter
    }

    layer.enabled: playbarEngine.backgroundHint === playbar.noBackground
    layer.effect: DropShadow {
        source: page
        radius: 4.0
        samples: 9
        transparentBorder: true
        spread: 0.2
        color: playbarEngine.shadowColor
        anchors.fill: source
    }
}
