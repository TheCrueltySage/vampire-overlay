# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

PYTHON_COMPAT=( python3_6 )
PYTHON_REQ_USE="sqlite"

inherit eutils python-single-r1 xdg-utils

DESCRIPTION="A spaced-repetition memory training program (flash cards)"
HOMEPAGE="https://apps.ankiweb.net"
SRC_URI="https://apps.ankiweb.net/downloads/beta/${PN}-2.1.0beta20-source.tgz -> ${P}.tgz"
S="${WORKDIR}/${PN}-2.1.0beta20"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="latex +recording +sound"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	dev-python/PyQt5[svg,webengine,${PYTHON_USEDEP}]
	>=dev-python/httplib2-0.7.4[${PYTHON_USEDEP}]
	dev-python/beautifulsoup:4[${PYTHON_USEDEP}]
	dev-python/send2trash[${PYTHON_USEDEP}]
	dev-python/decorator[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/markdown[${PYTHON_USEDEP}]
	>=dev-python/pyaudio-0.2.4[${PYTHON_USEDEP}]
	recording? (
		media-sound/lame
	)
	sound? ( || ( media-video/mpv media-video/mplayer ) )
	latex? (
		app-text/texlive
		app-text/dvipng
	)"
DEPEND=""

pkg_setup() {
	python-single-r1_pkg_setup
}

src_prepare() {
	sed -i -e "s/updates=True/updates=False/" \
		aqt/profiles.py || die
	# A hack to not install web-components as their own module named "web", because it is a dumb idea.
	sed -i -e "s/, \"\.\.\"/, \".\"/" \
		aqt/mediasrv.py || die
	default
}

# Nothing to configure or compile
src_configure() {
	true
}

src_compile() {
	true
}

src_install() {
	doicon ${PN}.png
	domenu ${PN}.desktop
	doman ${PN}.1

	dodoc README.md README.development README.contributing
	python_domodule aqt anki
	python_newscript tools/runanki.system anki

	# Localization files go into the anki directory:
	python_moduleinto anki
	python_domodule locale

	# Installing javascript and css aqt needs for rendering
	python_moduleinto aqt
	python_domodule web
}

pkg_postinst() {
	xdg_desktop_database_update
	einfo "This version of anki is not yet meant" 
	einfo "for official packaging, as stated by the developer."
	einfo "The current ebuild is nothing more than an experiment" 
	einfo "of a bleeding-edge fanatic, and should be treated as such."
	einfo "(Even if the current beta seems to work just fine for me)."
}

pkg_postrm() {
	xdg_desktop_database_update
}
