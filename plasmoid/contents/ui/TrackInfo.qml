import QtQuick 2.4
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

    RowLayout {
        Layout.row: 1
        Layout.column: 1
        Layout.fillWidth: true
        Layout.fillHeight: false
        Layout.alignment: Qt.AlignTop
        clip: true

        children: [artist]
    }

    PlasmaExtras.Heading {
        id: artist

        text: mpris2.artist
        level: 3
        opacity: playbarEngine.backgroundHint === playbar.noBackground ? 1.0 : 0.8

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

    RowLayout {
        Layout.row: 2
        Layout.column: 1
        Layout.fillWidth: true
        Layout.fillHeight: false
        Layout.alignment: Qt.AlignTop

        clip: true
        children: [album]
    }

    PlasmaExtras.Heading {
        id: album

        text: mpris2.album
        level: 3
        opacity: playbarEngine.backgroundHint === playbar.noBackground ? 1.0 : 0.8

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

    PlasmaExtras.Paragraph {
        id: by

        text: i18n('By')
        color: Utils.adjustAlpha(theme.textColor, 0.8)
        visible: mpris2.artist.length > 0
        verticalAlignment: Text.AlignTop
        lineHeight: 1.1

        Layout.row: 1
        Layout.column: 0
        Layout.fillHeight: false
        Layout.alignment: Qt.AlignRight | Qt.AlignBaseline
    }

    PlasmaExtras.Paragraph {
        id: on

        text: i18n('On')
        color: Utils.adjustAlpha(theme.textColor, 0.8)
        visible: mpris2.album.length > 0
        verticalAlignment: Text.AlignTop
        lineHeight: 1.1

        Layout.row: 2
        Layout.column: 0
        Layout.fillHeight: false
        Layout.alignment: Qt.AlignRight | Qt.AlignBaseline
    }
}
