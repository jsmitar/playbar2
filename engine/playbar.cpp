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
      m_configDialog(nullptr),
      m_config(config),
      m_data(new Plasma::DataEngine::Data())
{
    m_dc = new DataEngineConsumer();
    m_collection = new KActionCollection(this, QLatin1String("PlayBar"));
    m_collection->setComponentDisplayName(QLatin1String("PlayBar"));

    m_playpause = m_collection->addAction(QLatin1String("play-pause"), this, SLOT(slotPlayPause()));
    m_playpause->setIcon(QIcon::fromTheme(QLatin1String("media-playback-start")));
    m_playpause->setText(i18n("Play/Pause"));
    KGlobalAccel::setGlobalShortcut(m_playpause, Qt::Key_MediaPlay);

    m_stop = m_collection->addAction(QLatin1String("stop"), this, SLOT(slotStop()));
    m_stop->setIcon(QIcon::fromTheme(QLatin1String("media-playback-stop")));
    m_stop->setText(i18n("Stop"));
    KGlobalAccel::setGlobalShortcut(m_stop, Qt::Key_MediaStop);

    m_next = m_collection->addAction(QLatin1String("next"), this, SLOT(slotNext()));
    m_next->setIcon(QIcon::fromTheme(QLatin1String("media-skip-forward")));
    m_next->setText(i18n("Next track"));
    KGlobalAccel::setGlobalShortcut(m_next, Qt::Key_MediaNext);

    m_previous = m_collection->addAction(QLatin1String("previous"), this, SLOT(slotPrevious()));
    m_previous->setIcon(QIcon::fromTheme(QLatin1String("media-skip-backward")));
    m_previous->setText(i18n("Previous track"));
    KGlobalAccel::setGlobalShortcut(m_previous, Qt::Key_MediaPrevious);

    m_openMediaPlayer = m_collection->addAction(QLatin1String("toggle-mediaplayer"), this,
                        SLOT(slotToggleWinMediaPlayer()));
    m_openMediaPlayer->setText(i18n("Toggle window media player"));
    KGlobalAccel::setGlobalShortcut(m_openMediaPlayer, QKeySequence());

    connect(m_configDialog, SIGNAL(settingsChanged(QString)), this, SLOT(loadSettings()));
}

PlayBar::~PlayBar()
{
}

void PlayBar::slotPlayPause()
{
    startOperationOverMpris2("PlayPause");
}

void PlayBar::slotStop()
{
    startOperationOverMpris2("Stop");
}

void PlayBar::slotNext()
{
    startOperationOverMpris2("Next");
}

void PlayBar::slotPrevious()
{
    startOperationOverMpris2("Previous");
}

void PlayBar::slotToggleWinMediaPlayer()
{
    startOperationOverMpris2("Raise");
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

    m_data->insert("CompactStyle",     config->compactStyle());
    m_data->insert("MaxWidth",         config->maxWidth());
    m_data->insert("ExpandedStyle",    config->expandedStyle());
    m_data->insert("ShowStop",         config->showStop());
    m_data->insert("ShowVolumeSlider", config->showVolumeSlider());
    m_data->insert("ShowSeekSlider",   config->showSeekSlider());
    m_data->insert("BackgroundHint",   config->backgroundHint());
    m_data->insert("ShadowColor",      config->shadowColor());

    return *m_data;
}

inline void PlayBar::startOperationOverMpris2(const QString &name) const
{
    DataEngine *mpris2 = m_dc->dataEngine(MPRIS2);
    Service *serv = mpris2->serviceForSource(mpris2_source);
    const QVariantMap &op = serv->operationDescription(name);
    ServiceJob *job = serv->startOperationCall(op);
    connect(job, SIGNAL(finished(KJob *)), serv, SLOT(deleteLater()));
}
// kate: indent-mode cstyle; indent-width 4; replace-tabs on;
