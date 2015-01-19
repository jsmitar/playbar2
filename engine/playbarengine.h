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

#ifndef PLAYBARENGINE_H
#define PLAYBARENGINE_H

#include <Plasma/DataEngine>
#include <Plasma/DataContainer>
#include <Plasma/Service>
#include <Plasma/ServiceJob>

#include "shortcuts.h"

#include <KConfigGroup>

using Plasma::Service;

class Shortcuts;

class PlayBarEngine : public Plasma::DataEngine
{
    Q_OBJECT

public:
    PlayBarEngine(QObject* parent, const QVariantList& args);
    virtual ~PlayBarEngine();

    virtual Service* serviceForSource(const QString& source);

    static QString p_mpris2Source;
    Plasma::DataEngine::Data mpris2_data;

    // Playing status
    QString playbackStat() {
        mpris2_data = mpris2->query(p_mpris2Source);
        return mpris2_data.value("PlaybackStatus", "").toString();
    };

    // Do a operation over plasma mpris2 engine
    void startOpOverMpris2(const QString& name);

protected:
    virtual void init();
    virtual bool sourceRequestEvent(const QString& source);
    virtual bool updateSourceEvent(const QString& source);

private:
    KAction* createAction(const char* name, Qt::Key key);
    KAction* createAction(const char* name);

    Plasma::DataEngine* mpris2;
    Plasma::Service* serv;
    Plasma::ServiceJob* job;

    Shortcuts* mediaActions;
    KConfigGroup op;
};

#endif // PLAYBARENGINE_H
// kate: indent-mode cstyle; indent-width 4; replace-tabs on;
