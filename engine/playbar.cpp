#include "playbar.h"

#include <QAction>
#include <QIcon>

#include <KGlobalAccel>
#include <KActionCollection>
#include <Plasma/DataEngine>
#include <Plasma/DataEngineConsumer>
#include <Plasma/Service>
#include <Plasma/ServiceJob>

#include "playbarsettings.h"

using namespace Plasma;

PlayBar::PlayBar( KSharedConfigPtr &config , QObject * parent )
	: QObject( parent ),
	  m_configDialog( nullptr ),
	  m_config( config ),
	  m_data( new Plasma::DataEngine::Data() )
{
	m_dc = new DataEngineConsumer();
	m_collection = new KActionCollection( this, QLatin1String( "PlayBar" ) );
	m_collection->setComponentDisplayName( QLatin1String( "PlayBar" ) );

	m_playpause = m_collection->addAction( QLatin1String( "play-pause" ), this, SLOT( slotPlayPause() ) );
	m_playpause->setIcon( QIcon::fromTheme( QLatin1String( "media-playback-start" ) ) );
	m_playpause->setText( i18n( "Play/Pause" ) );
	KGlobalAccel::setGlobalShortcut( m_playpause, Qt::Key_MediaPlay );

	m_stop = m_collection->addAction( QLatin1String( "stop" ), this, SLOT( slotStop() ) );
	m_stop->setIcon( QIcon::fromTheme( QLatin1String( "media-playback-stop" ) ) );
	m_stop->setText( i18n( "Stop" ) );
	KGlobalAccel::setGlobalShortcut( m_stop, Qt::Key_MediaStop );

	m_next = m_collection->addAction( QLatin1String( "next" ), this, SLOT( slotNext() ) );
	m_next->setIcon( QIcon::fromTheme( QLatin1String( "media-skip-forward" ) ) );
	m_next->setText( i18n( "Next track" ) );
	KGlobalAccel::setGlobalShortcut( m_next, Qt::Key_MediaNext );

	m_previous = m_collection->addAction( QLatin1String( "previous" ), this, SLOT( slotPrevious() ) );
	m_previous->setIcon( QIcon::fromTheme( QLatin1String( "media-skip-backward" ) ) );
	m_previous->setText( i18n( "Previous track" ) );
	KGlobalAccel::setGlobalShortcut( m_previous, Qt::Key_MediaPrevious );

	m_volumeUp = m_collection->addAction( QLatin1String( "volume-up" ), this, SLOT( slotVolumeUp() ) );
	m_volumeUp->setText( i18n( "Volume up" ) );
	KGlobalAccel::setGlobalShortcut( m_volumeUp, QKeySequence() );

	m_volumeDown = m_collection->addAction( QLatin1String( "volume-down" ), this, SLOT( slotVolumeDown() ) );
	m_volumeDown->setText( i18n( "Volume down" ) );
	KGlobalAccel::setGlobalShortcut( m_volumeDown, QKeySequence() );

	m_openMediaPlayer = m_collection->addAction( QLatin1String( "toggle-mediaplayer" ), this, SLOT( slotToggleWinMediaPlayer() ) );
	m_openMediaPlayer->setText( i18n( "Toggle window media player" ) );
	KGlobalAccel::setGlobalShortcut( m_openMediaPlayer, QKeySequence() );

	//connect( m_configDialog, SIGNAL( settingsChanged( QString ) ), this, SLOT( loadSettings() ) );
}

PlayBar::~PlayBar() {}

void PlayBar::slotPlayPause()
{
	startOpOverMpris2( "PlayPause" );
}

void PlayBar::slotStop()
{
	startOpOverMpris2( "Stop" );
}

void PlayBar::slotNext()
{
	startOpOverMpris2( "Next" );
}

void PlayBar::slotPrevious()
{
	startOpOverMpris2( "Previous" );
}

void PlayBar::slotVolumeUp()
{

}

void PlayBar::slotVolumeDown()
{
}

void PlayBar::slotToggleWinMediaPlayer()
{
	startOpOverMpris2( "Raise" );
}

void PlayBar::showSettings()
{
	if( KConfigDialog::showDialog( ConfigDialog::CONFIG_NAME ) )
		return;
	//Read preferences from config file.
	PlayBarSettings::self()->load();
	m_configDialog = new ConfigDialog( m_collection );
	m_configDialog->show();
}

const DataEngine::Data & PlayBar::data(){
	auto config = PlayBarSettings::self();
	// Read preferences from the KConfig object.
	config->read();
	foreach( auto item , config->items() ) {
		QString name = item->name();
		if (name == QLatin1String("ShowStop"))
			m_data->insert( name, config->showStop() );
		else if(name == QLatin1String("ControlsOnBar"))
			m_data->insert( name, config->controlsOnBar());
		else if(name == QLatin1String("ButtonsAppearance"))
			m_data->insert( name , config->buttonsAppearance());
		else if(name == QLatin1String("Background"))
			m_data->insert( name, config->background());
	}
	return *m_data;
}

void PlayBar::startOpOverMpris2( const QString &name ) const
{
	DataEngine * mpris2 = m_dc->dataEngine( MPRIS2 );
	Service * serv = mpris2->serviceForSource( mpris2_source );
	const QVariantMap &op = serv->operationDescription( name );
	ServiceJob * job = serv->startOperationCall( op );
	connect( job, SIGNAL( finished( KJob * ) ), serv, SLOT( deleteLater() ) );
}
