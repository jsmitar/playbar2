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
import org.kde.plasma.graphicswidgets 0.1 as PlasmaWidgets
import org.kde.plasma.components  0.1

Item{
id: layouts

resources: [defaultLayout, minimalLayout, coolLayout]

property variant spotifyLayout: minimalLayout


//###########
// Cool
//###########
Component{
	id: coolLayout

	Item{

		width: childrenRect.width + 8
		height: childrenRect.height

		Flow{
			id: headCover
			spacing: 8

			CoverArt{
				id: cover
				size: 120

				Frame{
					id: frame
					width: cover.width - 4
					height: playback.height

					onEntered: fadeIn()

					anchors{
						horizontalCenter: parent.horizontalCenter
						bottom: cover.bottom
						bottomMargin: 8
					}
				}
				PlaybackWidget{
					id: playback

					buttonSize: 24
					opacity: frame.opacity + 0.2

					anchors{
						verticalCenter: frame.verticalCenter
						horizontalCenter: parent.horizontalCenter
					}

					MouseArea{
						id: playArea

						hoverEnabled: true
						acceptedButtons: Qt.NoButton
						anchors.fill: parent
						onEntered: frame.entered()
						onExited: if(!frame.containsMouse) frame.fadeOut()
					}
				}
			}

			Item{
				id: bar
				children: [info, time, seek, rating]
				height: cover.height
				width: childrenRect.width
			}

			TrackInfo{
				id: info
				contentHeight: 25
				albumArtistPointsize: 11
				titleFontWeight: Font.DemiBold
				width: 250
			}
			Row{
				id: time

				anchors{
					right: seek.right
					bottom: seek.top
					bottomMargin: 1
				}

				TimeLabel{
					id: positionTime

					hover: true
					topTime: mpris.length
					autoTimeTrigger: mpris.isMaximumLoad
					negative: plasmoid.readConfig('timeNegative')
				}
				Label{
					text: ' / '
				}
				TimeLabel{
					id: lengthTime
					currentTime: mpris.length
					autoTimeTrigger: mpris.isMaximumLoad
				}
			}
			RatingItem{
				id: rating
				sizeIcon: 16

				anchors{
					left: seek.left
					bottom: seek.top
					bottomMargin: 8
				}
			}
			SliderSeek{
				id: seek
				width: info.width
				labelVisible: false

				anchors{
					bottom: parent.bottom
					horizontalCenter: info.horizontalCenter
				}

				onCurrentSeekPosition: {
					positionTime.currentTime = position
					positionTime.timeChanged()
				}

			}
			Volume{
				id: volume
				visible: false
				width: 0
			}
		}
	}
}

//###########
// Minimalist
//###########
Component{
	id: minimalLayout

	Item{
		height: cover.height + 4
		width: 350

		CoverArt{
			id: cover

			anchors{
				rightMargin: 8
				leftMargin: 4
				verticalCenter: parent.verticalCenter
			}
		}
		PlasmaWidgets.Separator{
			id: separator

			orientation: Qt.Vertical

			anchors{
				left: cover.right
				top: cover.top
				bottom: cover.bottom
				topMargin: 4
				bottomMargin: 4
				leftMargin: 8
				rightMargin: 8
			}
		}
		TrackInfo{
			id: info

			anchors{
				leftMargin: 8
				rightMargin: volume.visible ? 10 : 4
				left: separator.right
				right: volume.visible ? volume.left : parent.right
				top: parent.top
				bottom: playback.top
			}
		}
		PlaybackWidget{
			id: playback
			spacing: 8

			anchors{
				bottom: parent.bottom
				topMargin: 4
				horizontalCenter: parent.horizontalCenter
				horizontalCenterOffset: cover.width / 2 - (isSpotify ? 0 : 8)
			}
		}
		Volume{
			id: volume

			iconVisible: false
			labelVisible: false
			orientation: QtVertical

			visible: !isSpotify

			width: 16
			height: cover.height - 6

			anchors{
				verticalCenter: cover.verticalCenter
				right: parent.right
			}
		}
	}
}


//###########
// Default
//###########
Component{
	id: defaultLayout

	Item{
		height: cover.height + 4
		width: 500

		CoverArt{
			id: cover

			anchors{
				rightMargin: 8
				leftMargin: 4
				verticalCenter: parent.verticalCenter
			}
		}
		PlaybackWidget{
			id: playback

			anchors{
				leftMargin: 8
				rightMargin: 8
				topMargin: 2
				top: parent.top
				left: cover.right
			}
		}
		RatingItem{
			id: rating

			anchors{
				topMargin: 10
				horizontalCenter: playback.horizontalCenter
				top: playback.bottom
				bottom: seek.top
			}
		}
		PlasmaWidgets.Separator{
			id: separator

			orientation: Qt.Vertical

			anchors{
				margins: 6
				bottomMargin: 14
				top: playback.top
				bottom: seek.top
				left: playback.right
			}
		}
		TrackInfo{
			id: info

			widthLabelArtist: width - volume.width - 12
			widthLabelAlbum:  width - volume.width - 12

			anchors{
				leftMargin: 8
				rightMargin: 4
				left: separator.right
				right: parent.right
				top: parent.top
			}
		}
		Volume{
			id: volume

			width: 120
			anchors{
				rightMargin: 4
				leftMargin: 8
				bottomMargin: 4
				bottom: seek.top
				right: info.right
			}
		}
		SliderSeek{
			id: seek

			width: parent.width - cover.width - 16
			anchors{
				leftMargin: 10
				left: cover.right
				bottom: cover.bottom
				bottomMargin: -4
			}
		}
	}
}


}
