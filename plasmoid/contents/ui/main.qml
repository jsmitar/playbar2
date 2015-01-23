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
import QtQuick.Layouts 1.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
// import "plasmapackage:/code/control.js" as Control


Item {
    id: root

	property int minimumWidth: playbackBar.width

	property int minimumHeight: childrenRect.height

	property int maximumWidth: childrenRect.width

	property int maximumHeight: childrenRect.height

	property alias _w: root.width

	property alias _h: root.height

	property bool vertical: false

	clip: true
// 	property bool popupOpen: popup.status == PlasmaComponents.DialogStatus.Open

// 	property bool showNotifications: plasmoid.readConfig('showNotifications')

	function debug(str){ console.debug(str) }


	Behavior on opacity{
		NumberAnimation{ duration: 250 }
	}

	Mpris2{ id: mpris2 }

	//###########################
	// 	Context menu actions

	function action_raise(){
		mpris2.startOperation('Raise')
	}

	function action_quit(){
		mpris2.startOperation('Quit')
	}

	function action_nextSource(){
		mpris2.nextSource()
// 		if(showNotifications) Control.sourceNotify()
	}

	//TODO: open file
	//###########################

	function setMaximumLoad(){
		mpris2.interval = mpris2.maximumLoad
	}

	function setMinimumLoad(){
		mpris2.interval = mpris2.minimumLoad
	}

// 	states:[
// 		State{
// 			name: "maximumLoad"
// 			when: popupOpen
//
// 			StateChangeScript{
// 				script: setMaximumLoad()
// 			}
// 		},
// 		State{
// 			name: "minimumLoad"
// 			when: !popupOpen
//
// 			StateChangeScript{
// 				script: setMinimumLoad()
// 			}
// 		}
// 	]

	Component.onCompleted:{

		plasmoid.constraint = 0

		function formFactorChanged()
        {
            switch(plasmoid.formFactor)
            {
				case plasmoid.formFactor.Planar:
					vertical = false
					plasmoid.backgroundHints = 1
					//plasmoid.resize(minimumWidth, minimumHeight)
					return
                case plasmoid.formFactor.Horizontal:
					plasmoid.backgroundHints = 0
					vertical = false
					return
                case plasmoid.formFactor.Vertical:
					plasmoid.backgroundHints = 0
					vertical = true
					return
            }
        }

        plasmoid.formFactorChanged.connect(formFactorChanged)
        formFactorChanged()


		//plasmoid.resize(controlBar.width, controlBar.height)

// 		plasmoid.addEventListener('configChanged', function(){
// 				showNotifications = plasmoid.readConfig('showNotifications')
// 				sep.visible = plasmoid.readConfig('separatorVisible')
// 				playbackBar.buttonSize = plasmoid.readConfig('buttonSize')
// 				shortcuts.connectSource("Shortcuts")
// 			}
// 		)

// 		if(plasmoid.readConfig('first-run') == true){
// 			plasmoid.writeConfig('first-run', 'false')
// 			Control.autoSelectOpaqueIcons(theme.themeName)
// 		}
    }

	//ATTENTION: This will be removed in QtQuick 2.0 because will be unnecessary
	// Volume Area
	// DEPRECATED:
	MouseArea{
		id: volumeWheelArea

		acceptedButtons: Qt.XButton1 | Qt.XButton2
		enabled: mpris2.sourceActive

		anchors.fill: controlBar

		onWheel: {
			if(!mpris2.sourceActive) return
			if(mpris2.source != 'spotify'){
				Control.controlBarWheelEvent(wheel)
				Control.controlBarWheelNotify()
			}
		}
	}
	//----

	//Enabled when no source active
// 	MouseArea{
// 		id: mouseArea
// 		acceptedButtons: Qt.LeftButton
// 		anchors.fill: controlBar
// 		z: 99
// 		enabled: !mpris2.sourceActive
// 	}

	Flow{
		id: controlBar

		spacing: 4
		flow: vertical ? Flow.TopToBottom : Flow.LeftToRight

		anchors.centerIn: parent

		PlaybackBar{
			id: playbackBar
			buttonSize: _w/4
		}

// 		Item{
// 			children: [iconPopup, sep]
// 			width: vertical ? playbackBar.width : height
// 			height: vertical ? width : playbackBar.height
// 		}

// 		PopupButton{
// 			id: iconPopup
//
// 			elementId: main.popupOpen ? opened : closed
// 			onClicked: { main.popupOpen ? popup.close(): popup.open(); }
//
// 			anchors.centerIn: parent
//
// 			size: playbackBar.flatButtons ? playbackBar.buttonSize - 6 : playbackBar.buttonSize - 10
// 		}

// 		PlasmaWidgets.Separator{
// 			id: sep
//
// 			orientation: vertical ? Qt.Horizontal : Qt.Vertical
//
// 			anchors{
// 				top: vertical ? undefined : iconPopup.top
// 				bottom: vertical ? parent.bottom : iconPopup.bottom
// 				left: vertical ? iconPopup.left : undefined
// 				right: vertical ? iconPopup.right : parent.right
// 				leftMargin: vertical ? 0 : controlBar.spacing/2
// 				topMargin: vertical ? controlBar.spacing/2 : 0
// 			}
// 		}


// 		Dialog{
// 			id: popup
//
// 			content: [ contentItem ]
// 			title:   [ titleItem ]
// 			visualParent: iconPopup
//
// 			Component.onCompleted: contentItem.layoutChanged.connect(updateSize)
//
// 			TitlePopup{
// 				id: titleItem
// 				width: contentItem.width
// 			}
//
// 			Layout{
// 				id: contentItem
// 			}
// 		}
	}

// 	Component{
// 		id: notification
//
// 		Notification{
// 			parent: main
// 			maximumWidth: (vertical ? controlBar.height : controlBar.width)
// 			minimumWidth: (vertical ? playbackBar.height : playbackBar.width)
//
// 			verticalOffset: (iconPopup.height)/2 + controlBar.spacing + (playbackBar.flatButtons ? 2 : 4)
// 			horizontalOffset: (iconPopup.width)/2 + controlBar.spacing + (playbackBar.flatButtons ? 2 : 4)
//
// 			anchors{
// 				centerIn: parent
// 			}
//
// 			Component.onCompleted: mpris2.sourceChanged.connect(sourceNotify)
// 		}
// 	}

	//Load the notifications
// 	Loader{
// 		id: loader
// 		sourceComponent:
// 			if(showNotifications) notification
// 			else undefined
// 	}

// 	PlasmaCore.DataSource{
// 		id: shortcuts
//
// 		engine: 'playbarengine'
//
// 		connectedSources: ['Provider']
//
// 		onNewData: if(data['SourceMpris2'] != undefined) print(data['SourceMpris2'])
//
// 		function sourceChanged(source){
// 			var serv = serviceForSource('Provider');
// 			var op = serv.operationDescription('SetSource');
// 			op['name'] = source;
// 			serv.startOperationCall(op);
// 		}
// 		Component.onCompleted: mpris2.sourceChanged.connect(sourceChanged)
// 	}

}






