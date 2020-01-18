# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_5,3_6,3_7,3_8} pypy )

inherit distutils-r1 git-r3

DESCRIPTION="Python MPD client library"
HOMEPAGE="https://github.com/Mic92/python-mpd2"
EGIT_REPO_URI="https://github.com/Mic92/python-mpd2.git"

LICENSE="LGPL-3"
KEYWORDS=""
SLOT="0"
IUSE="test"

DEPEND="test? ( dev-python/mock[${PYTHON_USEDEP}] )
	dev-python/setuptools[${PYTHON_USEDEP}]"

DOCS=( doc/changes.rst doc/topics/{advanced,commands,getting-started,logging}.rst README.rst )

python_test() {
	"${PYTHON}" test.py || die "Tests fail with ${EPYTHON}"
}
