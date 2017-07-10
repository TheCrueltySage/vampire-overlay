# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit games git-2

DESCRIPTION="An open source implementation of the RealLive virtual machine for Linux and OSX"
HOMEPAGE="http://www.elliotglaysher.org/rlvm/"
SRC_URI=""

EGIT_REPO_URI="git://github.com/eglaysher/${PN}.git"
EGIT_COMMIT="release-${PV}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="media-libs/libsdl[opengl]
	>=dev-libs/boost-1.42
	media-libs/glew
	media-libs/sdl-image[jpeg,png]
	media-libs/sdl-ttf
	media-libs/sdl-mixer[vorbis]
	media-libs/libmad
	>=dev-games/guichan-0.8[opengl,sdl]
	x11-libs/gtk+:2"

DEPEND="${RDEPEND}
	dev-util/scons"

src_prepare() {
	# custom flag goodness
	epatch "${FILESDIR}/${PN}-custom-flags.patch"
}

src_compile() {
	scons --release \
	CFLAGS="${CFLAGS}" \
	LDFLAGS="${LDFLAGS}" \
	|| die "build failed"
}

src_install() {
	dogamesbin "build/${PN}" || die "dobin failed"
	dodoc {AUTHORS,NEWS,README,STATUS}.TXT
	doman debian/${PN}.6

	prepgamesdirs
}
