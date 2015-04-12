#include "playbarservice.h"

#include "playbarjob.h"

#include "Plasma/Service"
#include "Plasma/ServiceJob"


PlayBarService::PlayBarService( PlayBar * playbar, QObject * parent )
	: Service( parent ),
	  m_playbar( playbar )
{
	setName( QLatin1Literal( "audoban.dataengine.playbar" ) );
}

PlayBarService::~PlayBarService() {}

ServiceJob * PlayBarService::createJob( const QString &operation, QVariantMap &parameters )
{
	PlayBarJob * job = new PlayBarJob( destination(), operation, parameters, m_playbar, this );
	//Delete this service when job was finished
	connect( job, SIGNAL( finished( KJob * ) ), this, SLOT( deleteLater() ) );
	return job;
}
