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

#include "playbar.h"

#include <cmath>

#include <QAction>
#include <QIcon>

#include <KLocalizedString>
#include <KGlobalAccel>
#include <KActionCollection>
#include <Plasma/DataEngine>
#include <Plasma/DataEngineConsumer>
#include <Plasma/Service>
#include <Plasma/ServiceJob>

#include "playbarsettings.h"

using namespace Plasma;

PlayBar::PlayBar(KSharedConfigPtr &config , QObject *parent)
    : QObject(parent),
      m_config(config),
      m_data(new Plasma::DataEngine::Data()),
      m_timerNextSource(new QTimer(this))
{
    m_collection = new KActionCollection(this, QStringLiteral("PlayBar"));
    m_collection->setComponentDisplayName(QStringLiteral("PlayBar"));

    m_playpause = m_collection->addAction(QStringLiteral("play-pause"), this, SLOT(action_playPause()));
    m_playpause->setIcon(QIcon::fromTheme(QStringLiteral("media-playback-start")));
    m_playpause->setText(i18n("Play/Pause"));
    KGlobalAccel::setGlobalShortcut(m_playpause, Qt::Key_MediaPlay);

    m_stop = m_collection->addAction(QStringLiteral("stop"), this, SLOT(action_stop()));
    m_stop->setIcon(QIcon::fromTheme(QStringLiteral("media-playback-stop")));
    m_stop->setText(i18n("Stop"));
    KGlobalAccel::setGlobalShortcut(m_stop, Qt::Key_MediaStop);

    m_next = m_collection->addAction(QStringLiteral("next"), this, SLOT(action_next()));
    m_next->setIcon(QIcon::fromTheme(QStringLiteral("media-skip-forward")));
    m_next->setText(i18n("Next track"));
    KGlobalAccel::setGlobalShortcut(m_next, Qt::Key_MediaNext);

    m_previous = m_collection->addAction(QStringLiteral("previous"), this, SLOT(action_previous()));
    m_previous->setIcon(QIcon::fromTheme(QStringLiteral("media-skip-backward")));
    m_previous->setText(i18n("Previous track"));
    KGlobalAccel::setGlobalShortcut(m_previous, Qt::Key_MediaPrevious);

    m_forward = m_collection->addAction(QStringLiteral("seek-forward"), this, SLOT(action_forward()));
    m_forward->setIcon(QIcon::fromTheme(QStringLiteral("media-seek-forward")));
    m_forward->setText(i18n("Seek forward"));
    KGlobalAccel::setGlobalShortcut(m_forward, QKeySequence{Qt::META + Qt::Key_MediaNext});

    m_backward = m_collection->addAction(QStringLiteral("seek-backward"), this, SLOT(action_backward()));
    m_backward->setIcon(QIcon::fromTheme(QStringLiteral("media-seek-backward")));
    m_backward->setText(i18n("Seek backward"));
    KGlobalAccel::setGlobalShortcut(m_backward, QKeySequence{Qt::META + Qt::Key_MediaPrevious});

    m_raise = m_collection->addAction(QStringLiteral("toggle-mediaplayer"), this, SLOT(action_raise()));
    m_raise->setText(i18n("Toggle window media player"));
    KGlobalAccel::setGlobalShortcut(m_raise, QKeySequence{Qt::META + Qt::Key_MediaPlay});

    m_nextSource = m_collection->addAction(QStringLiteral("next-source"), this, SLOT(action_nextSource()));
    m_nextSource->setIcon(QIcon::fromTheme(QStringLiteral("go-next")));
    m_nextSource->setText(i18n("Next source"));
    KGlobalAccel::setGlobalShortcut(m_nextSource, QKeySequence{});

    m_timerNextSource->setInterval(250);
    m_timerNextSource->setSingleShot(true);
}

PlayBar::~PlayBar()
{
}

QString PlayBar::source() const {
    return mpris2_source;
}

void PlayBar::setSource(const QString &source) {
    if (!m_mpris2Engine)
        m_mpris2Engine = dataEngine(MPRIS2);
    else
        m_mpris2Engine->disconnectSource(mpris2_source, this);

    mpris2_source = source.trimmed();
    if (!mpris2_source.isEmpty()) {
        m_mpris2Engine->connectSource(mpris2_source, this);
    }

    if (m_goNextSource) {
        m_goNextSource = false;
        emit nextSourceTriggered();
    }
}

