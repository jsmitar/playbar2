#include "playbarengine.h"
#include "playbarservice.h"
#include "playbarsettings.h"

#include <Plasma/Service>

PlayBarEngine::PlayBarEngine( QObject * parent, const QVariantList &args )
	: DataEngine( parent, args )
{
	KSharedConfigPtr config = PlayBarSettings::self()->sharedConfig();
	m_playbar = new PlayBar( config, this );
	setMinimumPollingInterval( 500 );

	connect( PlayBarSettings::self(), SIGNAL( configChanged() ), this, SLOT( updateData() ) );
}

PlayBarEngine::~PlayBarEngine()
{
}

Service * PlayBarEngine::serviceForSource( const QString &source )
{
	if(source != PROVIDER) return nullptr;
	sourceRequestEvent(PROVIDER);
	Service * service = new PlayBarService(m_playbar, this);
	return service;
}

void PlayBarEngine::updateData()
{
	updateSourceEvent(PROVIDER);
}

bool PlayBarEngine::sourceRequestEvent(const QString &source)
{
	if(source != PROVIDER) return false;
	updateSourceEvent(PROVIDER);
	return true;
}

bool PlayBarEngine::updateSourceEvent(const QString &source){
	setData(source, m_playbar->data());
	qDebug() << "PlayBarEngine: updateData()";
	return true;
}

K_EXPORT_PLASMA_DATAENGINE_WITH_JSON(playbarengine, PlayBarEngine, "plasma-dataengine-playbar.json" )
#include "playbarengine.moc"
