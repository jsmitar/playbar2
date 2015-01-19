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
import org.kde.plasma.core 0.1 as PlasmaCore
import "plasmapackage:/code/control.js" as Control

Item{
    id: ratingItem

    property real rating: mpris.userRating

    property int sizeIcon: 18

    implicitHeight: content.implicitHeight

    implicitWidth: content.implicitWidth

    property variant svgId:
    {
        'low'    : "rating-low",
        'medium' : "rating-medium",
        'high'   : "rating-high"
    }

	Component.onCompleted: {
		for(i = 0; i < 5; i++){
			plasmoid.addEventListener('configChanged', function(){
				ratingItems.itemAt(i).Svg = ratingItems.itemAt(i).update()
			})
			mpris.ratingChanged.connect(ratingItems.itemAt(i).fetchRating)
		}
	}

    Component{
        id: svgDelegate
        PlasmaCore.SvgItem{
			svg: update()
            implicitWidth: sizeIcon
            implicitHeight: sizeIcon

			function update(){
				if(plasmoid.readConfig("opaqueIcons") == true)
					  return Svg(plasmoid.readConfig("rating-opaque"))
				else return Svg(plasmoid.readConfig("rating-clear"))
			}

            function fetchRating() {
                var iRating = (index + 1)/5
                if ( rating >= iRating )
                    elementId = svgId['high']
                else if ( rating.toFixed(1) == (iRating - 0.1).toFixed(1) )
                    elementId = svgId['medium']
                else
                    elementId = svgId['low']
				elementIdChanged()
            }

			Component.onCompleted: {
				fetchRating()
				plasmoid.addEventListener('configChanged', function(){
					fetchRating()
					svg = update()
					print(elementId)
				})
			}

			Component.onDestruction: {
				mpris.ratingChanged.disconnect(fetchRating)
			}
        }
    }

    Row{
        id: content
        spacing: 3
		opacity: rating < 0.1 ? 0.7 : 1

		Behavior on opacity{ NumberAnimation{duration: 250} }

		Repeater{
            id: ratingItems
            model: 5
            delegate: svgDelegate
        }
    }
}
