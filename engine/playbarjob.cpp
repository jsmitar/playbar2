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

#include "playbarjob.h"

#include <QDebug>

#include "playbar.h"

PlayBarJob::PlayBarJob(const QString &destination,
                       const QString &operation,
                       const QVariantMap &parameters,
                       PlayBar *playbar,
                       QObject *parent) :
    ServiceJob(destination, operation, parameters, parent),
    m_playbar(playbar)
{

}

PlayBarJob::~PlayBarJob()
{
    // qDebug() << this << "deleted";
}

void PlayBarJob::start()
{
    if (operationName() == QLatin1String("ShowSettings"))
        m_playbar->showSettings();

    if (operationName() == QLatin1String("SetSourceMpris2"))
        m_playbar->mpris2_source = parameters()["source"].toString();

    emitResult();
}
// kate: indent-mode cstyle; indent-width 4; replace-tabs on;
