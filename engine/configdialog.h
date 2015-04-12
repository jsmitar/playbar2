
#ifndef CONFIGDIALOG_H
#define CONFIGDIALOG_H

#include <QWidget>

#include <KConfigDialog>
#include <KShortcutsEditor>
#include <KActionCollection>
#include <KConfigSkeleton>

#include "generalwidget.h"

class KConfigDialog;
class KShortcutsEditor;
class KConfigSkeleton;
class KActionCollection;

class ConfigDialog : public KConfigDialog
{
	Q_OBJECT
public:
	ConfigDialog(KActionCollection * collection, QWidget *parent = nullptr );

	virtual ~ConfigDialog();

protected Q_SLOTS:
	void updateSettings();

private:
	KSharedConfigPtr config() const;

private:

	GeneralWidget * m_generalPage;
	KShortcutsEditor * m_shortcutsPage;

public:
	static const QString CONFIG_NAME;

};

#endif // CONFIGDIALOG_H
