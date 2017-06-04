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
import QtQuick.Layouts 1.2
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.plasmoid 2.0
import "../code/utils.js" as Utils

Item {
    id: root

    //! dataengine
    PlasmaCore.DataSource {
        id: playbarEngine
        engine: 'playbar'
        connectedSources: source

        readonly property string source: 'Provider'

        readonly property int compactStyle: hasSource('CompactStyle')
            ? data[source]['CompactStyle'] : playbar.icon

        readonly property int expandedStyle: hasSource('ExpandedStyle')
            ? data[source]['ExpandedStyle'] : playbar.horizontalLayout

        readonly property bool showStop: hasSource('ShowStop')
            ? data[source]['ShowStop'] : false

        readonly property bool showVolumeSlider: hasSource('ShowVolumeSlider')
            ? data[source]['ShowVolumeSlider'] : false

        readonly property bool showSeekSlider: hasSource('ShowSeekSlider')
            ? data[source]['ShowSeekSlider'] : false

        readonly property int backgroundHint:
            hasSource('BackgroundHint') && plasmoid.formFactor == PlasmaCore.Types.Planar
            ? data[source]['BackgroundHint'] : playbar.normal

        readonly property color shadowColor: hasSource('ShadowColor')
            ? data[source]['ShadowColor'] : "#fff"

        property bool systrayArea: false

        function showSettings() {
            if (!playbarEngine.valid)
                return
            var service = playbarEngine.serviceForSource('Provider')
            var job = service.operationDescription('ShowSettings')
            job['id'] = plasmoid.id
            service.startOperationCall(job)
        }

        function setSource(name) {
            if (!playbarEngine.valid)
                return
            var service = playbarEngine.serviceForSource('Provider')
            var job = service.operationDescription('SetSourceMpris2')
            job['source'] = name
            service.startOperationCall(job)
        }

        function hasSource(key) {
            return data[source]
        }
    }

    PlasmaCore.DataSource {
        id: executable
        engine: 'executable'

        property var _start: undefined

        onSourceRemoved: {
            if (_start) {
                _start()
                _start = undefined
            }
        }

        function startPlayer(index) {
            var source = mpris2.recentSources[index].source

            if (connectedSources.length > 0) {
                _start = function() {
                    connectSource(source)
                }
                connectedSources = []
            } else {
                connectSource(source)
            }
        }
    }
    //! dataengine
    Mpris2 {
        id: mpris2
    }

    property bool vertical: plasmoid.formFactor === PlasmaCore.Types.Vertical
    property bool leftEdge: plasmoid.location === PlasmaCore.Types.LeftEdge

    Plasmoid.compactRepresentation: CompactApplet {
        id: compact
    }
    Plasmoid.fullRepresentation: FullApplet {
        id: full
    }

    // 	NOTE: This is necessary ?
    Plasmoid.preferredRepresentation: plasmoid.formFactor === PlasmaCore.Types.Planar ? Plasmoid.fullRepresentation : Plasmoid.compactRepresentation

    Plasmoid.icon: internal.icon
    Plasmoid.title: mpris2.identity
    Plasmoid.toolTipMainText: internal.title
    Plasmoid.toolTipSubText: internal.subText
    Plasmoid.toolTipTextFormat: Text.StyledText
    Plasmoid.backgroundHints: playbarEngine.backgroundHint

    // 	Connections {
    // 		target: Plasmoid
    // 		onFormFactorChanged:  debug( 'FormFactor', Plasmoid.formFactor )
    // 	}
    function debug(str, msg) {
        if (msg === undefined)
            msg = ''
        console.debug('audoban.applet.playbar: ' + str, msg)
    }

    //! Context menu actions
    function action_raise() {
        mpris2.startOperation('Raise')
    }

    function action_playPause() {
        if (mpris2.source === 'spotify') {
            mpris2.startOperation('PlayPause')
            return
        }
        if (mpris2.playbackStatus !== 'Playing')
            mpris2.startOperation('Play')
        else
            mpris2.startOperation('PlayPause')
    }

    function action_previous() {
        mpris2.startOperation('Previous')
    }

    function action_next() {
        mpris2.startOperation('Next')
    }

    function action_stop() {
        if (mpris2.playbackStatus !== 'Stopped')
            mpris2.startOperation('Stop')
    }

    function action_quit() {
        mpris2.startOperation('Quit')
    }

    function action_nextSource() {
        mpris2.nextSource()
    }

    function action_configure() {
        playbarEngine.showSettings()
    }

    function action_player0() {
        executable.startPlayer(0)
    }
    function action_player1() {
        executable.startPlayer(1)
    }
    function action_player2() {
        executable.startPlayer(2)
    }

    Component.onCompleted: {
        plasmoid.formFactorChanged()
        plasmoid.removeAction('configure')
        plasmoid.setAction('configure', i18n('Configure PlayBar'), 'configure', 'alt+d, s')
    }

    QtObject {
        id: internal

        property string icon: mpris2.artUrl != '' ? Qt.resolvedUrl(mpris2.artUrl)
            : mpris2.recentSources.length > 0 ? mpris2.recentSources[0].icon : 'media-playback-start'

        property string title: mpris2.title != '' ? mpris2.title
            : mpris2.recentSources.length > 0 ? mpris2.recentSources[0].identity : 'PlayBar'

        property string artist: mpris2.artist != '' ? i18n('<b>By</b> %1 ',
                                                           mpris2.artist) : ''
        property string album: mpris2.album != '' ? i18n('<b>On</b> %1',
                                                         mpris2.album) : ''
        property string subText: (title === 'PlayBar' && artist === ''
                                  && album === '') ? i18n('Client MPRIS2, allows you to control your favorite media player') : artist + album
    }

    // ENUMS
    readonly property QtObject playbar: QtObject {
        objectName: "playbar_namespace"
        // ENUM: CompactStyle
        readonly property int icon: 0
        readonly property int playbackButtons: 1
        readonly property int seekbar: 2
        readonly property int trackinfo: 3

        // ENUM: ExpandedStyle
        readonly property int horizontalLayout: 0
        readonly property int verticalLayout: 1

        // ENUM: BackgroundHint
        readonly property int noBackground: PlasmaCore.Types.NoBackground
        readonly property int normal: PlasmaCore.Types.StandardBackground
        readonly property int translucent: PlasmaCore.Types.TranslucentBackground

    }


    Plasmoid.onContextualActionsAboutToShow: {
        plasmoid.clearActions()

        var icon = mpris2.icon(mpris2.currentSource)

        if (mpris2.sourceActive) {
            plasmoid.setAction('raise', i18n('Open %1', mpris2.identity), icon)

            if (playbarEngine.compactStyle !== playbar.playbackButtons) {
                plasmoid.setAction('previous', i18n('Play previous track'), 'media-skip-backward')

                if (mpris2.playbackStatus === 'Playing')
                    plasmoid.setAction('playPause', i18n('Pause'), 'media-playback-pause')
                else
                    plasmoid.setAction('playPause', i18n('Play'), 'media-playback-start')

                plasmoid.setAction('next', i18n('Play next track'), 'media-skip-forward')
            }

            plasmoid.setAction('stop', i18n('Stop'), 'media-playback-stop')
            plasmoid.setAction('nextSource', i18n('Next multimedia source'), 'go-next')
            plasmoid.setActionSeparator('sep1')
            plasmoid.setAction('quit', i18n('Quit'), 'application-exit')
        } else {
            var sources = mpris2.recentSources

            for (var i = 0; i < sources.length; i++) {
                plasmoid.setAction('player' + i, sources[i].identity, sources[i].icon)
            }
            if (sources.length > 0)
                plasmoid.setActionSeparator('sep1')
        }

        plasmoid.setAction('configure', i18n('Configure PlayBar'), 'configure', 'alt+d, s')
    }
}
