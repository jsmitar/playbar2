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

#include "configdialog.h"

#include <QPushButton>

#include <klocalizedstring.h>

#include "generalwidget.h"
#include "playbarsettings.h"

ConfigDialog::ConfigDialog( KActionCollection * collection , QWidget * parent )
	: KConfigDialog( parent, QLatin1String( "PlayBar Settings" ), PlayBarSettings::self() ),
	  m_generalPage( new GeneralWidget( this ) )
{
	setWindowTitle( i18n( "Configure PlayBar" ) );
	m_shortcutsPage = new KShortcutsEditor( collection, this, KShortcutsEditor::GlobalAction );
	setStandardButtons( QDialogButtonBox::Apply | QDialogButtonBox::Ok | QDialogButtonBox::Cancel );

	addPage( m_generalPage, i18nc( "General config", "General" ), "applications-multimedia", i18nc( "General Config", "General" ) );
	addPage( m_shortcutsPage, i18nc( "Shortcuts config", "Shortcuts" ), "configure-shortcuts", i18n( "Shortcuts Configuration" ) );

	connect( this, SIGNAL( accepted() ), this, SLOT( updateSettings() ) );
	QPushButton * apply = this->button( QDialogButtonBox::Apply );
	connect( apply, SIGNAL( clicked() ), this, SLOT( updateSettings() ) );

	connect( this, SIGNAL( finished( int ) ), this, SLOT( deleteLater() ) );
}

ConfigDialog::~ConfigDialog()
{
	qDebug() << this << "deleted";
}

void ConfigDialog::updateSettings()
{
	// User clicks Ok or Apply button in configuration dialog

	m_shortcutsPage->save();
	PlayBarSettings * config = PlayBarSettings::self();

	config->setShowStop( m_generalPage->showStop() );
	config->setControlsOnBar( m_generalPage->controlsOnBar() );
	config->setButtonsAppearance( m_generalPage->buttonsAppearance() );
	config->setBackgroundHint( m_generalPage->backgroundHint() );
	config->save();
	qDebug() << "PlayBarEngine: config saved";
}

const QString ConfigDialog::CONFIG_NAME = "PlayBar Settings";
