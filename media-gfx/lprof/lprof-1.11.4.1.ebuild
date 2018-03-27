# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit qmake-utils

DESCRIPTION=""
HOMEPAGE=""
SRC_URI="mirror://sourceforge/lprof/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="tiff"

RDEPEND="media-libs/lcms
	dev-python/numpy
	media-libs/vigra
	dev-qt/qtgui:4=
	dev-qt/qtscript:4
	dev-qt/qt3support:4=
	dev-qt/assistant:4=
	virtual/jpeg
	media-libs/libpng
	tiff? ( media-libs/tiff )
"

DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-lcms-version.patch
#	epatch "${FILESDIR}"/${P}-fix-SConstruct.patch

#	use tiff && sed -i -e "s/'tiff'/'tiff','png'/" "${S}"/SConstruct

	epatch_user

	# QTDIR only used for qt3 in gentoo, and configure looks for it.
#	unset QTDIR
#	rm -rf "${S}"/scons*
}

src_configure() {
	export PATH="/usr/lib/qt4/bin:$PATH"

	eqmake4 PREFIX="${EPREFIX}"/usr lprof.pro
}

