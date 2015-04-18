/*
*   Author: audoban <audoban@openmailbox.org>
*
*   This program is free software; you can redistribute it and/or modify
*   it under the terms of the GNU Library General Public License as
*   published by the Free Software Foundation; either version 2 or
*   (at your option) any later version.
*
*   This program is distributed in the hope that it will be useful,
*   but WITHOUT ANY WARRANTY; without even the implied warranty of
*   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*   GNU General Public License for more details
*
*   You should have received a copy of the GNU Library General Public
*   License along with this program; if not, write to the
*   Free Software Foundation, Inc.,
*   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
*/

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
	inline bool showStop()
	{
		return m_ui.kcfg_ShowStop->isChecked();
	}

	inline bool controlsOnBar()
	{
		return m_ui.kcfg_ControlsOnBar->isChecked();
	}

	inline int buttonsAppearance()
	{
		return m_buttonsAppearance;
	}
	inline int backgroundHint()
	{
		return m_backgroundHint;
	}

private Q_SLOTS:
	void setButtonsAppearance( bool checked );
	void setBackgroundHint();

private:
	Ui::GeneralWidget m_ui;
	int m_buttonsAppearance = 0;
	int m_backgroundHint = 1;
};

#endif // GENERALWIDGET_H
