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

#ifndef SHORTCUTS_H
#define SHORTCUTS_H

#include <KAction>
#include <KActionCollection>

#include <playbarengine.h>

class PlayBarEngine;

class Shortcuts : public QObject
{
    Q_OBJECT

public:
    explicit Shortcuts(PlayBarEngine* engine);

    const Plasma::DataEngine::Data& actions() const;

private slots:
    void playpause();
    void play();
    void pause();
    void stop();
    void next();
    void previous();
    void open();
    void quit();

private:
    KAction* createAction(const char* name, Qt::Key key);
    KAction* createAction(const char* name);

    KActionCollection mediaActions;

    PlayBarEngine* playbarEngine;

};

#endif // SHORTCUTS_H
// kate: indent-mode cstyle; indent-width 4; replace-tabs on;
