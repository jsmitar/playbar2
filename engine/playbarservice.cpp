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

#include "playbarservice.h"

#include "playbarjob.h"

#include <QDebug>

#include "Plasma/Service"
#include "Plasma/ServiceJob"


PlayBarService::PlayBarService(PlayBar *playbar, QObject *parent)
    : Service(parent),
      m_playbar(playbar)
{
    setName(QLatin1Literal("audoban.engine.playbar"));
}

PlayBarService::~PlayBarService()
{
    // qDebug() << this << "deleted";
}

ServiceJob *PlayBarService::createJob(const QString &operation, QVariantMap &parameters)
{
    return new PlayBarJob(destination(), operation, parameters, m_playbar, this);
}
// kate: indent-mode cstyle; indent-width 4; replace-tabs on;
