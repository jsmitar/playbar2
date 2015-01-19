/****************************************************************************
**
** Copyright (C) 2011 Marco Martin  <mart@kde.org>
**
** Copyright (C) 2011 Nokia Corporation and/or its subsidiary(-ies).
** All rights reserved.
** Contact: Nokia Corporation (qt-info@nokia.com)
**
** This file is part of the Qt Components project.
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of Nokia Corporation and its Subsidiary(-ies) nor
**     the names of its contributors may be used to endorse or promote
**     products derived from this software without specific prior written
**     permission.
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 1.1
import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.plasma.components 0.1
import "plasmapackage:/code/control.js" as Control
import "private/AppManager.js" as Utils
import "private" as Private

/**
 * Top-level window for short-term tasks and brief interaction with the user
 *
 * A dialog floats on the top layer of the application view, usually
 * overlapping the area reserved for the application content. Normally, a
 * dialog provides information and gives warnings to the user, or asks the user
 * to answer a question or select an option.
 */
Item {
    id: root

	visible: false
    /**
     * type:list<Item> A list of items in the dialog's title area. You can use
     * a Text component but also any number of components that are based on
     * Item. For example, you can use Text and Image components.
     */
    property alias title: titleBar.children

    /**
     * type:list<Item> A list of items in the dialog's content area. You can
     * use any component that is based on Item. For example, you can use
     * ListView, so that the user can select from a list of names.
     */
    property alias content: contentItem.children

    /**
     * The item that the dialog refers to. The dialog will usually be
     * positioned relative to VisualParent
     */
    property Item visualParent

    /**
     * Indicates the dialog's phase in its life cycle. The values are as follows:
     *
     * - DialogStatus.Opening - the dialog is opening
     * - DialogStatus.Open - the dialog is open and visible to the user
     * - DialogStatus.Closing - the dialog is closing
     * - DialogStatus.Closed - the dialog is closed and not visible to the user
     *
     * The dialog's initial status is DialogStatus.Closed.
     */
    property int status: DialogStatus.Closed


    property alias privateTitleHeight: titleBar.height

    /**
     * This signal is emitted when the user taps in the area that is inside the
     * dialog's visual parent area but outside the dialog's area. Normally the
     * visual parent is the root object. In that case this signal is emitted if
     * the user taps anywhere outside the dialog's area.
     *
     * @see visualParent
     */
    signal clickedOutside

	onClickedOutside: close()

	signal updateSize
    /**
     * Shows the dialog to the user.
     */
    function open() {
		updateSize()

		var pos = internalLoader.dialog.popupPosition(root.visualParent, Qt.AlignCenter)
        internalLoader.dialog.x = pos.x
        internalLoader.dialog.y = pos.y
        internalLoader.dialog.visible = true
        internalLoader.dialog.activateWindow()

		//HACK: Resize the popup correctly
		if(plasmoid.location == TopEdge || plasmoid.location == RightEdge)
			dialogMainItem.height = dialogLayout.height
        else if(plasmoid.location == LeftEdge)
			dialogMainItem.width = dialogLayout.width

		Control.openedPopup = true
    }


    /**
     * Closes the dialog without any user interaction.
     */
    function close() {
        internalLoader.dialog.visible = false
		Control.openedPopup = false
    }

    Loader {
        id: internalLoader
        //the root item of the scene. Determines if there is enough room for an inline dialog
        property Item rootItem

        //this is when the dialog is a separate window
        property Item dialog: sourceComponent == dialogComponent ? item : null

        Component.onCompleted: {
            rootItem = Utils.rootObject()
        }

        sourceComponent: dialogComponent
    }

    Component {
        id: dialogComponent
        PlasmaCore.Dialog {
            id: dialogItem
            windowFlags: Qt.Popup | Qt.Dialog | Qt.WindowStaysOnTopHint

            //state: "Hidden"
            visible: false


			property bool __hack_initialLayoutPosition: false

			onActiveWindowChanged: {
				if(!activeWindow) root.clickedOutside()
			}

            onVisibleChanged: {
				if(__hack_initialLayoutPosition){ __hack_initialLayoutPosition = false; return }
                if (visible) {
                    root.status = DialogStatus.Open
                } else {
                    root.status = DialogStatus.Closed
                }
            }

			function updateSize(){
                dialogMainItem.width  = dialogLayout.width
                dialogMainItem.height = dialogLayout.height
			}

			function config(){

				if (plasmoid.readConfig('windowFlagDialog') == true)
					windowFlags = Qt.Dialog | Qt.WindowStaysOnTopHint
				else
					windowFlags = Qt.Popup | Qt.WindowStaysOnTopHint

				if(plasmoid.readConfig('popupStyle') == 0){
					setAttribute( Qt.WA_X11NetWmWindowTypeToolTip, false )
				}else{
					setAttribute( Qt.WA_X11NetWmWindowTypeToolTip, true  )
				}

				//HACK: fix initial layout position
				__hack_initialLayoutPosition = true
				if(visible) {
					visible = false
					root.status = DialogStatus.Closed
				} else {
					visible = true
					visible = false
				}
			}

            mainItem: dialogMainItem

            Component.onCompleted: {
				setAttribute(Qt.WA_X11NetWmWindowTypeMenu, true)
				setAttribute(Qt.WA_X11NetWmWindowTypePopupMenu, true)
				root.updateSize.connect(updateSize)
				plasmoid.addEventListener('configChanged', config)
				plasmoid.formFactorChanged.connect(updateSize)
				updateSize()
			}
        }
    }

	Item {
        id: dialogMainItem
		children: dialogLayout
	}

    Column {
        id: dialogLayout
        width: contentItem.width
        height: titleBar.height + contentItem.height + 5

        // Consume all key events that are not processed by children
        Keys.onPressed: event.accepted = true
        Keys.onReleased: event.accepted = true


        Row {
            id: titleBar

            height: children.length > 0 && children[0].visible ? childrenRect.height : 0
        }

        Row {
            id: contentItem
        }
    }
}
