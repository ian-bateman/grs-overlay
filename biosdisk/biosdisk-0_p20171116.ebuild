# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

PYTHON_COMPAT=( python2_7 )

inherit python-single-r1

DESCRIPTION="A script that creates floppy boot images to flash Dell BIOSes"
HOMEPAGE="https://github.com/dell/biosdisk"

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://github.com/sarnold/schedule"
	EGIT_BRANCH="master"
	EGIT_COMMIT="2285469f2adffd0e2ad013f93309d51e88a0e29b"
	inherit git-r3
	KEYWORDS=""
else
	GIT_COMMIT="f534dd22a795dca9c42f44b52f206bf02eadb682"
	SRC_URI="https://github.com/dell/${PN}/archive/${GIT_COMMIT}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-${GIT_COMMIT}"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	>=app-text/dos2unix-5.0
	sys-boot/syslinux
	${PYTHON_DEPS}
"

#S="${WORKDIR}/${PN}-${GIT_COMMIT}"

src_install() {
	python_fix_shebang blconf

	dosbin biosdisk blconf

	dodoc AUTHORS README README.dosdisk TODO VERSION
	gunzip biosdisk.8.gz || die
	doman biosdisk.8

	insinto /usr/share/biosdisk
	doins dosdisk.img dosdisk{288,8192,20480}.img biosdisk-mkrpm-{fedora,redhat,generic}-template.spec

	insinto /etc
	doins biosdisk.conf
}
