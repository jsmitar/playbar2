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

import QtQuick 2.3
import org.kde.plasma.core 2.0 as PlasmaCore
//import "plasmapackage:/code/control.js" as Control

PlasmaCore.DataSource{
	id: mpris2

	engine: 'mpris2'

	interval: minimumLoad

	connectedSources: sources.length > 1 && sources[0] != '@multiplex' ? [sources[0]] : [""]


	property int maximumLoad: 500

	property int minimumLoad: 1500

	property bool isMaximumLoad: interval == maximumLoad

	property bool initialConnection: true


	property string previousSource

	property string source: connectedSources[0] != undefined ? connectedSources[0] : previousSource

	property bool sourceActive: false

	property var service: null


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


	signal mediaSourceChanged(string source)

	signal ratingChanged()

	onNewData: {

		if(!isMaximumLoad) return

		position = data['Position'] / 1000

		if(hasMetadata('userRating') && data['Metadata']['xesam:userRating'] != userRating ){
			userRating = data['Metadata']['xesam:userRating'] != undefined ?
			             data['Metadata']['xesam:userRating'] : 0
			ratingChanged()
		}else if(playbackStatus == 'Stopped' && userRating != 0){
			userRating = 0
			ratingChanged()
		}

	}

	onSourceAdded: {
		debug("Source added: "+source)
		debug("sources: "+ sources)
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
		if(source == previousSource) nextSource()
	}

	onSourceConnected: {
		if(source != previousSource) {
			debug("connected: "+source)
			previousSource = source
			mediaSourceChanged(source)
		}
		if(source != ''){
			sourceActive = true
			initialConnection = false
			debug("initialConnection: "+initialConnection)
		}
		setService(source)
		debug("Source connected: "+source)
		debug("valid engine: "+ valid)
	}

	onSourceDisconnected: {
		debug("disconnected: "+source)
		if(sources.length == 1){
			mediaSourceChanged(source)
			setService("")
		}
	}

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
		setService(source)
	}

	function nextSource(){
		debug("nextSource()")
		for(var i = 0; i < sources.length; i++){
			if(connectedSources[0] == sources[i] || connectedSources == "")
			{
				if(++i < sources.length && sources[i] != '@multiplex'){
					connect(sources[i])
				}else if(++i < sources.length){
					connect(sources[i])
				}else if(sources[0] != '@multiplex') {
					connect(sources[0])
				}
				return
			}
		}
	}

	function setService(source){
		service = mpris2.serviceForSource(source)
	}

	function seek(position, currentPosition){
		if(!service) return
		if(source == 'clementine') {
			job = service.operationDescription('Seek')
			job['microseconds'] = ((-currentPosition + position) * 1000).toFixed(0)
			service.startOperationCall(job)
			return
		}

		var job = service.operationDescription('SetPosition')
		job['microseconds'] = (position * 1000).toFixed(0)
		service.startOperationCall(job)
	}

	function startOperation(name){
		if(service){
			var job = service.operationDescription(name)
			service.startOperationCall(job)
		}
	}

	function setVolume(value){
		if(service){
			var job = service.operationDescription('SetVolume')
			job['level'] = value
			service.startOperationCall(job)
		}
	}

	//onIntervalChanged: debug("interval: "+interval)
}
