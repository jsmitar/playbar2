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

#include "shortcuts.h"
#include <iostream>

Shortcuts::Shortcuts(PlayBarEngine* engine):
    QObject(), mediaActions(this)
{
    playbarEngine = engine;

    KAction* previous =
        createAction("Previous", Qt::Key_MediaPrevious);
    KAction* pause =
        createAction("Pause", Qt::Key_MediaPause);
    KAction* play =
        createAction("Play", Qt::Key_MediaPlay);
    KAction* stop =
        createAction("Stop", Qt::Key_MediaStop);
    KAction* play_pause =
        createAction("PlayPause", Qt::Key_MediaTogglePlayPause);
    KAction* next =
        createAction("Next", Qt::Key_MediaNext);
    KAction* open =
        createAction("Open");
    KAction* quit =
        createAction("Quit");

    mediaActions.setConfigGlobal(true);
    mediaActions.setConfigGroup("PlayBar");

    connect(play_pause, SIGNAL(triggered(bool)), this, SLOT(playpause()));
    connect(play, SIGNAL(triggered(bool)), this, SLOT(play()));
    connect(pause, SIGNAL(triggered(bool)), this, SLOT(pause()));
    connect(stop, SIGNAL(triggered(bool)), this, SLOT(stop()));
    connect(next, SIGNAL(triggered(bool)), this, SLOT(next()));
    connect(previous, SIGNAL(triggered(bool)), this, SLOT(previous()));
    connect(open, SIGNAL(triggered(bool)), this, SLOT(open()));
    connect(quit, SIGNAL(triggered(bool)), this, SLOT(quit()));
}

KAction* Shortcuts::createAction(const char* name)
{
    QString text;
    if (strcmp(name, "PlayPause") == 0)
        text = ki18n("Play").toString() + '/' + ki18n("Pause").toString();
    else text = ki18n(name).toString();

    KAction* action = new KAction("PlayBar: " + text, 0);
    action->setObjectName(name);
    action->setParent(&mediaActions);
    action->setGlobalShortcut(KShortcut());
    mediaActions.addAction(text, action);

    return action;
}

KAction* Shortcuts::createAction(const char* name, Qt::Key key)
{
    KAction* action = createAction(name);
    action->setGlobalShortcut(KShortcut(key));
    return action;
}

const Plasma::DataEngine::Data& Shortcuts::actions() const
{
    QList<QAction*> actions(mediaActions.actions());
    QList<QAction*>::const_iterator it = actions.constBegin();

    Plasma::DataEngine::Data* data = new Plasma::DataEngine::Data();

    while (it != actions.constEnd()) {
        const QString globalShortcut((static_cast<const KAction*>(*it))->globalShortcut().toString());
        const QString text = (*it)->text();
        data->insert(text , globalShortcut);
        ++it;
    }
    return *data;
}


//SLOTS
void Shortcuts::playpause()
{
    const bool playing = playbarEngine->playbackStat() == QLatin1String("Playing");

    if (PlayBarEngine::p_mpris2Source == "spotify") {
        playbarEngine->startOpOverMpris2("PlayPause");
        return;
    }
    if (playing) playbarEngine->startOpOverMpris2("PlayPause");
    else playbarEngine->startOpOverMpris2("Play");

}

void Shortcuts::play()
{
    const bool playing = playbarEngine->playbackStat() == QLatin1String("Playing");

    if (PlayBarEngine::p_mpris2Source == "spotify" && !playing)
        playbarEngine->startOpOverMpris2("PlayPause");
    else if (!playing) playbarEngine->startOpOverMpris2("Play");
}

void Shortcuts::pause()
{
    const bool playing = playbarEngine->playbackStat() == QLatin1String("Playing");

    if (PlayBarEngine::p_mpris2Source == "spotify" && playing)
        playbarEngine->startOpOverMpris2("Play");
    else if (playing)
        playbarEngine->startOpOverMpris2("Pause");
}

void Shortcuts::stop()
{
    const bool stopped = playbarEngine->playbackStat() == QLatin1String("Stopped");

    if (!stopped)
        playbarEngine->startOpOverMpris2("Stop");
}

void Shortcuts::next()
{
    playbarEngine->startOpOverMpris2("Next");
}

void Shortcuts::previous()
{
    playbarEngine->startOpOverMpris2("Previous");
}

void Shortcuts::open()
{
    playbarEngine->startOpOverMpris2("Raise");
}

void Shortcuts::quit()
{
    playbarEngine->startOpOverMpris2("Quit");
}

#include "shortcuts.moc"
// kate: indent-mode cstyle; indent-width 4; replace-tabs on;
