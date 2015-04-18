#ifndef PLAYBAR_H
#define PLAYBAR_H

#include <QAction>

#include <KActionCollection>
#include <Plasma/DataEngine>
#include <Plasma/DataEngineConsumer>

#include "configdialog.h"

using namespace Plasma;

class PlayBar : public QObject
{
	Q_OBJECT
public:

	PlayBar( KSharedConfigPtr &config, QObject *parent = 0 );

	virtual ~PlayBar();

	inline const QString & source() const
	{
		return mpris2_source;
	}

	inline void setSource( const QString &source )
	{
		mpris2_source = source;
	}

	const DataEngine::Data & data();

	void startOpOverMpris2( const QString& name ) const;

public Q_SLOTS:

	void slotPlayPause();
	void slotStop();
	void slotNext();
	void slotPrevious();
	void slotVolumeUp();
	void slotVolumeDown();
	void slotToggleWinMediaPlayer();
	void showSettings();

private:

	ConfigDialog * m_configDialog;
	KActionCollection * m_collection;
	KSharedConfigPtr m_config;
	DataEngine::Data *m_data;
	DataEngineConsumer *m_dc;
	const QString MPRIS2 = "mpris2";

	QAction * m_playpause;
	QAction * m_stop;
	QAction * m_next;
	QAction * m_previous;
	QAction * m_volumeUp;
	QAction * m_volumeDown;
	QAction * m_openMediaPlayer;
	QAction * m_settingsAction;
public:
	QString mpris2_source = "@multiplex";
};

#endif // PLAYBAR_H
