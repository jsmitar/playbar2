/*
*   Author: audoban <audoban@openmailbox.org>
*
*   This program is free software; you can redistribute it and/or modify
*   it under the terms of the GNU Library General Public License as
*   published by the Free Software Foundation; either version 3 or
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
import QtQuick 2.7
import org.kde.plasma.core 2.0 as PlasmaCore

PlasmaCore.DataSource {
    id: mpris2

    engine: 'mpris2'

    interval: 0 // update ondemand

    readonly property bool sourceActive: connectedSources.length >= 1 && data[currentSource] !== undefined
                                         && data[currentSource].InstancePid > 0

    property var service: null

    property string currentSource: ''

    property var recentSources: []

    readonly property var metadata: sourceActive ? data[currentSource].Metadata : undefined

    readonly property string identity: sourceActive ? getIdentity(currentSource) : ''

    readonly property string playbackStatus: sourceActive ? data[currentSource].PlaybackStatus || 'Stopped' : 'Stopped'

    readonly property bool playing: playbackStatus === 'Playing'

    readonly property string artUrl: metadata ? metadata['mpris:artUrl'] || '' : ''

    readonly property string artist: metadata ? metadata['xesam:artist'] || '' : ''

    readonly property string album: metadata ? metadata['xesam:album'] || '' : ''

    readonly property string title: metadata ? metadata['xesam:title'] || '' : ''

    readonly property real volume: sourceActive ? data[currentSource].Volume || 0 : 0

    readonly property bool canControl: sourceActive ? data[currentSource].CanControl || false : false

    readonly property bool canPlayPause: canPlay || canPause

    readonly property bool canPlay: canControl ? data[currentSource].CanPlay || false : false

    readonly property bool canPause: canControl ? data[currentSource].CanPause || false : false

    readonly property bool canGoNext: canControl ? data[currentSource].CanGoNext || false : false

    readonly property bool canGoPrevious: canControl ? data[currentSource].CanGoPrevious || false : false

    readonly property bool canSeek: canControl ? data[currentSource].CanSeek || false : false

    readonly property bool canRaise: canControl ? data[currentSource].CanRaise || false : false

    readonly property bool canQuit: canControl ? data[currentSource].CanQuit || false : false

    // 	seconds
    property int length: 0
    // 	seconds
    property int position: 0

    property date positionLastUpdated: new Date()

    property bool positionUpdateEnable: true

    function waitGetPosition() {
        positionUpdateEnable = false
        startOperation('GetPosition')
        _WaitGetPositionTimer.restart()
    }

    readonly property Timer _WaitGetPositionTimer: Timer {
        running: false
        repeat: false
        interval: 500

        onTriggered: {
            positionUpdateEnable = true
            startOperation('GetPosition')
        }
    }

    readonly property Timer _GetPositionTimer: Timer {
        running: positionUpdateEnable && playbackStatus !== 'Stopped'
        repeat: true
        triggeredOnStart: true
        interval: 1000
        onTriggered: startOperation('GetPosition')
    }

    Component.onCompleted: {
        var str = JSON.parse(plasmoid.configuration.RecentSources1)
        recentSources = typeof str == 'string' ? JSON.parse(str) : str
        console.log('typeof recentSources:', recentSources.constructor.name, recentSources)
        nextSource()
    }

    onSourceActiveChanged: {
        if (sourceActive)
            addRecentSource(currentSource)
    }

    onLengthChanged: startOperation('GetPosition')

    onPlaybackStatusChanged: startOperation('GetPosition')

    onNewData: {
        var positionUpdatedUTC = data['Position last updated (UTC)']
        if (positionLastUpdated < positionUpdatedUTC) {
            positionLastUpdated = positionUpdatedUTC

            if (positionUpdateEnable) {
                // to seconds
                var p = Number(((data['Position'] || 0) / 1000000).toFixed(0))
                var l = Number(((data['Metadata']['mpris:length'] || 0) / 1000000).toFixed(0))
//                debug( "(length:" + l + ", position:" + p + ")" )

                if (l !== length)
                    length = l > 0 ? l : 0

                position = p > 0 ? p : 0
            }
        }
    }

    onSourcesChanged: {
        if (connectedSources.length === 0)
            nextSource()

        debug('sources:', sources)
    }

    onSourceAdded: {
        if (connectedSources.length === 0)
            nextSource()

        debug('source added:', source)
    }

    onSourceRemoved: {
        if (source === currentSource)
            nextSource()

        debug('source removed:', source)
    }

    onSourceConnected: {
        setService(source)
        currentSource = source
        position = 0
        length = 0
        positionLastUpdated = new Date()
        playbarEngine.setSource(source)

        debug('source connected:', source)
    }

    onSourceDisconnected: {
        setService(null)
        debug('source disconnected:', source)
    }

    function nextSource() {
        var _sources = sources.filter(function(e) {
            return e !== '@multiplex'
        }).sort()

        var _currentSource = currentSource

        debug('connectedSources:', connectedSources.length)
        debug('_sources', _sources.join(','))

        if (_sources.length > 0 && connectedSources.length === 0) {
            connectSource('@multiplex')
            playbarEngine.setSource('@multiplex')
            debug('next source: @multiplex')

        } else if (_sources.length > 0) {
            var i = _sources.indexOf(_currentSource)
            i = i + 1 < _sources.length && i !== -1 ? i + 1 : 0

            if (_sources[i] !== _currentSource) {
                disconnectSource(_currentSource)
                connectSource(_sources[i])
                playbarEngine.setSource(_sources[i])
                debug('next source:', _sources[i])
            } else {
                playbarEngine.setSource(_currentSource)
            }

        } else if (connectedSources.length > 0) {
            disconnectSource('@multiplex')
            playbarEngine.setSource('')
            debug('next source:', 'Nothing')
        }
    }

    function setService(source) {
        if (source)
            service = mpris2.serviceForSource(source)
        else
            service = null
    }

    function seek(secs) {
        if (service && canSeek) {
            var operation = service.operationDescription('SetPosition')
            operation['microseconds'] = (secs * 1000000).toFixed(0)
            waitGetPosition()
            service.startOperationCall(operation)
        }
        return secs
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

    function playPause() {
        if (playing) {
            if (canPause)
                startOperation('Pause')
            else
                startOperation('PlayPause')
        } else {
            if (canPlay)
                startOperation('Play')
            else
                startOperation('PlayPause')
        }
    }

    function stop() {
        startOperation('Stop')
    }

    function next() {
        startOperation('Next')
    }

    function previous() {
        startOperation('Previous')
    }

    function getIdentity(source) {
        if (sourceActive && source === currentSource && data[source]) {
            var i = data[source].Identity

            if (!i) {
                i = source === '@multiplex' ? data[source]['Source Name'] : source
                i = i.replace(/-/g, ' ')
            }
            return i.charAt(0).toUpperCase() + i.substr(1)
        } else {
            var e = recentSources.find(function (e) {
                return source.match(e.source)
            })

            if (e)
                return e.identity
        }

        var identity = source.replace(/\.instance[0-9]+/, '')
        return identity.charAt(0).toUpperCase() + identity.substr(1)
    }

    function icon(source) {
        var iconName = source.replace(/\.instance[0-9]+/i, '')

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
                break
        }

        if (!iconName)
            return 'emblem-music-symbolic'

        return iconName
    }

    function addRecentSource(source) {
        var sourceName = source

        // this condition control the case when the source is @multiplex
        if (source === '@multiplex') {
            if (sourceActive && currentSource === source)
                sourceName = data[currentSource]['Source Name']
            else
                return
        }

        if (recentSources.length === 0)
            recentSources = []

        var index = recentSources.findIndex(function(e) {
            return sourceName.match(e.source)
        })

        if (index !== -1)
            recentSources.splice(index, 1)

        var newSource = {
              source: sourceName.replace(/\.instance[0-9]+/, '')
            , identity: getIdentity(source)
            , icon: icon(sourceName)
        }

        recentSources.unshift(newSource)

        plasmoid.configuration.RecentSources1 = JSON.stringify(recentSources)
        debug('recentSources:', plasmoid.configuration.RecentSources1)

        recentSourcesChanged()
    }
}
