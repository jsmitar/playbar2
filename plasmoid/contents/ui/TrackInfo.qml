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
	Layout.minimumHeight: units.iconSizes.huge
	Layout.fillWidth: true
	Layout.fillHeight: true
	Layout.alignment: Qt.AlignLeft | Qt.AlignTop


	PlasmaExtras.Heading{
		id: title

		text: mpris2.title
		level: 2
		color: theme.textColor

		wrapMode: scrollTitle.scrolling ? Text.NoWrap : Text.WrapAnywhere
		elide: scrollTitle.scrolling ? Text.ElideNone : Text.ElideRight
		verticalAlignment: Text.AlignVCenter
		maximumLineCount: 1
		lineHeight: 1.2

		Layout.fillWidth: true
		Layout.fillHeight: false
		Layout.columnSpan: 2

		AutoscrollText{
			id: scrollTitle
			target: title
			anchors.fill: parent
		}
	}

	RowLayout{
		Layout.row: 1
		Layout.column: 1
		Layout.fillWidth: true
		Layout.fillHeight: false
		Layout.alignment: Qt.AlignTop

		clip: true
		children: [artist]
	}

	PlasmaExtras.Heading{
		id: artist

		text: mpris2.artist
		level: 3
		color: Utils.adjustAlpha(theme.textColor, 0.9)
		visible: mpris2.artist.length > 0

		wrapMode: scrollArtist.scrolling ? Text.NoWrap : Text.WrapAnywhere
		elide: scrollArtist.scrolling ? Text.ElideNone : Text.ElideRight
		verticalAlignment: Text.AlignVCenter
		maximumLineCount: 1
		lineHeight: 1.1

		Layout.fillWidth: true
		Layout.fillHeight: false

		AutoscrollText{
			id: scrollArtist
			target: artist
			anchors.fill: parent
		}
	}

	RowLayout{
		Layout.row: 2
		Layout.column: 1
		Layout.fillWidth: true
		Layout.fillHeight: false
		Layout.alignment: Qt.AlignTop

		clip: true
		children: [album]
	}

	PlasmaExtras.Heading{
		id: album

		text: mpris2.album
		level: 3
		color: Utils.adjustAlpha(theme.textColor, 0.9)
		visible: mpris2.album.length > 0

		wrapMode: scrollAlbum.scrolling ? Text.NoWrap : Text.WrapAnywhere
		elide: scrollAlbum.scrolling ? Text.ElideNone : Text.ElideRight
		verticalAlignment: Text.AlignVCenter
		maximumLineCount: 1
		lineHeight: 1.1

		Layout.fillWidth: true
		Layout.fillHeight: false

		AutoscrollText{
			id: scrollAlbum
			target: album
			anchors.fill: parent
		}
	}

	PlasmaExtras.Heading{
		id: by

		text: i18n("By")
		level: 5
		color: Utils.adjustAlpha(theme.textColor, 0.8)
		visible: mpris2.artist.length > 0

		Layout.row: 1
		Layout.column: 0
		Layout.fillHeight: false
		Layout.alignment: Qt.AlignRight | Qt.AlignBaseline
	}

	PlasmaExtras.Heading{
		id: on

		text: i18n("On")
		level: 5
		color: Utils.adjustAlpha(theme.textColor, 0.8)
		visible: mpris2.album.length > 0

		Layout.row: 2
		Layout.column: 0
		Layout.fillHeight: false
		Layout.alignment: Qt.AlignRight | Qt.AlignBaseline
	}
}
