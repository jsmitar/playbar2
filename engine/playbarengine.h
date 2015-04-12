
#ifndef PLAYBARENGINE_H
#define PLAYBARENGINE_H

#include "playbar.h"

#include <Plasma/DataEngine>

using namespace Plasma;

class PlayBarEngine : public DataEngine
{
	Q_OBJECT
public:

	PlayBarEngine( QObject * parent, const QVariantList &args );

	virtual ~PlayBarEngine();

public:
	virtual Service * serviceForSource( const QString &source );


private Q_SLOTS:
	void updateData();

protected:
	bool sourceRequestEvent(const QString &source) override;
	bool updateSourceEvent(const QString &source) override;

private:

	const QString PROVIDER = "Provider";
	PlayBar * m_playbar;
};

#endif // PLAYBARENGINE_H
