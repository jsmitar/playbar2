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
.pragma library

var iconApplication
var plasmoid
var i18n

function setActions(sourceActive, identity){
	var icon

	if(sourceActive == "") return
	icon = sourceActive

	if(sourceActive.match('vlc'))
		icon = 'vlc'

	switch(sourceActive){
		case 'spotify':
			icon = 'spotify-client'
			break
		case 'clementine':
			icon = 'application-x-clementine'
	}
	iconApplication = icon
	print(iconApplication)

	plasmoid.setAction('raise', i18n("Open %1", identity), icon)
	plasmoid.setAction('quit', i18n("Quit"), 'window-close')
	plasmoid.setAction('nextSource', i18n("Next multimedia source"), 'go-next')
	plasmoid.setActionSeparator('sep1')

}

function removeActions(){
	plasmoid.removeAction('raise')
	plasmoid.removeAction('quit')
	plasmoid.removeAction('nextSource')
	plasmoid.removeAction('sep1')
}

//  Color manipulation utilities
//  Take it from Breeze porject
function blendColors(clr0, clr1, p) {
	return Qt.tint(clr0, adjustAlpha(clr1, p));
}

function adjustAlpha(clr, a) {
	return Qt.rgba(clr.r, clr.g, clr.b, a);
}


