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

//###########
// DefaultLayout
//###########
GridLayout {
    id: page
    objectName: 'SystrayLayout'

    columns: 2
    rows: 6
    rowSpacing: units.smallSpacing
    columnSpacing: units.largeSpacing

    Layout.fillWidth: true
    Layout.fillHeight: true
    Layout.minimumWidth: units.iconSizes.enormous * 3
    Layout.minimumHeight: page.implicitHeight
    Layout.preferredWidth: units.iconSizes.enormous * 3
    Layout.preferredHeight: page.implicitHeight

    signal shouldChangeLayout

    CoverArt {
        id: cover
        Layout.row: 0
        Layout.column: 0
        Layout.fillWidth: false
        Layout.fillHeight: true
        Layout.minimumWidth: height
        Layout.minimumHeight: units.iconSizes.enormous
        Layout.alignment: Qt.AlignBottom
        Layout.maximumWidth: page.width / 2 - units.iconSizes.medium
    }
    TrackInfo {
        id: trackInfo
        Layout.row: 0
        Layout.column: 1
        Layout.fillWidth: true
        Layout.fillHeight: false
        Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
    }
    PlaybackWidget {
        id: controls
        Layout.row: 1
        Layout.column: 0
        Layout.columnSpan: 2
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
        readonly property int iconSize:
            units.roundToIconSize(units.iconSizes.large * (volume.visible || seek.visible ? 1.4 : 1.6))

        buttonSize: Qt.size(iconSize, iconSize)
        spacing: showStop ? units.smallSpacing : units.largeSpacing
    }
    SliderVolume {
        id: volume
        Layout.row: 3
        Layout.columnSpan: 2
        Layout.fillHeight: true
        Layout.alignment: Qt.AlignCenter
    }
    SliderSeek {
        id: seek
        Layout.row: 4
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
