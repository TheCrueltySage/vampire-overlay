# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-multilib git-r3

DESCRIPTION="Discord RPC lib"
HOMEPAGE="https://github.com/discordapp/discord-rpc"
EGIT_REPO_URI="https://github.com/discordapp/discord-rpc.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	dev-libs/rapidjson
	"
RDEPEND="${DEPEND}"

src_prepare() {
	#sed 's:Werror:fpic:g' -i "${S}/src/CMakeLists.txt"
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_EXAMPLES=OFF
		-DBUILD_SHARED_LIBS=ON
	)

	cmake-multilib_src_configure
}

