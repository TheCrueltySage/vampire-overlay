# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python{2_7,3_5,3_6,3_7,3_8} pypy )

inherit distutils-r1

DESCRIPTION="Python library for parsing, manipulating and indexing FLV files"
HOMEPAGE="http://wulczer.org/flvlib/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
