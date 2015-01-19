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

.pragma library

var source
var serv
var identity
var icon

var currentVolume = 0
var openedPopup = false


function setSource(sourceName, identity){
	if(sourceName == source) return

	source = sourceName
	serv = service("mpris2", sourceName)
	if(sourceName != "" ) setActions(sourceName, identity)
	else removeActions()
}

function seek(position, currentPosition){
	if(source == 'clementine') {
		seekRelative(position, currentPosition)
		return
	}

	job = serv.operationDescription('SetPosition')
	job['microseconds'] = (position * 1000).toFixed(0)
	serv.startOperationCall(job)
}

function seekRelative(position, currentPosition){
	job = serv.operationDescription('Seek')
	job['microseconds'] = ((-currentPosition + position) * 1000).toFixed(0)
	serv.startOperationCall(job)
}

function startOperation(name){
	job = serv.operationDescription(name)
	serv.startOperationCall(job)
}

function setVolume(value){
	job = serv.operationDescription('SetVolume')
	job['level'] = value
	serv.startOperationCall(job)
}

function setActions(sourceName, identity){

	if(sourceName.match('vlc')){
		icon = 'vlc'
	}else{
		icon = sourceName
	}

	switch(sourceName){
		case 'spotify':
			icon = 'spotify-client'
			break
	}

	plasmoid.setAction('raise', i18n("Open %1", identity), icon)
	plasmoid.setAction('quit', i18n("Quit"), 'exit')
	plasmoid.setActionSeparator('sep0')
	plasmoid.setAction('nextSource', i18n("Next source"), 'go-next')
	plasmoid.setActionSeparator('sep1')

}

function removeActions(){
	plasmoid.removeAction('raise')
	plasmoid.removeAction('quit')
	plasmoid.removeAction('sep0')
	plasmoid.removeAction('nextSource')
	plasmoid.removeAction('sep1')
}

function autoSelectOpaqueIcons(themeName){
	print("themeName: " + themeName)
	switch(themeName){
		case "default":
		case "Dynamo Plasma":
		case "Tibanna":
		case "Midna":
		case "midna":
		case "org.tilain.plasma":
			plasmoid.writeConfig("opaqueIcons", "true")
	}
}

// callbacks
function controlBarWheelEvent(wheel){}

function sourceNotify(){}

function controlBarWheelNotify(){}


