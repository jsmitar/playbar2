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

#ifndef CONFIGDIALOG_H
#define CONFIGDIALOG_H

#include <QWidget>

#include <KConfigDialog>
#include <KShortcutsEditor>
#include <KActionCollection>
#include <KConfigSkeleton>

#include "generalwidget.h"

class ConfigDialog : public KConfigDialog {
    Q_OBJECT
public:
    ConfigDialog(KActionCollection *collection, QWidget *parent = nullptr);

    virtual ~ConfigDialog();

protected Q_SLOTS:
    void updateSettings();
    void updateColorSettings();

private:
    KSharedConfigPtr config() const;

private:
    GeneralWidget *m_generalPage;
    KShortcutsEditor *m_shortcutsPage;

public:
    static constexpr const char *CONFIG_NAME { "PlayBar Settings" };

};

#endif // CONFIGDIALOG_H
// kate: indent-mode cstyle; indent-width 4; replace-tabs on;
