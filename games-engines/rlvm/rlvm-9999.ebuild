# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

PYTHON_COMPAT=( python2_7 )
inherit python-any-r1 scons-utils eutils git-r3

DESCRIPTION="An open source implementation of the RealLive virtual machine for Linux and OSX"
HOMEPAGE="http://www.elliotglaysher.org/rlvm/"

EGIT_REPO_URI="https://github.com/eglaysher/rlvm.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
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

DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}/${PN}-freetype.patch"
	# custom flag goodness
	epatch "${FILESDIR}/${PN}-custom-flags.patch"
	default
}

src_compile() {
	escons --release \
	CFLAGS="${CFLAGS}" \
	LDFLAGS="${LDFLAGS}" \
	|| die "build failed"
}

src_install() {
	dobin "build/${PN}" || die "dobin failed"
	dodoc {AUTHORS,NEWS,STATUS}.TXT README.md
	doman debian/${PN}.6
}
