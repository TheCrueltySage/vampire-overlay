# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3 qmake-utils

DESCRIPTION="mupen64plus GUI written in Qt5"
HOMEPAGE="https://github.com/m64p/mupen64plus-gui"
EGIT_REPO_URI="https://github.com/m64p/mupen64plus-gui.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	media-libs/libsdl2
	games-emulation/mupen64plus-core
	games-emulation/mupen64plus-input-sdl
	app-arch/p7zip
	"
RDEPEND="${DEPEND}"

src_configure() {
	eqmake5
}

src_install() {
	dobin mupen64plus-gui
}
