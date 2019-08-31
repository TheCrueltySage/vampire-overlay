# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3 cmake-utils

DESCRIPTION="A new generation, open-source graphics plugin for N64 emulators."
HOMEPAGE="https://github.com/gonetz/GLideN64"
EGIT_REPO_URI="https://github.com/gonetz/GLideN64.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="egl"

RDEPEND=">=games-emulation/mupen64plus-core-2.5:0="
DEPEND="${RDEPEND}
		virtual/pkgconfig"
CMAKE_USE_DIR="${S}/src"
CMAKE_BUILD_TYPE="Release"

src_prepare() {
	./src/getRevision.sh
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DEGL="$(usex egl)"
		-DMUPENPLUSAPI=ON
		-DUSE_SYSTEM_LIBS=ON
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	insinto /usr/lib64/mupen64plus
	newins ${BUILD_DIR}/plugin/Release/mupen64plus-video-GLideN64.so mupen64plus-video-gliden64.so
}
