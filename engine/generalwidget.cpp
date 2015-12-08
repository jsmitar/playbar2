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

#include "generalwidget.h"

GeneralWidget::GeneralWidget( QWidget *parent )
	: QWidget( parent ) {
	m_ui.setupUi( this );
	
	connect( m_ui.flat, SIGNAL( toggled( bool ) ), this, SLOT( setButtonsAppearance( bool ) ) );
	
	connect( m_ui.kcfg_NoBackground, SIGNAL( toggled( bool ) ), this, SLOT( setBackgroundHint() ) );
	connect( m_ui.kcfg_Normal, SIGNAL( toggled( bool ) ), this, SLOT( setBackgroundHint() ) );
	connect( m_ui.kcfg_Translucent, SIGNAL( toggled( bool ) ), this, SLOT( setBackgroundHint() ) );
	connect( m_ui.kcfg_FrontColor, SIGNAL( changed( const QColor & ) ),
			 this, SIGNAL( frontColorChanged( const QColor & ) ) );
	connect( m_ui.kcfg_BackgroundColor, SIGNAL( changed( const QColor & ) ),
			 this, SIGNAL( backgroundColorChanged( const QColor & ) ) );
}

void GeneralWidget::setButtonsAppearance( bool checked ) {
	if ( checked ) m_buttonsAppearance = 0;
	else m_buttonsAppearance = 1;
}

void GeneralWidget::setBackgroundHint() {
	if ( m_ui.kcfg_Normal->isChecked() )
		m_backgroundHint = 1; // standard
	else if ( m_ui.kcfg_Translucent->isChecked() )
		m_backgroundHint = 2; // translucent
	else
		m_backgroundHint = 0; // no background
}

GeneralWidget::~GeneralWidget() { }



