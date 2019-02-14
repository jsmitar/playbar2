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
import org.kde.plasma.extras 2.0 as PlasmaExtras
import "../code/utils.js" as Utils

GridLayout {
    id: trackInfo

    rows: 3
    columns: 2
    rowSpacing: units.smallSpacing
    columnSpacing: units.largeSpacing
    clip: true
    focus: false

    Layout.minimumWidth: units.iconSizes.enormous * 1.5
    Layout.minimumHeight: implicitHeight
    Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter

    //BEGIN: ROW 0, COL_SPAN 2
    PlasmaExtras.Heading {
        id: title

        text: mpris2.playbackStatus === 'Stopped' ? i18n('No media playing') : mpris2.title
        level: 2
        opacity: playbarEngine.backgroundHint === playbar.noBackground ? 1.0 : 0.8

        wrapMode: scrollTitle.scrolling ? Text.NoWrap : Text.WrapAnywhere
        elide: scrollTitle.scrolling ? Text.ElideNone : Text.ElideRight
        verticalAlignment: Text.AlignTop
        maximumLineCount: 1
        lineHeight: 1.2

        Layout.fillWidth: true
        Layout.fillHeight: false
        Layout.columnSpan: 2

        AutoscrollText {
            id: scrollTitle
            target: title
            anchors.fill: parent
        }
    }
    //!END: ROW 0, COL_SPAN 2

    //!BEGIN: ROW 1, COl 1
    RowLayout {
        Layout.row: 1
        Layout.column: 1
        Layout.fillWidth: true
        Layout.fillHeight: false
        Layout.alignment: Qt.AlignTop
        clip: true

        PlasmaExtras.Heading {
            id: artist

            text: mpris2.artist || mpris2.album
            level: 3
            opacity: playbarEngine.backgroundHint === playbar.noBackground ? 0.9 : 0.6

            wrapMode: scrollArtist.scrolling ? Text.NoWrap : Text.WrapAnywhere
            elide: scrollArtist.scrolling ? Text.ElideNone : Text.ElideRight
            verticalAlignment: Text.AlignTop
            maximumLineCount: 1
            lineHeight: 1.1

            Layout.fillWidth: true
            Layout.fillHeight: false
            Layout.alignment: Qt.AlignLeft | Qt.AlignBaseline

            AutoscrollText {
                id: scrollArtist
                target: artist
                anchors.fill: parent
            }
        }
    }
    //!END: ROW 1, COL 1

    //!BEGIN: ROW 2, COL 1
    RowLayout {
        Layout.row: 2
        Layout.column: 1
        Layout.fillWidth: true
        Layout.fillHeight: false
        Layout.alignment: Qt.AlignTop
        clip: true

        PlasmaExtras.Heading {
            id: album

            text: mpris2.artist ? mpris2.album : ''
            level: 3
            opacity: playbarEngine.backgroundHint === playbar.noBackground ? 0.9 : 0.6

            wrapMode: scrollAlbum.scrolling ? Text.NoWrap : Text.WrapAnywhere
            elide: scrollAlbum.scrolling ? Text.ElideNone : Text.ElideRight
            verticalAlignment: Text.AlignTop
            maximumLineCount: 1
            lineHeight: 1.1

            Layout.fillWidth: true
            Layout.fillHeight: false
            Layout.alignment: Qt.AlignLeft | Qt.AlignBaseline

            AutoscrollText {
                id: scrollAlbum
                target: album
                anchors.fill: parent
            }
        }
    }
    //!END: ROW 2, COL 1

    //!BEGIN: ROW 1, COL 0
    PlasmaExtras.Paragraph {
        id: by

        text: mpris2.artist ? i18n('By') : i18n('On')
        color: Utils.adjustAlpha(theme.textColor, 0.8)
        visible: artist.text
        verticalAlignment: Text.AlignTop
        lineHeight: 1.1

        Layout.row: 1
        Layout.column: 0
        Layout.fillHeight: false
        Layout.alignment: Qt.AlignRight | Qt.AlignBaseline
    }
    //!END: ROW 1, COL 0

    //!BEGIN: ROW 2, COL 0
    PlasmaExtras.Paragraph {
        id: on

        text: i18n('On')
        color: Utils.adjustAlpha(theme.textColor, 0.8)
        visible: album.text
        verticalAlignment: Text.AlignTop
        lineHeight: 1.1

        Layout.row: 2
        Layout.column: 0
        Layout.fillHeight: false
        Layout.alignment: Qt.AlignRight | Qt.AlignBaseline
    }
    //!END: ROW 2, COL 0
}
