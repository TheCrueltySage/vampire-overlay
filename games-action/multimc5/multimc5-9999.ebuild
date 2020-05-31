# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils cmake-utils git-r3

DESCRIPTION="An advanced open-source launcher for Minecraft written in Qt5."
HOMEPAGE="https://multimc.org/"
EGIT_REPO_URI="https://github.com/MultiMC/MultiMC5.git"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE=""

COMMON_DEPEND="
		dev-qt/qtcore:5
		dev-qt/qtwidgets:5
		dev-qt/qtconcurrent:5
		dev-qt/qtnetwork:5
		dev-qt/qttest:5
		dev-qt/qtgui:5
		dev-qt/qtxml:5"
DEPEND="${COMMON_DEPEND}
		virtual/jdk"
RDEPEND="${COMMON_DEPEND}
		x11-apps/xrandr
		sys-libs/zlib
		virtual/jre
		virtual/opengl"

src_prepare() {
	git submodule update --init
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
			-DCMAKE_BUILD_TYPE=Release
			-DCMAKE_INSTALL_PREFIX="/usr"
			-DMultiMC_LAYOUT=lin-system
			-DMultiMC_NOTIFICATION_URL:STRING="https://files.multimc.org/notifications.json"
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	mkdir -p "${D}/usr/share/pixmaps" "${D}/usr/share/applications"
	cp "${S}/application/resources/multimc/scalable/multimc.svg" "${D}/usr/share/pixmaps/multimc5.svg"
	cp "${FILESDIR}/multimc5.desktop" "${D}/usr/share/applications/multimc5.desktop"
}
