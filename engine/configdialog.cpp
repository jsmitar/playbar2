#include "configdialog.h"

#include <QPushButton>

#include <klocalizedstring.h>

#include "generalwidget.h"
#include "playbarsettings.h"

ConfigDialog::ConfigDialog(KActionCollection * collection , QWidget * parent )
	: KConfigDialog( parent, QLatin1String("PlayBar Settings"), PlayBarSettings::self() ),
	  m_generalPage( new GeneralWidget( this ) )
{
	setWindowTitle(i18n("Configure PlayBar"));
	m_shortcutsPage = new KShortcutsEditor( collection, this, KShortcutsEditor::GlobalAction );
	setStandardButtons( QDialogButtonBox::Apply | QDialogButtonBox::Ok | QDialogButtonBox::Cancel );

	addPage( m_generalPage, i18nc( "General config", "General" ), "applications-multimedia", i18nc( "General Config", "General" ) );
	addPage( m_shortcutsPage, i18nc( "Shortcuts config", "Shortcuts" ), "configure-shortcuts", i18n( "Shortcuts Configuration" ) );

	connect( this, SIGNAL( accepted() ), this, SLOT( updateSettings() ) );
	QPushButton * apply = this->button(QDialogButtonBox::Apply);
	connect(apply, SIGNAL( clicked() ), this, SLOT( updateSettings() ) );

	connect(this, SIGNAL(finished(int)), this, SLOT( deleteLater() ));
}

ConfigDialog::~ConfigDialog(){
	 qDebug() << this << "deleted";
}

void ConfigDialog::updateSettings(){
	// User clicks Ok or Apply button in configuration dialog

	 m_shortcutsPage->save();
	 PlayBarSettings * config = PlayBarSettings::self();

	 config->setShowStop(m_generalPage->showStop());
	 config->setControlsOnBar(m_generalPage->controlsOnBar());
	 config->setButtonsAppearance(m_generalPage->buttonsAppearance());
	 config->setBackgroundHint(m_generalPage->backgroundHint());
	 config->save();
	 qDebug() << "PlayBarEngine: config saved";
}

const QString ConfigDialog::CONFIG_NAME = "PlayBar Settings";
