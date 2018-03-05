# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

EGO_PN="github.com/mvdan/sh"

if [[ ${PV} = *9999* ]]; then
	inherit golang-vcs
else
	KEYWORDS="~amd64 ~x86"
	EGIT_COMMIT="v${PV}"
	SRC_URI="https://${EGO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
	inherit golang-vcs-snapshot
fi
inherit golang-build

DESCRIPTION="A shell parser, formatter and interpreter (POSIX/Bash/mksh)"
HOMEPAGE="https://${EGO_PN}"
LICENSE="BSD"
SLOT="0/${PV}"
IUSE=""
DEPEND=""
RDEPEND=""

src_prepare() {
	mkdir -p src/mvdan.cc
	mv src/"${EGO_PN}" src/mvdan.cc/
}

src_compile() {
	pushd "${S}/src/mvdan.cc/sh/cmd/shfmt" > /dev/null
		GOPATH="${S}" go build -ldflags='-s -w'
#		EGO_BUILD_FLAGS="-ldflags \"-s -w\""
#		EGO_PN="${EGO_PN}/cmd/shfmt" GOPATH="${S}" golang-build_src_compile
	popd > /dev/null
}

src_install() {
	pushd "${S}/src/mvdan.cc/sh" > /dev/null
		dobin "cmd/shfmt/shfmt"
		dodoc README.md
	popd > /dev/null
}
