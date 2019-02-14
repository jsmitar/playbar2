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
// VerticalLayout
//###########
ColumnLayout {
    id: page
    objectName: 'VerticalLayout'

    spacing: units.smallSpacing

    width: units.iconSizes.enormous * 1.7
    height: units.iconSizes.enormous * 4

    Layout.minimumWidth: units.iconSizes.enormous * 1.4
    Layout.minimumHeight: implicitHeight
    Layout.maximumWidth: plasmoid.formFactor === PlasmaCore.Types.Planar
        ? -1 : units.iconSizes.enormous * 1.7
    Layout.preferredWidth: units.iconSizes.enormous * 1.7
    Layout.preferredHeight: height
    Layout.fillWidth: true
    Layout.fillHeight: true

    signal shouldChangeLayout

    Connections {
        target: page
        enabled: plasmoid.formFactor === PlasmaCore.Types.Planar

        onWidthChanged: if (height + units.iconSizes.medium < width)
                            shouldChangeLayout()
    }

    CoverArt {
        id: cover
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.minimumWidth: Math.min(page.width, height)
        Layout.minimumHeight: Math.min(page.width, height)
        Layout.alignment: Qt.AlignCenter
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
        Layout.fillWidth: true
        Layout.fillHeight: false
        Layout.minimumWidth: units.iconSizes.enormous
        Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
    }
    PlaybackWidget {
        id: controls
        Layout.fillWidth: false
        Layout.fillHeight: false
        Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
    }
    SliderVolume {
        id: volume
        Layout.fillHeight: false
        Layout.alignment: Qt.AlignCenter
    }
    SliderSeek {
        id: seek
        Layout.fillHeight: false
        Layout.alignment: Qt.AlignCenter
    }

    layer.enabled: playbarEngine.backgroundHint === playbar.noBackground
    layer.effect: DropShadow {
        source: page
        anchors.fill: source
        color: playbarEngine.shadowColor
        radius: 4.0
        samples: 9
        transparentBorder: true
        verticalOffset: 1
        horizontalOffset: 1
    }
}
