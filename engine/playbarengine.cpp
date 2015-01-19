/*
 * Copyright (C) 2014  smith AR <audoban@openmailbox.org>
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
 *
 */

#include "playbarengine.h"
#include "service.h"

#include <Plasma/DataContainer>
#include <Plasma/DataEngineManager>

using Plasma::DataContainer;
using Plasma::DataEngineManager;

PlayBarEngine::PlayBarEngine(QObject* parent, const QVariantList& args)
    : DataEngine(parent, args)
{
    Q_UNUSED(args)
    setMinimumPollingInterval(-1);
}


PlayBarEngine::~PlayBarEngine()
{

}

Service* PlayBarEngine::serviceForSource(const QString& source)
{
    if (source != "Provider")
        return createDefaultService(this);

    updateSourceEvent(source);
    return new PlayBarService(mpris2_data, this);
}

void PlayBarEngine::init()
{
    DataEngineManager* engine = DataEngineManager::self();
    mpris2 = engine->loadEngine("mpris2");
}

bool PlayBarEngine::sourceRequestEvent(const QString& source)
{
    if (source != "Provider") return false;
    mediaActions = new Shortcuts(this);
    return updateSourceEvent(source);
}

bool PlayBarEngine::updateSourceEvent(const QString& source)
{
    const Data* data = &mediaActions->actions();

    setData(source, *data);
    setData(source, "Mpris2Source", p_mpris2Source);
    setData(source, "PlaybackStatus", playbackStat());
    setData(source, "Metadata", mpris2_data.value("Metadata").toMap());

    delete data; data = 0;
    return true;
}

void PlayBarEngine::startOpOverMpris2(const QString& name)
{
    serv = mpris2->serviceForSource(p_mpris2Source);
    op = serv->operationDescription(name);
    job = serv->startOperationCall(op);
    connect(job, SIGNAL(finished(KJob*)), serv, SLOT(deleteLater()));
}

QString PlayBarEngine::p_mpris2Source;

K_EXPORT_PLASMA_DATAENGINE(playbarengine, PlayBarEngine)

#include "playbarengine.moc"
// kate: indent-mode cstyle; indent-width 4; replace-tabs on;
