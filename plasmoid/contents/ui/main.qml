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
import QtQuick.Layouts 1.2
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.extras 2.0 as PlasmaExtras
import org.kde.plasma.plasmoid 2.0
import "../code/utils.js" as Utils

Item {
    id: root

    readonly property bool vertical: plasmoid.formFactor === PlasmaCore.Types.Vertical
    readonly property bool leftEdge: plasmoid.location === PlasmaCore.Types.LeftEdge
    readonly property bool systray: plasmoid.pluginName === 'audoban.applet.playbar.systray'

    //! dataengine
    PlasmaCore.DataSource {
        id: playbarEngine
        engine: 'playbar'
        connectedSources: source

        readonly property string source: 'Provider'

        readonly property int compactStyle: hasSource('CompactStyle')
        ? data[source]['CompactStyle'] : playbar.icon

        readonly property int maxWidth: hasSource('MaxWidth')
        ? data[source]['MaxWidth'] : 120

        readonly property int expandedStyle: hasSource('ExpandedStyle')
        ? data[source]['ExpandedStyle'] : playbar.horizontalLayout

        readonly property bool showStop: hasSource('ShowStop')
        ? data[source]['ShowStop'] : false

        readonly property bool showVolumeSlider: hasSource('ShowVolumeSlider')
        ? data[source]['ShowVolumeSlider'] : false

        readonly property bool showSeekSlider: hasSource('ShowSeekSlider')
        ? data[source]['ShowSeekSlider'] : false

        readonly property int backgroundHint:
        hasSource('BackgroundHint') && plasmoid.formFactor === PlasmaCore.Types.Planar
        ? data[source]['BackgroundHint'] : playbar.normal

        readonly property color shadowColor: hasSource('ShadowColor')
        ? data[source]['ShadowColor'] : '#fff'

        readonly property bool nextSource: hasSource('NextSource')
        ? data[source]['NextSource'] : false

        property bool systrayArea: false

        onNextSourceChanged: {
            if (nextSource &&
                    mpris2
                    .sources
                    .filter(function(e){return e !== '@multiplex'}).length > 0)
            {
                mpris2.nextSource()
                toolTip.showToolTipChangingSource()
            } else if (nextSource) {
                action_player0()
            }
        }

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

    readonly property PlasmaCore.Dialog toolTip: PlasmaCore.Dialog {
        id: toolTip
        location: PlasmaCore.Types.Floating
        type: PlasmaCore.Dialog.Tooltip
        flags: Qt.ToolTip | Qt.WindowDoesNotAcceptFocus
        outputOnly: true
        visible: false

        readonly property var showToolTip: _delay.restart
        readonly property var hideToolTip: function() { _delay.stop(); hide() }
        readonly property var showToolTipChangingSource: function () { _timer.restart(); showToolTip() }

        readonly property Timer _delay: Timer {
            repeat: false
            running: false
            interval: units.longDuration
            onTriggered: toolTip.visible = !plasmoid.expanded
        }

        mainItem: GridLayout {
            rows: 2
            columns: 2
            rowSpacing: units.smallSpacing
            columnSpacing: units.largeSpacing
            Layout.preferredWidth: implicitWidth

            states: [
                State {
                    when: mpris2.playbackStatus === 'Stopped' && !_timer.running
                    PropertyChanges { target: icon; Layout.rowSpan: 1; size: 32; forceNoCover: false }
                    PropertyChanges { target: subText; visible: false }
                    PropertyChanges { target: title; Layout.alignment: Qt.AlignVCenter }
                },
                State {
                    when: mpris2.playbackStatus !== 'Stopped' && !_timer.running
                    PropertyChanges { target: icon; Layout.rowSpan: 2; size: 48; forceNoCover: false }
                    PropertyChanges { target: subText; visible: true }
                    PropertyChanges { target: title; Layout.alignment: 0 }
                },
                State {
                    name: 'changing_source'
                    when: _timer.running
                    PropertyChanges { target: icon; Layout.rowSpan: 1; size: 32; forceNoCover: true }
                    PropertyChanges { target: subText; visible: false }
                    PropertyChanges { target: title; Layout.alignment: Qt.AlignVCenter; text: mpris2.identity }
                }
            ]

            Timer {
                id: _timer
                running: false
                repeat: false
                interval: 1250
                onTriggered: toolTip.hideToolTip()
            }

            CoverArt {
                id: icon
                Layout.rowSpan: 2
                Layout.fillWidth: false
                property int size: 48
                Layout.minimumWidth: size
                Layout.minimumHeight: size
                Layout.maximumWidth: size
                Layout.maximumHeight: size
                Layout.topMargin: units.smallSpacing
                Layout.bottomMargin: units.smallSpacing
                smooth: true
                noCoverIcon: internal.icon
            }

            PlasmaExtras.Heading {
                id: title
                Layout.fillWidth: false
                Layout.maximumWidth: 400
                Layout.topMargin: units.smallSpacing
                maximumLineCount: 1
                horizontalAlignment: Text.AlignLeft
                level: 3
                text: internal.title
            }

            PlasmaExtras.Paragraph {
                id: subText
                Layout.fillWidth: false
                Layout.maximumWidth: 400
                Layout.bottomMargin: units.smallSpacing
                color: Utils.adjustAlpha(theme.textColor, 0.7)
                maximumLineCount: 2
                horizontalAlignment: Text.AlignLeft
                text: internal.subText
            }
        }
    }

    Component {
        id: compact
        CompactApplet {
        }
    }

    Component {
        id: compactIconOnly
        PlasmaCore.IconItem {
            id: iconLayout
            source: mpris2.playing ? 'media-playback-start' : 'media-playback-pause'

            MediaPlayerArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.BackButton | Qt.ForwardButton

                onClicked: {
                    if (mouse.button === Qt.LeftButton)
                        plasmoid.expanded = !plasmoid.expanded
                }
            }

            Component.onCompleted: toolTip.visualParent = iconLayout
        }
    }

    Plasmoid.compactRepresentation: systray ? compactIconOnly : compact
    Plasmoid.fullRepresentation: FullApplet { id: full }

    Plasmoid.preferredRepresentation: plasmoid.formFactor === PlasmaCore.Types.Planar
        ? Plasmoid.fullRepresentation : Plasmoid.compactRepresentation

    Plasmoid.icon: internal.cover || internal.icon
    Plasmoid.title: systray ? mpris2.identity : 'PlayBar'
    Plasmoid.toolTipMainText: internal.title
    Plasmoid.toolTipSubText: internal.subText
    Plasmoid.toolTipTextFormat: Text.StyledText
    Plasmoid.backgroundHints: playbarEngine.backgroundHint

    function debug() {
        var args = Array.prototype.slice.call(arguments, debug.length).join(' ')
        console.log('playbar:', args)
    }

    //!BEGIN: Context menu actions
    function action_raise() {
        mpris2.startOperation('Raise')
    }
    function action_playPause() {
        mpris2.playPause()
    }
    function action_previous() {
        mpris2.previous()
    }
    function action_next() {
        mpris2.next()
    }
    function action_stop() {
        mpris2.stop()
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
        if (mpris2.recentSources.length > 0)
            executable.startPlayer(0)
    }
    function action_player1() {
        executable.startPlayer(1)
    }
    function action_player2() {
        executable.startPlayer(2)
    }
    function action_player3() {
        executable.startPlayer(3)
    }
    function action_player4() {
        executable.startPlayer(4)
    }
    //!END: Context menu actions

    Component.onCompleted: {
        plasmoid.formFactorChanged()
        plasmoid.removeAction('configure')
        plasmoid.setAction('configure', i18n('Configure PlayBar'), 'configure', 'alt+d, s')
        debug("plugin name", plasmoid.pluginName)
    }

    QtObject {
        id: internal

        property string icon: mpris2.sourceActive ? mpris2.icon(mpris2.currentSource)
                                                  : mpris2.recentSources.length > 0
                                                    ? mpris2.recentSources[0].icon : 'media-playback-start'

        property string cover: mpris2.artUrl !== '' ? Qt.resolvedUrl(mpris2.artUrl)
                                                    : ''

        property string title: mpris2.title !== '' ? mpris2.title
                                                   : mpris2.recentSources.length > 0
                                                     ? mpris2.recentSources[0].identity  : 'PlayBar'

        property string artist: mpris2.artist !== '' ? i18n('<b>By</b> %1 ', mpris2.artist) : ''

        property string album: mpris2.album !== '' ? i18n('<b>On</b> %1', mpris2.album) : ''

        property string subText: (title === 'PlayBar' && artist === '' && album === '')
                                 ? i18n('Client MPRIS2, allows you to control your favorite media player')
                                 : artist + album
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
        toolTip.hideToolTip()
        plasmoid.clearActions()

        var icon = mpris2.icon(mpris2.currentSource)

        if (mpris2.sourceActive) {
            plasmoid.setAction('raise', i18n('Open %1', mpris2.identity), icon)

            if (playbarEngine.compactStyle !== playbar.playbackButtons) {
                plasmoid.setAction('previous', i18n('Play previous track'), 'media-skip-backward')

                if (mpris2.playing)
                    plasmoid.setAction('playPause', i18n('Pause'), 'media-playback-pause')
                else
                    plasmoid.setAction('playPause', i18n('Play'), 'media-playback-start')

                plasmoid.setAction('next', i18n('Play next track'), 'media-skip-forward')

                // enable/disable actions
                plasmoid.action('previous').enabled = mpris2.canGoPrevious
                plasmoid.action('playPause').enabled = mpris2.canPlayPause
                plasmoid.action('next').enabled = mpris2.canGoNext
            }

            plasmoid.setAction('stop', i18n('Stop'), 'media-playback-stop')
            plasmoid.setAction('quit', i18n('Quit'), 'application-exit')

            // enable/disable actions
            plasmoid.action('raise').enabled = mpris2.canRaise
            plasmoid.action('stop').enabled = mpris2.canControl
            plasmoid.action('quit').enabled = mpris2.canQuit

            plasmoid.setActionSeparator('sep1')

            // find the next source
            var ns = mpris2.sources.filter(function(e){return e !== '@multiplex'}).sort()

            if (ns.length > 1) {
                var index = ns.indexOf(mpris2.currentSource)
                index = index + 1 < ns.length && index !== -1 ? index + 1 : 0

                if (ns[index] !== mpris2.currentSource) {
                    plasmoid.setAction('nextSource', i18n('Next source (%1)', mpris2.getIdentity(ns[index])), 'go-next')
                }
            }

        } else {
            var sources = mpris2.recentSources

            for (var i = 0; i < Math.min(sources.length, 5); i++)
                plasmoid.setAction('player' + i, sources[i].identity, sources[i].icon)

            if (sources.length > 0)
                plasmoid.setActionSeparator('sep1')
        }

        plasmoid.setAction('configure', i18n('Configure PlayBar'), 'configure', 'alt+d, s')
    }
}
