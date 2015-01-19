/*
 * <one line to give the library's name and an idea of what it does.>
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

#ifndef SERVICE_H
#define SERVICE_H

#include <Plasma/Service>
#include <Plasma/ServiceJob>
#include <Plasma/DataEngine>

#include <QDebug>
#include <typeinfo>

using Plasma::Service;
using Plasma::ServiceJob;
using Plasma::DataEngine;


class PlayBarService : public Service
{
    Q_OBJECT

public:
    explicit PlayBarService(const DataEngine::Data& data, QObject* parent);

    const DataEngine::Data &data;

protected:
    virtual ServiceJob* createJob(const QString& operation,
                                  QMap< QString, QVariant >& parameters);
};

class Job : public ServiceJob
{
public:

    Job(const QString& destination,
        const QString& operation,
        const QMap< QString, QVariant >& parameters,
        QObject* parent = 0);

    virtual void start();

private:

    bool setRating(const QString& url, const QString& rating);
};

#endif // SERVICE_H
// kate: indent-mode cstyle; indent-width 4; replace-tabs on;
