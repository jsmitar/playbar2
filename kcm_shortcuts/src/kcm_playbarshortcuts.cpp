/***************************************************************************
 *   Copyright (C) %{CURRENT_YEAR} by %{AUTHOR} <%{EMAIL}>                 *
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 *   This program is distributed in the hope that it will be useful,       *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of        *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
 *   GNU General Public License for more details.                          *
 *                                                                         *
 *   You should have received a copy of the GNU General Public License     *
 *   along with this program; if not, write to the                         *
 *   Free Software Foundation, Inc.,                                       *
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA .        *
 ***************************************************************************/

#include "kcm_playbarshortcuts.h"

//KDE
#include <KPluginFactory>
#include <KPluginLoader>
#include <KAboutData>

#include <kicon.h>

#include <KAction>

#include <Plasma/DataEngine>
#include <Plasma/DataEngineManager>

//Qt
#include <QBoxLayout>

using Plasma::DataEngine;
using Plasma::DataEngineManager;

K_PLUGIN_FACTORY(PlayBarShortcutsFactory, registerPlugin<KCM_PlayBarShortcuts>();)

K_EXPORT_PLUGIN(PlayBarShortcutsFactory(
                    "kcm_playbarshortcuts" /* kcm name */,
                    "kcm_playbarshortcuts" /* catalog name */)
               )

KCM_PlayBarShortcuts::KCM_PlayBarShortcuts(QWidget*& parent, const QVariantList& args)
    : KCModule(PlayBarShortcutsFactory::componentData(), parent, args)
{
    // About info
    KAboutData about("simple", 0,
                     ki18n("KCM_PlayBarShortcuts"), "0.6",
                     ki18n("Configure PlayBar global shortcuts"),
                     KAboutData::License_GPL,
                     ki18n("(C) 2014 Smith AR"),
                     KLocalizedString(), 0,
                     "audoban@openmailbox.org");

    about.addAuthor(ki18n("Smith AR"), KLocalizedString(), "mail@example.com");

    // KShortcutsEditor widget
    shortcutsWidget = new KShortcutsEditor(0, KShortcutsEditor::GlobalAction);
    shortcutsWidget->setMinimumSize(200, 200);

    //Layout
    QVBoxLayout* vBox = new QVBoxLayout();
    vBox->addWidget(shortcutsWidget);
    this->setLayoutDirection(Qt::LayoutDirectionAuto);
    this->setSizePolicy(QSizePolicy::Expanding, QSizePolicy::Expanding);
    this->setLayout(vBox);

    //create action collection
    createMediaActions();

}

KCM_PlayBarShortcuts::~KCM_PlayBarShortcuts()
{
    shortcutsWidget->clearCollections();
    actions->clear();

}

void KCM_PlayBarShortcuts::createMediaActions()
{

    compdata = new KComponentData("PlayBar");
    actions = new KActionCollection(shortcutsWidget, *compdata);
    shortcutsWidget->addCollection(actions, "PlayBar");

    DataEngine *engine =
    DataEngineManager::self()->engine("playbarkeys");

    if(engine->isValid()){
        DataEngine::Data source = engine->query("Shortcuts");

        if (source.empty()) return;

        foreach(QString key, source.keys()) {
            KAction act();
            actions->addAction(key);
        }
    }
}

KAction* KCM_PlayBarShortcuts::createAction(const char* icon, const char* name, Qt::Key key, QObject* parent)
{
    KAction* action = new KAction(KIcon(icon), ki18n(name).toString(), parent);
    action->setObjectName(name);
    action->setGlobalShortcut(KShortcut(key));

    return action;
}

// kate: indent-mode cstyle; indent-width 4; replace-tabs on;
