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

#ifndef PLAYBARENGINE_H
#define PLAYBARENGINE_H

#include <Plasma/DataEngine>
#include <Plasma/Service>

#include "playbar.h"

using namespace Plasma;

class PlayBarEngine : public DataEngine {
    Q_OBJECT
public:

    PlayBarEngine(QObject *parent, const QVariantList &args);

    virtual ~PlayBarEngine();

public:
    Service *serviceForSource(const QString &source) override;

private Q_SLOTS:
    void updateData();

protected:
    bool sourceRequestEvent(const QString &source) override;
    bool updateSourceEvent(const QString &source) override;

private:
    static constexpr const char *PROVIDER {
        "Provider"
    };
    PlayBar *m_playbar;
};

#endif // PLAYBARENGINE_H
// kate: indent-mode cstyle; indent-width 4; replace-tabs on;
