// -*- coding: iso-8859-1 -*-
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

import QtQuick 1.1
import org.kde.plasma.components 0.1
import "plasmapackage:/ui/" as PlayBar

Item{
    id: trackInfo

	property alias widthLabelArtist: artist.width

	property alias widthLabelAlbum: album.width

	property alias contentHeight: artist.height

	property alias titleFontWeight: title.font.weight

	property int albumArtistPointsize: 10

	implicitHeight: content.height

	Column{
		id: content
		clip: true
		spacing: -2
		width: parent.width
		height: childrenRect.height

		Label{
			id: title

			text: mpris.title
			wrapMode: Text.WrapAnywhere
			elide: Text.ElideRight
			maximumLineCount: 1
			visible: mpris.title != ""

			font.pointSize: 14

			width: parent.width
			lineHeight: 1.2

			property bool isWrapped: implicitWidth > width ? true : false

			function normalState(){
				wrapMode = Text.WrapAnywhere
				x = 0
				state = ''
			}

			states: State{
				name: 'scroll'
				PropertyChanges{
					target: title
					wrapMode: Text.NoWrap
					x: width / 1.1 - implicitWidth
				}
			}

			Behavior on x{
				SequentialAnimation{
					//TODO: Change to PropertyAction
					PropertyAnimation{
						property: 'wrapMode'
						duration: 0
					}
					SmoothedAnimation{
						property: 'x'
						velocity: 60
					}
					PauseAnimation{ duration: 120 }
					SmoothedAnimation{
						to: 0
						property: 'x'
						velocity: 70
					}
					ScriptAction{ script: title.normalState() }
				}
			}
			MouseArea{
				id: mouse

				acceptedButtons: Qt.NoButton
				anchors.fill: title
				hoverEnabled: true
				onEntered:	if(title.isWrapped)	title.state = 'scroll'
			}
		}

		Column{
			clip: true
			children: [artist, album]
		}

		Label{
			id: artist

			text: i18n("By %1", mpris.artist)
			wrapMode: Text.WrapAnywhere
			elide: Text.ElideRight
			maximumLineCount: 1
			font.pointSize: albumArtistPointsize
			visible: mpris.artist != ""

			height: 12
			width: content.width

			property bool isWrapped: implicitWidth > width ? true : false

			function normalState(){
				wrapMode = Text.WrapAnywhere
				x = 0
				state = ""
			}

			states: State{
				name: 'scroll'
				PropertyChanges{
					target: artist
					wrapMode: Text.NoWrap
					x: width / 1.1 - implicitWidth
				}
			}

			Behavior on x{
				SequentialAnimation{
					PropertyAnimation{
						property: 'wrapMode'
						duration: 0
					}
					SmoothedAnimation{
						property: 'x'
						velocity: 60
					}
					PauseAnimation { duration: 120 }
					SmoothedAnimation{
						to: 0
						property: 'x'
						velocity: 70
					}
					ScriptAction{ script: artist.normalState() }
				}
			}
			MouseArea{
				acceptedButtons: Qt.NoButton
				anchors.fill: parent
				hoverEnabled: true
				onEntered:	if(artist.isWrapped) artist.state = 'scroll'
			}
		}

		Label{
			id: album

			text:  i18n("On %1", mpris.album)
			wrapMode: Text.WrapAnywhere
			elide: Text.ElideRight
			maximumLineCount: 1

			font.pointSize: albumArtistPointsize

			visible: mpris.album != ""

			width: content.width

			property bool isWrapped: implicitWidth > width ? true : false

			function normalState(){
				wrapMode = Text.WrapAnywhere
				state = ""
			}

			states: State{
				name: 'scroll'
				PropertyChanges{
					target: album
					wrapMode: Text.NoWrap
					x: width / 1.1 - implicitWidth
				}
			}

			Behavior on x{
				SequentialAnimation{
					PropertyAnimation{
						property: 'wrapMode'
						duration: 0
					}
					SmoothedAnimation{
						property: 'x'
						velocity: 60
					}
					PauseAnimation { duration: 120 }
					SmoothedAnimation{
						to: 0
						property: 'x'
						velocity: 70
					}
					ScriptAction{ script: album.normalState() }
				}
			}

			MouseArea{
				acceptedButtons: Qt.NoButton
				anchors.fill: parent
				hoverEnabled: true
				onEntered:	if(album.isWrapped) album.state = 'scroll'
			}
		}
	}
}
