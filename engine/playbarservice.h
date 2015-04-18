#ifndef PLAYBARSERVICE_H
#define PLAYBARSERVICE_H

#include <Plasma/Service>
#include <Plasma/ServiceJob>

#include "playbar.h"

using namespace Plasma;

class PlayBarService : public Service
{
	Q_OBJECT
public:

	PlayBarService(PlayBar * playbar, QObject * parent = 0);

	virtual ~PlayBarService();

protected:
	virtual ServiceJob * createJob( const QString &operation, QVariantMap &parameters );

private:

	PlayBar * m_playbar;
};

#endif // PLAYBARSERVICE_H
