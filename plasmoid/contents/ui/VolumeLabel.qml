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
import org.kde.plasma.components 2.0 as PlasmaComponents

PlasmaComponents.Label {
    id: label

    property real volume: 0

    wrapMode: Text.NoWrap
    elide: Text.ElideNone
    maximumLineCount: 1
    font: theme.smallestFont
    opacity: 0.8
    text: (volume * 100).toFixed() + '%'
}
