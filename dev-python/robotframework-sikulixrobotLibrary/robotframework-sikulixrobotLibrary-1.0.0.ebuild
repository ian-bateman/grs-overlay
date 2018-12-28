# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL=1

MY_PN="SikuliXRobotLibrary"
EGIT_REPO_URI="https://github.com/jaredfin/${MY_PN}.git"

inherit distutils-r1 git-r3

DESCRIPTION="SikuliX library for Robot Framework"
HOMEPAGE="https://github.com/jaredfin/SikuliXRobotLibrary"

if [[ ${PV} = 9999* ]]; then
	EGIT_BRANCH="master"
	KEYWORDS=""
else
	EGIT_COMMIT="33b6af7173fc780f6482db7636e5637018ab68a2"
	KEYWORDS="~amd64"
fi

LICENSE="MIT"
SLOT="0"
IUSE="doc"

# Note this only works with openjdk-bin:12 so far (os-xtoo overlay fork)
# since musl profile cannot yet bootstrap its own jdk from source
RDEPEND="${PYTHON_DEPS}
	dev-java/sikulixapi-bin
	>=virtual/jre-11
	dev-java/jython"

DEPEND="${PYTHON_DEPS}
	dev-python/selenium[${PYTHON_USEDEP}]
	dev-python/docutils[${PYTHON_USEDEP}]
	dev-python/decorator[${PYTHON_USEDEP}]
	dev-python/robotframework[jython,${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]"

python_install() {
	local DOCS=( README.md )
	use doc && local HTML_DOCS=( docs/. )

	#python_export EPYTHON
	distutils-r1_python_install
}
