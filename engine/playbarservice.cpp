#include "playbarservice.h"

#include "playbarjob.h"

#include <QDebug>

#include "Plasma/Service"
#include "Plasma/ServiceJob"


PlayBarService::PlayBarService( PlayBar * playbar, QObject * parent )
	: Service( parent ),
	  m_playbar( playbar )
{
	setName( QLatin1Literal( "audoban.dataengine.playbar" ) );
}

PlayBarService::~PlayBarService()
{
	qDebug() << this << "deleted";
}

ServiceJob * PlayBarService::createJob( const QString &operation, QVariantMap &parameters )
{
	return new PlayBarJob( destination(), operation, parameters, m_playbar, this );
}
