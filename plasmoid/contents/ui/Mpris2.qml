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
import "../code/utils.js" as Utils

PlasmaCore.DataSource {
    id: mpris2

    engine: 'mpris2'

    interval: 0 // ondemand

    readonly property bool sourceActive: connectedSources.length >= 1

    property alias source: mpris2.connectedSources

    property var service: null

    property string currentSource: ''

    property var recentSources: JSON.parse(plasmoid.configuration.RecentSources)

    readonly property var metadata: currentSource ? data[currentSource].Metadata : undefined

    readonly property string identity: currentSource ? capitalize(currentSource) : ''

    readonly property string playbackStatus: currentSource
                                             && sourceActive ? data[currentSource].PlaybackStatus : 'Stopped'

    readonly property string artUrl: metadata
                                     && sourceActive ? metadata['mpris:artUrl']
                                                       || '' : ''

    readonly property string artist: metadata
                                     && sourceActive ? metadata['xesam:artist']
                                                       || '' : ''

    readonly property string album: metadata
                                    && sourceActive ? metadata['xesam:album']
                                                      || '' : ''

    readonly property string title: metadata
                                    && sourceActive ? metadata['xesam:title']
                                                      || '' : ''

    property date positionLastUpdated: new Date(Date.UTC(0, 0, 0, 0, 0, 0))

    readonly property bool canControl: currentSource ? data[currentSource].CanControl : false

    readonly property bool canGoNext: currentSource ? data[currentSource].CanGoNext : false

    readonly property bool canGoPrevious: currentSource ? data[currentSource].CanGoPrevious : false

    readonly property bool canSeek: currentSource ? data[currentSource].CanSeek : false

    readonly property bool canRaise: currentSource ? data[currentSource].CanRaise : false

    readonly property real volume: currentSource ? data[currentSource].Volume : 0


    // 	seconds
    property int length: 0
    // 	seconds
    property int position: 0

    property bool disablePositionUpdate: false

    function waitGetPosition() {
        disablePositionUpdate = true
        _WaitGetPositionTimer.restart()
    }

    readonly property Timer _WaitGetPositionTimer: Timer {
        running: false
        repeat: false
        interval: 500
        onTriggered: {
            disablePositionUpdate = false
            startOperation('GetPosition')
        }
    }

    readonly property Timer _GetPositionTimer: Timer {
        running: !disablePositionUpdate && playbackStatus === 'Playing'
                 && length > 0
        repeat: true
        triggeredOnStart: true
        interval: 1000
        onTriggered: {
            if (position + 1 <= length)
                ++position
            else
                startOperation('GetPosition')
        }
    }

    Component.onCompleted: {
        nextSource()

    }

    onSourceActiveChanged: {
        if (sourceActive && identity)
            return;

        length = 0
        position = 0
    }

    onLengthChanged: startOperation('GetPosition')

    onPlaybackStatusChanged: startOperation('GetPosition')

    onNewData: {
        var positionUpdatedUTC = data['Position last updated (UTC)']
        if (!disablePositionUpdate
                && positionLastUpdated < positionUpdatedUTC) {
            positionLastUpdated = positionUpdatedUTC
            //                      to seconds
            var p = Number(((data['Position'] || 0) / 1000000).toFixed(0))
            var l = Number(((data['Metadata']['mpris:length']
                             || 0) / 1000000).toFixed(0))
            //                      debug( "Position, length", "( " + p + ", " + l + " )" )
            if (l !== length)
                length = l
            if (p <= l)
                position = p
            else
                position = l
        }
    }

    onSourcesChanged: {
        if (connectedSources.length === 0)
            nextSource()

        debug('sources availables:', sources)
    }

    onSourceAdded: {
        // debug( 'Source added', source )
        // debug( 'sources', sources )
        if (source !== '@multiplex' && connectedSources.length === 0) {
            connectSource(source)
            playbarEngine.setSource(source)
        }
    }

    onSourceRemoved: {
        if (source === currentSource)
            nextSource()
    }

    onSourceConnected: {
        setService(source)
        currentSource = source
        debug('source connected:', source)
        addRecentSource(source)
    }

    onSourceDisconnected: {
        setService(null)
        // debug( 'Disconnected', source )
    }

    function nextSource() {
        for (var i = 0; i < sources.length; i++) {
            if (connectedSources[0] === sources[i]
                    || connectedSources.length === 0
                    || connectedSources === [''] || connectedSources === '') {
                if (++i < sources.length && sources[i] !== '@multiplex') {
                    disconnectSource(source[0])
                    connectSource(sources[i])
                    playbarEngine.setSource(sources[i])
                } else if (++i < sources.length) {
                    disconnectSource(source[0])
                    connectSource(sources[i])
                    playbarEngine.setSource(sources[i])
                } else if (sources[0] !== '@multiplex') {
                    disconnectSource(source[0])
                    connectSource(sources[0])
                    playbarEngine.setSource(sources[0])
                }
                return
            }
        }
    }

    function setService(source) {
        if (source)
            service = mpris2.serviceForSource(source)
        else
            service = null
        // debug( 'Service active', ( service != null ) )
    }

    function seek(position, currentPosition) {
        if (service) {
            if (canControl || canSeek) {
                if (!canSeek)
                    debug(source, 'ignoring CanSeek:', canSeek)

                waitGetPosition()
                var operation = service.operationDescription('SetPosition')
                operation['microseconds'] = (position * 1000000).toFixed(0)
                service.startOperationCall(operation)
            }
        }
        return position
    }

    function startOperation(name) {
        if (service && canControl) {
            var operation = service.operationDescription(name)
            service.startOperationCall(operation)
        }
    }

    function setVolume(value) {
        if (service && canControl && service.isOperationEnabled('SetVolume')) {
            var operation = service.operationDescription('SetVolume')
            operation['level'] = Number(value.toFixed(2))
            service.startOperationCall(operation)
            value = value < 0 ? 0 : value
            value = value > 1.2 ? 1 : value
        }
        return value
    }

    function capitalize(source) {
        if (source !== '') {
            var i = (data[source] || { Identity: source }).Identity
            return i[0].toUpperCase() + i.substr(1)
        }

        return source
    }

    function icon(source) {
        var iconName = source

        if (iconName.match('vlc'))
            iconName = 'vlc'

            switch (iconName) {
                case 'spotify':
                    iconName = 'spotify-client'
                    break
                case 'clementine':
                    iconName = 'application-x-clementine'
                    break
                case 'yarock':
                    iconName = 'application-x-yarock'
                    break
                case '@multiplex':
                    if (sourceActive && currentSource == '@multiplex')
                        iconName = icon(data[source]['Source Name'])
                    else
                        iconName = 'emblem-music-symbolic'

                    break
            }

        return iconName
    }

    function addRecentSource(source) {
        if (plasmoid.configuration.RecentSources != '[]')
            recentSources = JSON.parse(plasmoid.configuration.RecentSources)

        if (recentSources.length === 0)
            recentSources = []

        var index = function() {
            for (var i = 0; i < recentSources.length; i++) {
                if (recentSources[i].source == source)
                    return i
            }
            return -1
        }()

        var elem
        if (index !== -1)
            elem = recentSources.splice(index, 1)[0]
        else
            elem = {source: source, identity: capitalize(source), icon: icon(source)}

        recentSources.unshift(elem)

        if (recentSources.length > 3)
            recentSources.pop()

        plasmoid.configuration.RecentSources = JSON.stringify(recentSources)
        debug("recentSources:", plasmoid.configuration.RecentSources)

        recentSourcesChanged()
    }
}
