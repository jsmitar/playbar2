# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
# Maintainer: Till Schäfer <https://github.com/tillschaefer>

EAPI=6
inherit cmake-utils

DESCRIPTION="Client MPRIS2, allows you to control your favorite media player"
HOMEPAGE="https://github.com/audoban/PlayBar2"
SRC_URI="https://github.com/audoban/PlayBar2/archive/v${PV}.tar.gz"

LICENSE="GPLv3"
SLOT="0"

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"

DEPEND="kde-frameworks/kglobalaccel
        kde-plasma/plasma-workspace
        kde-frameworks/kdeclarative
        kde-frameworks/kconfigwidgets
        kde-frameworks/kxmlgui
        kde-frameworks/kwindowsystem
        kde-frameworks/kdoctools"

S="${WORKDIR}/PlayBar2-${PV}"
