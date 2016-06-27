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
import org.kde.plasma.core 2.0 as PlasmaCore
import '../code/utils.js' as Utils

PlasmaCore.DataSource {
	id: mpris2

	engine: 'mpris2'

	interval: 0 // ondemand

//!NOTE: I would fix the performance
	readonly property int maximumLoad: 500

	readonly property int minimumLoad: playbackStatus === 'Paused' ? 1000 : 500

	readonly property bool isMaximumLoad: plasmoid.expanded

	readonly property bool sourceActive: source.length > 0


	property string currentSource

	property alias source: mpris2.connectedSources


	property var service: null


	readonly property string identity:
                hasSource( 'Identity' ) ? toCapitalizeIdentity() : i18n( 'No media player' )

	readonly property string playbackStatus:
                hasSource( 'PlaybackStatus' ) ? data[source]['PlaybackStatus'] : ''

	readonly property string artUrl:
                hasMetadataMpris( 'artUrl' ) ? data[source]['Metadata']['mpris:artUrl'] : ''

	readonly property string artist:
                hasMetadata( 'artist' ) ? data[source]['Metadata']['xesam:artist'] : ''

	readonly property string album:
                hasMetadata( 'album' ) ? data[source]['Metadata']['xesam:album'] : ''

	readonly property string title:
                hasMetadata( 'title' ) ? data[source]['Metadata']['xesam:title'] : ''

// 	seconds
	property int length: 0
// 	seconds
	property int position: 0

	property real userRating: 0

	readonly property real volume:
                hasSource( 'Volume' ) ? data[source]['Volume'] : 0

	readonly property bool canControl:
                hasSource( 'CanControl' ) ? data[source]['CanControl'] : true

	readonly property bool canGoNext:
                hasSource( 'CanGoNext' ) ? data[source]['CanGoNext'] : true

	readonly property bool canGoPrevious:
                hasSource( 'CanGoPrevious' ) ? data[source]['CanGoPrevious'] : true

	readonly property bool canSeek:
                hasSource( 'CanSeek' ) ? data[source]['CanSeek'] : true

	readonly property bool canRaise:
                hasSource( 'CanRaise' ) ? data[source]['CanRaise'] : true

	function waitGetPosition() {
                _GetPositionTimer.stop()
                _WaitGetPositionTimer.restart()
	}

	readonly property Timer _WaitGetPositionTimer: Timer {
                running: false
                repeat: false
                interval: 1000
                onTriggered: _GetPositionTimer.start()
	}

        readonly property Timer _GetPositionTimer: Timer {
                running: playbackStatus !== 'Stopped'
                        && ( plasmoid.expanded || ( playbarEngine.compactStyle === playbar.seekBar ) )
                repeat: true
                interval: mpris2.isMaximumLoad ? mpris2.maximumLoad : mpris2.minimumLoad
                onTriggered: startOperation( 'GetPosition' )
        }

	Component.onCompleted: nextSource()

	onIdentityChanged: {
		if ( sourceActive ) Utils.setActions( source[0], identity )
	}

	onSourceActiveChanged: {
		if ( !sourceActive ) Utils.removeActions()
	}

	onNewData: {
//              to seconds
                var p = data['Position'] / 1000000 | 0
                var l = data['Metadata']['mpris:length'] / 1000000 | 0
//                 debug( "Position, length", "( " + p + ", " + l + " )" )

                if ( !l ) l = 0

                if ( l !== length ) length = l

                if ( p < l ) position = p
                else length = position = p
	}

	onSourcesChanged: {
		if ( connectedSources.length === 0 ) nextSource()
	}

	onSourceAdded: {
		// debug( 'Source added', source )
		// debug( 'sources', sources )

		if ( source !== '@multiplex' && connectedSources.length === 0 ) {
			connectSource( source )
			playbarEngine.setSource( source )
		}
	}

	onSourceRemoved: {
                if ( source === currentSource )
                        nextSource()
	}

	onSourceConnected: {
		setService( source )
		currentSource = source
		// debug( 'Source connected', source )
		// debug( 'Valid engine', valid )
	}

	onSourceDisconnected: {
                setService( null )
		// debug( 'Disconnected', source )
	}

	function hasMetadata( key ) {
		return data[source[0]]
			&& data[source[0]]['Metadata']
			&& data[source[0]]['Metadata']['xesam:'+key]
	}

	function hasMetadataMpris( key ) {
		return data[source[0]]
                        && data[source[0]]['Metadata']
                        && data[source[0]]['Metadata']['mpris:'+key]
	}

	function hasSource( key ) {
		return data[source[0]]
                        // && data[source[0]][key]
	}

	function nextSource() {
		for ( var i = 0; i < sources.length; i++ ) {
			if ( connectedSources[0] === sources[i]
                          || connectedSources.length === 0
                          || connectedSources === ['']
                          || connectedSources === '' )
                        {
				if ( ++i < sources.length && sources[i] !== '@multiplex' ) {
					disconnectSource( source[0] )
					connectSource( sources[i] )
					playbarEngine.setSource( sources[i] )
				} else if ( ++i < sources.length ) {
					disconnectSource( source[0] )
					connectSource( sources[i] )
					playbarEngine.setSource( sources[i] )
				} else if ( sources[0] !== '@multiplex' ) {
					disconnectSource( source[0] )
					connectSource( sources[0] )
					playbarEngine.setSource( sources[0] )
				}
				return
			}
		}
	}

	function setService( source ) {
		if ( source )
                        service = mpris2.serviceForSource( source )
                else
                        service = null
		// debug( 'Service active', ( service != null ) )
	}

	function seek( position, currentPosition ) {
		if ( service && ( canControl || canSeek ) ) {
                        if ( !canSeek ) debug( "Trying seek, CanSeek is", canSeek )
                        waitGetPosition()
			var job = service.operationDescription( 'SetPosition' )
			job['microseconds'] = ( position * 1000000 ).toFixed( 0 )
			service.startOperationCall( job )
		}
		return position
// 		if ( source == 'clementine' ) {
// 			job = service.operationDescription( 'Seek' )
// 			job['microseconds'] = ( ( -currentPosition + position ) * 10000 ).toFixed( 0 )
// 			service.startOperationCall( job )
// 			return
// 		}
	}

	function startOperation( name ) {
		if ( service && canControl ) {
			var job = service.operationDescription( name )
			service.startOperationCall( job )
		}
	}

	function setVolume( value ) {
		if ( service && canControl && service.isOperationEnabled( 'SetVolume' ) ) {
			var job = service.operationDescription( 'SetVolume' )
			job['level'] = Number( value.toFixed( 2 ) )
			service.startOperationCall( job )
			value = value < 0 ? 0 : value
			value = value > 1.2 ? 1 : value
		}
		return value
	}

	function toCapitalizeIdentity() {
		var i = data[source]['Identity'];
		return i[0].toUpperCase() + i.substr(1);
	}
}
