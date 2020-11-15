# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit git-r3 eutils meson flag-o-matic

DESCRIPTION="Nintendo DS emulator"
HOMEPAGE="http://desmume.org/"
EGIT_REPO_URI="https://github.com/TASVideos/desmume.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="openal gtk glade wifi"

DEPEND="virtual/opengl
	sys-libs/zlib
	dev-libs/zziplib
	media-libs/libsdl[joystick]
	x11-libs/agg
	virtual/libintl
	sys-devel/gettext
	openal? ( media-libs/openal )
	gtk? ( >=x11-libs/gtk+-2.8.0
		x11-libs/gtkglext )
	glade? ( gnome-base/libglade
		x11-libs/gtkglext )
	wifi? ( net-libs/libpcap )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P}/desmume/src/frontend/posix"

src_prepare() {
	use wifi && \
		eerror "wifi support is broken and may not work"

	if ! use gtk && use glade; then
		einfo "glade support was requested but not gtk"
		einfo "glade(libglade) depends on gtk"
		einfo "it may be useful to enable gtk support after all"
	fi

	append-cppflags -std=gnu++0x

	default
}

src_configure() {
	local emesonargs=(
		$(meson_use openal)
		$(meson_use wifi)
		$(meson_use glade frontend-glade)
		$(meson_use gtk frontend-gtk)
	)
	meson_src_configure
}

src_compile() {
	meson_src_compile
}

src_test() {
	meson_src_test
}

src_install() {
	meson_src_install

	if ! use gtk; then
		[ -f "${D}/bin/desmume" ] && rm "${D}/bin/desmume"
	fi
	if ! use glade; then
		[ -f "${D}/bin/desmume-glade" ] && rm "${D}/bin/desmume-glade"
	fi
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
