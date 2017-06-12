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

#include <KLocalizedString>

#include "generalwidget.h"
#include "playbarsettings.h"

ConfigDialog::ConfigDialog(KActionCollection *collection , QWidget *parent)
    : KConfigDialog(parent, QLatin1String("PlayBar Settings"), PlayBarSettings::self()),
      m_generalPage(new GeneralWidget(this))
{
    setWindowTitle(i18n("Configure PlayBar"));
    m_shortcutsPage = new KShortcutsEditor(collection, this, KShortcutsEditor::GlobalAction);
    setStandardButtons(QDialogButtonBox::Apply | QDialogButtonBox::Ok | QDialogButtonBox::Cancel);

    addPage(m_generalPage
            , i18nc("General config", "General")
            , "applications-multimedia"
            , i18nc("General config", "General"));

    addPage(m_shortcutsPage
            , i18nc("Shortcuts config", "Shortcuts")
            , "configure-shortcuts"
            , i18n("Shortcuts Configuration"));

    connect(this, SIGNAL(accepted()), this, SLOT(updateSettings()));

    QPushButton *apply = this->button(QDialogButtonBox::Apply);
    connect(apply, SIGNAL(clicked()), this, SLOT(updateSettings()));

    connect(m_generalPage, SIGNAL(shadowColorChanged(const QColor &)),
            this, SLOT(updateColorSettings()));

    connect(this, SIGNAL(finished(int)), this, SLOT(deleteLater()));
}

ConfigDialog::~ConfigDialog()
{
    delete m_generalPage;
    delete m_shortcutsPage;
    qDebug() << metaObject()->className() << "deleted";
}

void ConfigDialog::updateColorSettings()
{
    PlayBarSettings *config = PlayBarSettings::self();

    config->setShadowColor(m_generalPage->shadowColor());
    config->save();
}

void ConfigDialog::updateSettings()
{
    // User clicks Ok or Apply button in configuration dialog
    m_shortcutsPage->save();
    auto *config = PlayBarSettings::self();

    config->setCompactStyle(m_generalPage->compactStyle());
    config->setMaxWidth(m_generalPage->maxWidth());
    config->setExpandedStyle(m_generalPage->expandedStyle());
    config->setShowStop(m_generalPage->showStop());
    config->setShowSeekSlider(m_generalPage->showSeekSlider());
    config->setShowVolumeSlider(m_generalPage->showVolumeSlider());
    config->setBackgroundHint(m_generalPage->backgroundHint());
    config->setNoBackground(m_generalPage->noBackground());
    config->setNormal(m_generalPage->normal());
    config->setTranslucent(m_generalPage->translucent());
    config->setShadowColor(m_generalPage->shadowColor());
    config->save();
    qDebug() << metaObject()->className() << "config saved";
}
// kate: indent-mode cstyle; indent-width 4; replace-tabs on;
