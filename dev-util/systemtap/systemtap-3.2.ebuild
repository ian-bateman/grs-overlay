# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit flag-o-matic linux-info autotools eutils python-single-r1 user

DESCRIPTION="A linux trace/probe tool"
HOMEPAGE="https://www.sourceware.org/systemtap/"
SRC_URI="https://www.sourceware.org/${PN}/ftp/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="libvirt sqlite"

RDEPEND="${PYTHON_DEPS}
	virtual/libelf:0/1"

DEPEND="sys-libs/libcap
	libvirt? ( >=app-emulation/libvirt-1.0.2 )
	sqlite? ( dev-db/sqlite:3 )
	>=sys-devel/gettext-0.18.2"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

CONFIG_CHECK="~KPROBES ~RELAY ~DEBUG_FS"
ERROR_KPROBES="${PN} requires support for KProbes Instrumentation (KPROBES) - this can be enabled in 'Instrumentation Support -> Kprobes'."
ERROR_RELAY="${PN} works with support for user space relay support (RELAY) - this can be enabled in 'General setup -> Kernel->user space relay support (formerly relayfs)'."
ERROR_DEBUG_FS="${PN} works best with support for Debug Filesystem (DEBUG_FS) - this can be enabled in 'Kernel hacking -> Debug Filesystem'."

DOCS="AUTHORS HACKING NEWS README"

PATCHES=(
	"${FILESDIR}"/${PN}-3.1-ia64.patch
	"${FILESDIR}"/${PN}-3.2-timer-compat.patch
	"${FILESDIR}"/${PN}-3.2-libvirt-build-fix.patch
	"${FILESDIR}"/${PN}-3.2-musl-fixes.patch
)

pkg_setup() {
	enewgroup stapusr 156
	enewgroup stapsys 157
	enewgroup stapdev 158

	linux-info_pkg_setup
	python-single-r1_pkg_setup
}

src_prepare() {
	python_fix_shebang .

	sed -i \
		-e 's:-Werror::g' \
		configure.ac \
		Makefile.am \
		staprun/Makefile.am \
		stapdyn/Makefile.am \
		stapbpf/Makefile.am \
		testsuite/systemtap.unprivileged/unprivileged_probes.exp \
		testsuite/systemtap.unprivileged/unprivileged_myproc.exp \
		testsuite/systemtap.base/stmt_rel_user.exp \
		testsuite/systemtap.base/sdt_va_args.exp \
		testsuite/systemtap.base/sdt_misc.exp \
		testsuite/systemtap.base/sdt.exp \
		scripts/kprobes_test/gen_code.py \
		|| die "Failed to clean up sources"

	default

	eautoreconf
}

src_configure() {
	append-cppflags "-U_FORTIFY_SOURCE -D__NEED_gid_t -D_GNU_SOURCE"

	econf \
		--docdir="${EPREFIX}/usr/share/doc/${PF}" \
		--without-rpm \
		--disable-server \
		--disable-docs \
		--disable-refdocs \
		--disable-grapher \
		$(use_enable libvirt virt) \
		$(use_enable sqlite)
}
