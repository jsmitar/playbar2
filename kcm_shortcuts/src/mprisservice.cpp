/*
 * <one line to give the program's name and a brief idea of what it does.>
 * Copyright (C) 2014  smith AR <audoban@openmailbox.org>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 */

#include "mprisservice.h"

#include "iostream"

//KDE
#include <Plasma/DataEngineManager>

MprisService::MprisService(QObject* parent)
    : QObject(parent)
{
    DataEngineManager* engine = DataEngineManager::self();
    mpris2 = engine->loadEngine("mpris2");
    serviceName = "@multiplex";
    serv = mpris2->serviceForSource(serviceName);

}

MprisService::~MprisService()
{
    delete serv;
}

/* Public media slots
 *
 */
void MprisService::play_pause()
{

}
void MprisService::play()
{

}
void MprisService::pause()
{

}
void MprisService::stop()
{

}
void MprisService::next()
{

}
void MprisService::previous()
{

}
void MprisService::downVolume()
{

}
void MprisService::upVolume()
{

}
void MprisService::startOperation(const QString& name)
{
    op = serv->operationDescription(name);
    job = serv->startOperationCall(op);
    connect(job, SIGNAL(finished(KJob*)), this, SLOT(jobCompleted(KJob*)));
}

void MprisService::jobCompleted(KJob* job)
{

}

// kate: indent-mode cstyle; indent-width 4; replace-tabs on;
