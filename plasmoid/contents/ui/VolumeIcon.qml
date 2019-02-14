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
import org.kde.plasma.core 2.0 as PlasmaCore

IconWidget {
    id: icon

    property real volume: 0

    property real volumePrevious: 0

    readonly property bool muted: mpris2.volume.toFixed(1) <= 0.0

    size: units.iconSizes.small

    svg: PlasmaCore.Svg { imagePath: 'icons/audio' }

    iconSource: updateIcon()

    function updateIcon() {
        if (volume == 0)
            return 'audio-volume-muted'
        else if (volume <= 0.3)
            return 'audio-volume-low'
        else if (volume <= 0.6)
            return 'audio-volume-medium'
        return 'audio-volume-high'
    }

    onClicked: {
        if (!muted) {
            volumePrevious = mpris2.volume
            mpris2.setVolume(0.000001)
        } else
            mpris2.setVolume(volumePrevious)
    }
}
