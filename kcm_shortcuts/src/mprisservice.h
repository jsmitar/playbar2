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

#ifndef MPRISSERVICE_H
#define MPRISSERVICE_H

#include <Plasma/DataEngine>
#include <Plasma/Service>
#include <Plasma/ServiceJob>
#include <KConfigGroup>

using namespace Plasma;

class MprisService : public QObject
{
    Q_OBJECT
public:
    MprisService(QObject* parent);
    ~MprisService();

public slots:
    void startOperation(const QString& name);

    void play_pause();
    void play();
    void pause();
    void stop();
    void previous();
    void next();
    void upVolume();
    void downVolume();

private:
    Plasma::DataEngine* mpris2;
    Plasma::Service* serv;
    Plasma::ServiceJob* job;
    KConfigGroup op;
    QString serviceName;

private slots:
    void jobCompleted(KJob*);
};

#endif // MPRISSERVICE_H
// kate: indent-mode cstyle; indent-width 4; replace-tabs on;
