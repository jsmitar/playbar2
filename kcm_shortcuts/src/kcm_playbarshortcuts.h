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

#ifndef KCM_PLAYBARSHORTCUTS_H
#define KCM_PLAYBARSHORTCUTS_H

#include <KCModule>
#include <KShortcutsEditor>
#include <KActionCollection>




/**
 * This class serves as the main window for KCM_PlayBarShortcuts.  It handles the
 * menus, toolbars and status bars.
 *
 * @short Main window class
 * @author Smith AR <audoban@openmailbox.org>
 * @version 0.6
 */
class KCM_PlayBarShortcuts : public KCModule
{
    Q_OBJECT
public:

    KCM_PlayBarShortcuts(QWidget*& parent, const QVariantList& args);

    /**
     * Default Destructor
     */
    virtual ~KCM_PlayBarShortcuts();

private:

    void createMediaActions();

    KAction* createAction(const char* icon,
                          const char* name,
                          Qt::Key key,
                          QObject* parent);

    //KShortcutsEditor Widget
    KShortcutsEditor* shortcutsWidget;
    KActionCollection* actions;
    KComponentData *compdata;

};

#endif // _KCM_PLAYBARSHORTCUTS_H_
// kate: indent-mode cstyle; indent-width 4; replace-tabs on;

