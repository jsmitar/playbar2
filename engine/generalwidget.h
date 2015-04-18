
#ifndef GENERALWIDGET_H
#define GENERALWIDGET_H

#include <QWidget>

#include "ui_generalconfig.h"

class GeneralWidget : public QWidget
{
	Q_OBJECT
public:

	GeneralWidget( QWidget * parent );
	virtual ~GeneralWidget();

public:
	inline bool showStop(){
		return m_ui.kcfg_ShowStop->isChecked();
	}

	inline bool controlsOnBar(){
		return m_ui.kcfg_ControlsOnBar->isChecked();
	}

	inline int buttonsAppearance(){
		return m_buttonsAppearance;
	}
	inline int backgroundHint(){
		return m_backgroundHint;
	}

private Q_SLOTS:
	 void setButtonsAppearance(bool checked);
	 void setBackgroundHint();

private:
	Ui::GeneralWidget m_ui;
	int m_buttonsAppearance = 0;
	int m_backgroundHint = 1;
};

#endif // GENERALWIDGET_H
