# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils autotools git-r3

DESCRIPTION="An ncurses based mpd client with vi like key bindings"
HOMEPAGE="http://vimpc.sourceforge.net/"
EGIT_REPO_URI="https://github.com/boysetsfrog/vimpc.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="boost taglib"

RDEPEND="dev-libs/libpcre
	media-libs/libmpdclient
	boost? ( dev-libs/boost )
	taglib? ( media-libs/taglib )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( AUTHORS README.md doc/vimpcrc.example )

src_prepare() {
	eapply_user
	eapply "${FILESDIR}"/tinfo.patch
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable boost) \
		$(use_enable taglib) \
		--docdir="${EPREFIX}"/usr/share/doc/${PF}
}

src_install() {
	einstalldocs
	default

	# vimpc will look for help.txt
	docompress -x /usr/share/doc/${PF}/help.txt
}
