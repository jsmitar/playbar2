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

#include "service.h"
#include "playbarengine.h"

PlayBarService::PlayBarService(const DataEngine::Data& data, QObject* parent)
    : Service(parent), data(data)
{
    setName("playbarservice");
}

ServiceJob* PlayBarService::createJob(const QString& operation,
                                      QMap< QString, QVariant >& parameters)
{
    setDestination(name() + ": " + operation);
    parameters.insert("Metadata", data.value("Metadata"));

    return new Job(destination(), operation, parameters, this);
}

Job::Job(const QString& destination,
         const QString& operation,
         const QMap< QString, QVariant >& parameters,
         QObject* parent):
    ServiceJob(destination, operation, parameters, parent)
{
}

void Job::start()
{
    const QString operation(operationName());

    bool result = false;

    if (operation == QLatin1String("SetSource")) {
        PlayBarEngine::p_mpris2Source = parameters().value("name").toString();
        result = true;
    }
    // TODO: Implementar el tagger para el rating
    else if (operation == QLatin1String("SetRating")) {
        const QVariantMap metadata(parameters().value("Metadata").toMap());

        if (metadata.isEmpty()) qDebug() << "metadata isEmpty";
       // result = setRating(metadata.value("xesam:url").toString(), parameters().value("rating", "0").toString());
    }

    setResult(result);
}


#include "service.moc"
// kate: indent-mode cstyle; indent-width 4; replace-tabs on;
