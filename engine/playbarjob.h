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

#ifndef PLAYBARJOB_H
#define PLAYBARJOB_H

#include "playbar.h"

#include <Plasma/ServiceJob>

using namespace Plasma;

class PlayBarJob : public ServiceJob {
public:

    PlayBarJob(const QString &destination,
               const QString &operation,
               const QVariantMap &parameters,
               PlayBar *playbar,
               QObject *parent = nullptr);

    virtual ~PlayBarJob();

    void start() override;

private:

    PlayBar *m_playbar;
};

#endif // PLAYBARJOB_H
// kate: indent-mode cstyle; indent-width 4; replace-tabs on;