void PlayBar::action_playPause()
{
    startAction("PlayPause");
}

void PlayBar::action_stop()
{
    startAction("Stop");
}

void PlayBar::action_next()
{
    startAction("Next");
}

void PlayBar::action_previous()
{
    startAction("Previous");
}

void PlayBar::action_forward()
{
    constexpr auto us{static_cast<qlonglong>(10 / std::pow(10, -6))};
    seek(us);
}

void PlayBar::action_backward()
{
    constexpr auto us{static_cast<qlonglong>(-10 / std::pow(10, -6))};
    seek(us);
}

void PlayBar::action_raise()
{
    startAction("Raise");
}

void PlayBar::action_nextSource()
{
    if (!m_timerNextSource->isActive()) {
        qDebug() << Q_FUNC_INFO << m_goNextSource << mpris2_source;
        m_timerNextSource->start();
        m_goNextSource = !m_goNextSource;
        emit nextSourceTriggered();
    }
}

void PlayBar::showSettings()
{
    if (KConfigDialog::showDialog(ConfigDialog::CONFIG_NAME))
        return;

    //Read preferences from config file.
    PlayBarSettings::self()->load();
    Q_ASSERT(m_collection);
    m_configDialog = new ConfigDialog(m_collection);

    connect(this, SIGNAL(destroyed(QObject *)), m_configDialog, SLOT(deleteLater()));
    m_configDialog->show();
}

const DataEngine::Data &PlayBar::data()
{
    auto config = PlayBarSettings::self();
    // Read preferences from the KConfig object.
    config->read();

    m_data->insert(QStringLiteral("CompactStyle"),     config->compactStyle());
    m_data->insert(QStringLiteral("MaxWidth"),         config->maxWidth());
    m_data->insert(QStringLiteral("FixedSize"),        config->fixedSize());
    m_data->insert(QStringLiteral("ShowPlayPause"),    config->showPlayPause());
    m_data->insert(QStringLiteral("TrackInfoFormat"),  config->trackInfoFormat());
    m_data->insert(QStringLiteral("ExpandedStyle"),    config->expandedStyle());
    m_data->insert(QStringLiteral("ShowStop"),         config->showStop());
    m_data->insert(QStringLiteral("ShowVolumeSlider"), config->showVolumeSlider());
    m_data->insert(QStringLiteral("ShowSeekSlider"),   config->showSeekSlider());
    m_data->insert(QStringLiteral("BackgroundHint"),   config->backgroundHint());
    m_data->insert(QStringLiteral("ShadowColor"),      config->shadowColor());
    m_data->insert(QStringLiteral("NextSource"),       m_goNextSource.load());

    return *m_data;
}

inline void PlayBar::startAction(const QString &name) const
{
    if(!m_mpris2Engine || mpris2_source.isEmpty())
        return;

    auto *service = m_mpris2Engine->serviceForSource(mpris2_source);
    auto operation = service->operationDescription(name);
    auto *job = service->startOperationCall(operation);

    connect(job, SIGNAL(finished(KJob *)), service, SLOT(deleteLater()));
}

inline void PlayBar::seek(qlonglong us) const
{
    if(!m_mpris2Engine || mpris2_source.isEmpty())
        return;

    auto *service = m_mpris2Engine->serviceForSource(mpris2_source);
    auto operation = service->operationDescription(QStringLiteral("SetPosition"));
    operation["microseconds"] = std::max(m_currentPosition + us, static_cast<qlonglong>(0));
    auto *job = service->startOperationCall(operation);

    connect(job, SIGNAL(finished(KJob *)), service, SLOT(deleteLater()));
}

void PlayBar::dataUpdated(const QString &sourceName, const DataEngine::Data &data)
{
    if (sourceName == mpris2_source) {
        if (data.contains("Position")) {
            m_currentPosition = data["Position"].toLongLong();
        }
    } else {
        m_mpris2Engine->disconnectSource(sourceName, this);
    }
}

// kate: indent-mode cstyle; indent-width 4; replace-tabs on;
