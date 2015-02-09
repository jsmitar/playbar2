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
import QtQuick.Layouts 1.1
import org.kde.plasma.extras 2.0 as PlasmaExtras

PlasmaExtras.Paragraph{
	id: label

	property real value: 0

	wrapMode: Text.NoWrap
	elide: Text.ElideNone
	maximumLineCount: 1

	function setLabel(value){
		text = parseInt(value * 100)+'%'
	}

	text: parseInt(value * 100) + '%'
}
