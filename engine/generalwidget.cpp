#include "generalwidget.h"

GeneralWidget::GeneralWidget( QWidget * parent )
	: QWidget( parent )
{
	m_ui.setupUi( this );

	connect( m_ui.flat, SIGNAL( toggled( bool ) ), this, SLOT( setButtonsAppearance(bool) ) );

	connect( m_ui.normal, SIGNAL( toggled( bool ) ), this, SLOT( setBackground() ) );
	connect( m_ui.translucent, SIGNAL( toggled( bool ) ), this, SLOT( setBackground() ) );
	connect( m_ui.nobackground, SIGNAL( toggled( bool ) ), this, SLOT( setBackground() ) );
}

void GeneralWidget::setButtonsAppearance( bool checked )
{
	if( checked ) m_buttonsAppearance = 0;
	else m_buttonsAppearance = 1;
}

void GeneralWidget::setBackground()
{
	if( m_ui.normal->isChecked() )
		m_background = 0;
	else if( m_ui.translucent->isChecked() )
		m_background = 1;
	else
		m_background = 2; // no background
}

GeneralWidget::~GeneralWidget() { }



