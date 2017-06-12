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

#include "generalwidget.h"
#include <QComboBox>

GeneralWidget::GeneralWidget(QWidget *parent)
    : QWidget(parent)
{
    m_ui.setupUi(this);
    connect(m_ui.kcfg_ShadowColor, SIGNAL(changed(const QColor &))
            , this, SIGNAL(shadowColorChanged(const QColor &)));

    connect(m_ui.kcfg_CompactStyle, static_cast<void (QComboBox::*)(int)>(&QComboBox::currentIndexChanged)
    , this, [&](int index) noexcept {
        m_ui.widget_MaxWidth->setVisible(index == 2 || index == 3);
    });
}

GeneralWidget::~GeneralWidget() { }

// kate: indent-mode cstyle; indent-width 4; replace-tabs on;
