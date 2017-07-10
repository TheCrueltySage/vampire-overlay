# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=(python2_7)

inherit eutils distutils-r1 git-r3

DESCRIPTION="An extensible music server that plays music from local disk and more"
HOMEPAGE="http://mopidy.com https://github.com/mopidy/mopidy"
EGIT_REPO_URI="https://github.com/mopidy/mopidy.git"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE="test"

RDEPEND="dev-python/pykka[${PYTHON_USEDEP}]
		 >=dev-python/gst-python-1.2.3:1.0[${PYTHON_USEDEP}]
		 dev-python/pygobject[${PYTHON_USEDEP}]
		 dev-python/requests[${PYTHON_USEDEP}]
		 >=media-libs/gst-plugins-ugly-1.2.3:1.0
		 >=media-plugins/gst-plugins-mad-1.2.3:1.0
		 >=media-plugins/gst-plugins-soup-1.2.3:1.0
		 >=media-plugins/gst-plugins-flac-1.2.3:1.0
		 www-servers/tornado[${PYTHON_USEDEP}]"

DEPEND="test? ( ${RDEPEND}
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/responses[${PYTHON_USEDEP}] )
		dev-python/setuptools[${PYTHON_USEDEP}]"

#S=${WORKDIR}/Mopidy-${PV}

src_install() {
		distutils-r1_src_install
		domenu extra/desktop/mopidy.desktop || die
}

python_test() {
		py.test || die
}
