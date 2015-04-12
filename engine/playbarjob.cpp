#include <QDebug>

#include "playbarjob.h"
#include "playbar.h"

PlayBarJob::PlayBarJob( const QString &destination,
					const QString &operation,
					const QVariantMap &parameters,
					PlayBar * playbar,
					QObject * parent ):
	ServiceJob( destination, operation, parameters, parent ),
	m_playbar( playbar )
{

}

PlayBarJob::~PlayBarJob() {
	 qDebug() << this << "deleted";
}

void PlayBarJob::start()
{
	if( operationName() == QLatin1String( "ShowSettings" ) )
		m_playbar->showSettings();
	if( operationName() == QLatin1String( "SetSourceMpris2" ))
		m_playbar->mpris2_source = parameters()["source"].toString();
}
