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

#ifndef PLAYBAR_H
#define PLAYBAR_H

#include <QAction>

#include <KActionCollection>
#include <Plasma/DataEngine>
#include <Plasma/DataEngineConsumer>

#include "configdialog.h"

using namespace Plasma;

class PlayBar : public QObject {
    Q_OBJECT
public:

    PlayBar(KSharedConfigPtr &config, QObject *parent = 0);

    virtual ~PlayBar();

    inline const QString &source() const {
        return mpris2_source;
    }

    inline void setSource(const QString &source) {
        mpris2_source = source;
    }

    const DataEngine::Data &data();

    void startOperationOverMpris2(const QString &name) const;

public Q_SLOTS:

    void slotPlayPause();
    void slotStop();
    void slotNext();
    void slotPrevious();
    void slotToggleWinMediaPlayer();
    void showSettings();

private:

    ConfigDialog *m_configDialog = nullptr;
    KActionCollection *m_collection = nullptr;
    KSharedConfigPtr m_config;
    DataEngine::Data *m_data = nullptr;
    DataEngineConsumer *m_dc = nullptr;
    static constexpr const char *MPRIS2 { "mpris2" };

    QAction *m_playpause;
    QAction *m_stop;
    QAction *m_next;
    QAction *m_previous;
    QAction *m_openMediaPlayer;

public:
    QString mpris2_source = "@multiplex";
};

#endif // PLAYBAR_H
// kate: indent-mode cstyle; indent-width 4; replace-tabs on;
