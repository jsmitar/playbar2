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
import "plasmapackage:/code/utils.js" as Utils

PlasmaCore.DataSource{
	id: mpris2

	engine: 'mpris2'

	interval: maximumLoad

	property int maximumLoad: 500

	property int minimumLoad: 1500

	property bool isMaximumLoad: interval == maximumLoad


	property string previousSource

	property alias source: mpris2.connectedSources

	property bool sourceActive: source.length > 0

	property var service: null


	property string identity: hasSource('Identity') ? data[source]['Identity'] : i18n("No source")

	property string playbackStatus: hasSource('PlaybackStatus') ? data[source]['PlaybackStatus'] : "unknown"

	property string artUrl: hasMetadataMpris('artUrl') ? data[source]['Metadata']['mpris:artUrl'] : ""

	property string artist: hasMetadata('artist') ? data[source]['Metadata']['xesam:artist'].toString() : ""

	property string album: hasMetadata('album') ? data[source]['Metadata']['xesam:album'] : ""

	property string title: hasMetadata('title') ? data[source]['Metadata']['xesam:title'] : ""

	property int length: hasMetadataMpris('length') ? data[source]['Metadata']['mpris:length'] / 1000: 0

	property int position: 0

	property real userRating: 0

	property real volume: hasSource('Volume') ? data[source]['Volume'] : 0

	signal mediaSourceChanged(string source)

	signal ratingChanged()

	onMediaSourceChanged: Utils.setActions(source, identity)
	//NOTICE: call to nextSource() for the initial connection
	Component.onCompleted: nextSource()

	onNewData: {
		if(isMaximumLoad) {
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
	}

	onSourcesChanged: {
		if(connectedSources.length == 0) nextSource()
	}

	onSourceAdded: {
		debug("Source added: " + source)
		debug("sources: "+ sources)

		if(source != '@multiplex' && connectedSources.length == 0) {
			connectSource(source)
		}
	}

	onSourceRemoved: {
		if(source == previousSource) {
			nextSource()
		}
	}

	onSourceConnected: {
		mediaSourceChanged(source)
		setService(source)
		debug("Source connected: "+source)
		debug("valid engine: "+ valid)
	}

	onSourceDisconnected: {
		mediaSourceChanged("no_source")
		setService(null)
		previousSource = source
		debug("disconnected: "+source)
	}

	function hasMetadata(key){
		if (!isMaximumLoad) return false
		return data[source[0]] != undefined
			&& data[source[0]]['Metadata'] != undefined
			&& data[source[0]]['Metadata']['xesam:'+key] != undefined
	}

	function hasMetadataMpris(key){
		if (!isMaximumLoad) return false
		return data[source[0]] != undefined
		&& data[source[0]]['Metadata'] != undefined
		&& data[source[0]]['Metadata']['mpris:'+key] != undefined
	}

	function hasSource(key){
		return data[source[0]] != undefined
			&& data[source[0]][key] != undefined
	}

	function nextSource(){
		debug("nextSource()")
		for(var i = 0; i < sources.length; i++){
			if(connectedSources[0] == sources[i] || connectedSources == "")
			{
				if(++i < sources.length && sources[i] != '@multiplex'){
					connectSource(sources[i])
				}else if(++i < sources.length){
					connectSource(sources[i])
				}else if(sources[0] != '@multiplex') {
					connectSource(sources[0])
				}
				return
			}
		}
	}

	function setService(source){
		if(!source) service = null
		service = mpris2.serviceForSource(source)
		debug("service active" + service != null)
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
