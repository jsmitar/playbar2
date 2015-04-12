
#ifndef PLAYBARJOB_H
#define PLAYBARJOB_H

#include "playbar.h"

#include <Plasma/ServiceJob>

using namespace Plasma;

class PlayBarJob : public ServiceJob
{
public:

	PlayBarJob(const QString &destination,
			 const QString &operation,
			 const QVariantMap &parameters,
			 PlayBar * playbar,
			 QObject *parent=nullptr);

	virtual ~PlayBarJob();

	void start() override;


private:

	PlayBar * m_playbar;
};

#endif // PLAYBARJOB_H
