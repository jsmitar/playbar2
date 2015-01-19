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
import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.plasma.components 0.1 as PlasmaComponents
import org.kde.plasma.graphicswidgets 0.1 as PlasmaWidgets
import org.kde.qtextracomponents 0.1 as QtExtra
import org.kde.draganddrop 1.0
import "plasmapackage:/code/control.js" as Control

Item {
    id: main

	property int minimumWidth: childrenRect.width

	property int minimumHeight: childrenRect.height

	property int maximumWidth: 256

	property int maximumHeight: 256

	property bool vertical: false

	property bool popupOpen: popup.status == PlasmaComponents.DialogStatus.Open

	property bool showNotifications: plasmoid.readConfig('showNotifications')

	opacity: !mouseArea.enabled ? 1 : 0.6

	Behavior on opacity{
		NumberAnimation{ duration: 250 }
	}

	Mpris2{ id: mpris }

	//###########################
	//Context menu
	function action_raise(){
		Control.startOperation('Raise')
	}

	function action_quit(){
		Control.startOperation('Quit')
		popup.close()
	}

	function action_nextSource(){
		mpris.nextSource()
		if(showNotifications) Control.sourceNotify()
	}

	//TODO: open file
	//###########################

	function setMaximumLoad(){
		mpris.interval = mpris.maximumLoad
	}

	function setMinimumLoad(){
		mpris.interval = mpris.minimumLoad
	}

	states:[
		State{
			name: "maximumLoad"
			when: popupOpen

			StateChangeScript{
				script: setMaximumLoad()
			}
		},
		State{
			name: "minimumLoad"
			when: !popupOpen

			StateChangeScript{
				script: setMinimumLoad()
			}
		}
	]

	Component.onCompleted:{
		plasmoid.aspectRatioMode = IgnoreAspectRatio

		function formFactorChanged()
        {
            switch(plasmoid.formFactor)
            {
				case Planar:
					vertical = false
					plasmoid.backgroundHints = StandardBackground
					plasmoid.resize(minimumWidth, minimumHeight)
					return
                case Horizontal:
					plasmoid.backgroundHints = NoBackground
					vertical = false
					return
                case Vertical:
					plasmoid.backgroundHints = NoBackground
					vertical = true
					return
            }
        }

        plasmoid.formFactorChanged.connect(formFactorChanged)
		plasmoid.resize(controlBar.width, controlBar.height)
        formFactorChanged()

		plasmoid.addEventListener('configChanged', function(){
				showNotifications = plasmoid.readConfig('showNotifications')
				sep.visible = plasmoid.readConfig('separatorVisible')
				playbackBar.buttonSize = plasmoid.readConfig('buttonSize')
				shortcuts.connectSource("Shortcuts")
			}
		)

    }

	//ATTENTION: This will be removed in QtQuick 2.0 because will be unnecessary
	// Volume Area
	QtExtra.MouseEventListener{
		id: volumeWheelArea
		anchors.fill: controlBar

		onWheelMoved: {
			if(!mpris.sourceActive) return
			if(mpris.source != 'spotify'){
				Control.controlBarWheelEvent(wheel)
				Control.controlBarWheelNotify()
			}
		}
	}

	//Enabled when no source active
	MouseArea{
		id: mouseArea
		acceptedButtons: Qt.LeftButton
		anchors.fill: controlBar
		z: 99
		enabled: !mpris.sourceActive
	}

	Flow{
		id: controlBar

		spacing: 4

		flow: vertical ? Flow.TopToBottom : Flow.LeftToRight

		anchors{
			centerIn: parent
		}

		Item{
			children: [iconPopup, sep]
			width: vertical ? playbackBar.width : height
			height: vertical ? width : playbackBar.height
		}

		PopupButton{
			id: iconPopup

			elementId: main.popupOpen ? opened : closed
			onClicked: { main.popupOpen ? popup.close(): popup.open(); }

			anchors.centerIn: parent

			size: playbackBar.flatButtons ? playbackBar.buttonSize - 6 : playbackBar.buttonSize - 10
		}

		PlasmaWidgets.Separator{
			id: sep

			orientation: vertical ? Qt.Horizontal : Qt.Vertical

			anchors{
				top: vertical ? undefined : iconPopup.top
				bottom: vertical ? parent.bottom : iconPopup.bottom
				left: vertical ? iconPopup.left : undefined
				right: vertical ? iconPopup.right : parent.right
				leftMargin: vertical ? 0 : controlBar.spacing/2
				topMargin: vertical ? controlBar.spacing/2 : 0
			}
		}

		PlaybackBar{
			id: playbackBar

			buttonSize: plasmoid.readConfig('buttonSize')
		}

		Dialog{
			id: popup

			content: [ contentItem ]
			title:   [ titleItem ]
			visualParent: iconPopup

			Component.onCompleted: contentItem.layoutChanged.connect(updateSize)

			TitlePopup{
				id: titleItem
				width: contentItem.width
			}

			Layout{
				id: contentItem
			}
		}
	}

	Component{
		id: notification

		Notification{
			parent: main
			maximumWidth: (vertical ? controlBar.height : controlBar.width)
			minimumWidth: (vertical ? playbackBar.height : playbackBar.width)

			verticalOffset: (iconPopup.height)/2 + controlBar.spacing + (playbackBar.flatButtons ? 2 : 4)
			horizontalOffset: (iconPopup.width)/2 + controlBar.spacing + (playbackBar.flatButtons ? 2 : 4)

			anchors{
				centerIn: parent
			}

			Component.onCompleted: mpris.sourceChanged.connect(sourceNotify)
		}
	}

	//Load the notifications
	Loader{
		id: loader
		sourceComponent:
			if(showNotifications) notification
			else undefined
	}

	PlasmaCore.DataSource{
		id: shortcuts

		engine: 'playbarengine'

		connectedSources: ['Provider']

		onNewData: if(data['SourceMpris2'] != undefined) print(data['SourceMpris2'])

		function sourceChanged(source){
			var serv = serviceForSource('Provider');
			var op = serv.operationDescription('SetSource');
			op['name'] = source;
			serv.startOperationCall(op);
		}
		Component.onCompleted: mpris.sourceChanged.connect(sourceChanged)
	}

}






