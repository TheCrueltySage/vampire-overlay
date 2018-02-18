# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils git-r3 toolchain-funcs

DESCRIPTION="A small 'net top' tool, grouping bandwidth by process"
HOMEPAGE="http://nethogs.sf.net/"
EGIT_REPO_URI="https://github.com/raboof/nethogs.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""

RDEPEND="
	net-libs/libpcap
	sys-libs/ncurses:0
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

DOCS=( DESIGN README.decpcap.txt README.md )

src_compile() {
	tc-export CC CXX
	emake NCURSES_LIBS="$($(tc-getPKG_CONFIG) --libs ncurses)"
}

src_install() {
	emake DESTDIR="${ED}" PREFIX=/usr install
	dodoc ${DOCS[@]}
}
