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

class GeneralWidget : public QWidget {
	Q_OBJECT
  public:
  
	GeneralWidget( QWidget *parent );
	virtual ~GeneralWidget();
	
  public:
	bool showStop() const {
		return m_ui.kcfg_ShowStop->isChecked();
	}
	
	bool controlsOnBar() const {
		return m_ui.kcfg_ControlsOnBar->isChecked();
	}
	
	int buttonsAppearance() const {
		return m_buttonsAppearance;
	}
	
	int backgroundHint() const {
		return m_backgroundHint;
	}
	
	bool noBackground() const {
		return m_ui.kcfg_NoBackground->isChecked();
	}
	
	bool normal() const {
		return m_ui.kcfg_Normal->isChecked();
	}
	
	bool translucent() const {
		return m_ui.kcfg_Translucent->isChecked();
	}
	
	QColor frontColor() const {
		return m_ui.kcfg_FrontColor->color();
	}
	
	QColor backgroundColor() const {
		return m_ui.kcfg_BackgroundColor->color();
	}
	
  Q_SIGNALS:
	void frontColorChanged( const QColor &color );
	void backgroundColorChanged( const QColor &color );
	
  private Q_SLOTS:
	void setButtonsAppearance( bool checked );
	void setBackgroundHint();
	
  private:
	mutable Ui::GeneralWidget m_ui;
	int m_buttonsAppearance = 0;
	int m_backgroundHint = 1;
};

#endif // GENERALWIDGET_H
