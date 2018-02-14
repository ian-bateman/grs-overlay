# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools eutils flag-o-matic pam

DESCRIPTION="A tool to run an X session with a single application"
HOMEPAGE="https://github.com/spanezz/nodm"
SRC_URI="https://github.com/spanezz/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~arm ~arm64 ~amd64 ~x86"
IUSE="debug"

DEPEND="x11-libs/libX11
	sys-auth/pambase"

RDEPEND="${DEPEND}
	virtual/pam"

src_prepare() {
	default

	eautoreconf
}

src_install() {
	default

	newpamd "${FILESDIR}"/${PN}.pam ${PN}
	newinitd "${FILESDIR}"/${PN}.init ${PN}
	newconfd "${FILESDIR}"/${PN}.conf ${PN}
	newenvd "${FILESDIR}"/${PN}.env 70${PN}
}
