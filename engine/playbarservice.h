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

#ifndef PLAYBARSERVICE_H
#define PLAYBARSERVICE_H

#include <Plasma/Service>
#include <Plasma/ServiceJob>

#include "playbar.h"

using namespace Plasma;

class PlayBarService : public Service {
    Q_OBJECT
public:

    PlayBarService(PlayBar *playbar, QObject *parent = 0);

    virtual ~PlayBarService();

protected:
    ServiceJob *createJob(const QString &operation, QVariantMap &parameters) override;

private:
    PlayBar *m_playbar;
};

#endif // PLAYBARSERVICE_H
// kate: indent-mode cstyle; indent-width 4; replace-tabs on;
