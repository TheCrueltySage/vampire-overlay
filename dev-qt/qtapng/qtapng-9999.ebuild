# Copyright 2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3 qmake-utils

DESCRIPTION="apng image plugin for Qt to support animated PNGs"
HOMEPAGE="https://github.com/Skycoder42/qapng"
EGIT_REPO_URI="https://github.com/Skycoder42/qapng.git"

LICENSE="BSD"
SLOT="5"
KEYWORDS=""

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	sys-libs/zlib
	media-libs/libpng[apng]
	"
RDEPEND="${DEPEND}"

src_configure() {
	eqmake5
}

src_install() {
	emake INSTALL_ROOT="${D}" install
}
