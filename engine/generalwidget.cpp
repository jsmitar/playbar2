#include "generalwidget.h"

GeneralWidget::GeneralWidget( QWidget * parent )
	: QWidget( parent )
{
	m_ui.setupUi( this );

	connect( m_ui.flat, SIGNAL( toggled( bool ) ), this, SLOT( setButtonsAppearance(bool) ) );

	connect( m_ui.normal, SIGNAL( toggled( bool ) ), this, SLOT( setBackgroundHint() ) );
	connect( m_ui.translucent, SIGNAL( toggled( bool ) ), this, SLOT( setBackgroundHint() ) );
	connect( m_ui.nobackground, SIGNAL( toggled( bool ) ), this, SLOT( setBackgroundHint() ) );
}

void GeneralWidget::setButtonsAppearance( bool checked )
{
	if( checked ) m_buttonsAppearance = 0;
	else m_buttonsAppearance = 1;
}

void GeneralWidget::setBackgroundHint()
{
	if( m_ui.normal->isChecked() )
		m_backgroundHint = 1; // standard
	else if( m_ui.translucent->isChecked() )
		m_backgroundHint = 2; // translucent
	else
		m_backgroundHint = 0; // no background
}

GeneralWidget::~GeneralWidget() { }



