# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python{2_7,3_5,3_6,3_7,3_8} pypy )

inherit distutils-r1

DESCRIPTION="Python library for reading metadata (tags) of mp3, mp4, wma, ogg, flac and aiff files"
HOMEPAGE="http://hg.hardcoded.net/hsaudiotag/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
