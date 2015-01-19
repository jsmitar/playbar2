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
import org.kde.plasma.core 0.1
import "plasmapackage:/code/control.js" as Control

DataSource{
	id: dataSource

	engine: 'mpris2'

	interval: minimumLoad

	connectedSources: sources.length > 1 && sources[0] != '@multiplex' ? [sources[0]] : [""]


	property int maximumLoad: 500

	property int minimumLoad: 1500

	property bool isMaximumLoad: interval == maximumLoad

	property bool initialConnection: true


	property string previousSource

	property string source: connectedSources[0] != undefined ? connectedSources[0] : ''

	property bool sourceActive: false


	property string identity: hasSource('Identity') ? data[source]['Identity'] : i18n("No source")

	property string playbackStatus: hasSource('PlaybackStatus') ? data[source]['PlaybackStatus'] : "unknown"

	property string artUrl: hasMetadata('artUrl') ? data[source]['Metadata']['mpris:artUrl'] : ""

	property string artist: hasMetadata('artist') ? data[source]['Metadata']['xesam:artist'].toString() : ""

	property string album: hasMetadata('album') ? data[source]['Metadata']['xesam:album'] : ""

	property string title: hasMetadata('title') ? data[source]['Metadata']['xesam:title'] : ""

	property int length: hasMetadata('length') ? data[source]['Metadata']['mpris:length'] / 1000: 0

	property int position: 0

	property real userRating: 0

	property real volume: hasSource('Volume') ? data[source]['Volume'] : 0


	signal sourceChanged(string source)

	signal ratingChanged()

	signal volumeChanged(real value)

	onSourceChanged: {
		if(data[source] != undefined ) identity = data[source]['Identity']
		else identity = i18n("No source")
	}

	//Component.onCompleted: initialConnection = true

	function hasMetadata(key){
		if (interval == minimumLoad) return false

		if (key == 'artUrl' || key == 'length') key = 'mpris:'+key
		else key = 'xesam:'+key

		return data[source] != undefined
			&& data[source]['Metadata'] != undefined
			&& data[source]['Metadata'][key] != undefined
	}

	function hasSource(key){
		return data[source] != undefined
			&& data[source][key] != undefined
	}

	function connect(source){
		connectedSources = [source]
		Control.setSource(source)
	}

	function nextSource(){
		for(i = 0; i < sources.length; i++){
			if(connectedSources[0] == sources[i] || connectedSources == "")
			{
				if(++i < sources.length && sources[i] != '@multiplex'){
					connect(sources[i])
				}else if(++i < sources.length){
					connect(sources[i])
				}else if(sources[0] != '@multiplex') connect(sources[0])
				return
			}
		}
	}

	onNewData: {
		if(!isMaximumLoad) return

		position = data['Position'] /1000

		if(hasMetadata('userRating') && data['Metadata']['xesam:userRating'] != userRating ){
			userRating = data['Metadata']['xesam:userRating'] != undefined ?
						 data['Metadata']['xesam:userRating'] : 0
			ratingChanged()
		}else if(playbackStatus == 'Stopped' && userRating != 0){
			userRating = 0
			ratingChanged()
		}

		if(hasSource('Volume')) volumeChanged(data['Volume'])

	}

	onSourceAdded: {
		if(initialConnection && source != '@multiplex') {
			previousSource = connectedSources == "" ? "" : connectedSources[0]
			connectedSources = [source]
			initialConnection = false
		}
	}

	onSourceRemoved: {
		if(sources.length == 1){
			sourceActive = false
			initialConnection = true
		}
		if(source == previousSource)
		nextSource()
	}

	onSourceConnected: {
		if(source != previousSource) {
			print("connected: "+source)
			previousSource = source
			sourceChanged(source)
		}
		if(source != ''){
			sourceActive = true
			initialConnection = false
		}
		idty = data[source] != undefined ? data[source]['Identity'] : i18n("No source")
		Control.setSource(source, idty)
	}

	onSourceDisconnected: {
		print("disconnected: "+source)
		if(sources.length == 1){
			sourceChanged(source)
			Control.setSource("", identity)
		}
	}

	//onIntervalChanged: print("interval: "+interval)
}
