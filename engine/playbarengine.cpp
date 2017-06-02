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

#include "playbarengine.h"

#include <QDebug>

#include <Plasma/Service>

#include "playbarservice.h"
#include "playbarsettings.h"

PlayBarEngine::PlayBarEngine(QObject *parent, const QVariantList &args)
    : DataEngine(parent, args)
{
    KSharedConfigPtr config = PlayBarSettings::self()->sharedConfig();
    m_playbar = new PlayBar(config, this);

    setMinimumPollingInterval(1000);
    setPollingInterval(0);

    connect(PlayBarSettings::self(), SIGNAL(configChanged()), this, SLOT(updateData()));
}

PlayBarEngine::~PlayBarEngine()
{
    delete m_playbar;
}

Service *PlayBarEngine::serviceForSource(const QString &source)
{
    if (source != PROVIDER)
        return nullptr;

    sourceRequestEvent(PROVIDER);
    Service *service = new PlayBarService(m_playbar, this);
    return service;
}

void PlayBarEngine::updateData()
{
    updateSourceEvent(PROVIDER);
}

bool PlayBarEngine::sourceRequestEvent(const QString &source)
{
    if (source != PROVIDER)
        return false;

    updateSourceEvent(PROVIDER);
    return true;
}

bool PlayBarEngine::updateSourceEvent(const QString &source)
{
    setData(source, m_playbar->data());
    return true;
}

K_EXPORT_PLASMA_DATAENGINE_WITH_JSON(playbar, PlayBarEngine, "plasma-dataengine-playbar.json")
#include "playbarengine.moc"
// kate: indent-mode cstyle; indent-width 4; replace-tabs on;
