# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils git-r3

DESCRIPTION="Script to run dedicated X server with discrete nvidia graphics"
HOMEPAGE="https://github.com/Witko/nvidia-xrun"
EGIT_REPO_URI="https://github.com/Witko/nvidia-xrun.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="glvnd"

RDEPEND="
	media-libs/mesa
	x11-apps/xinit
	x11-base/xorg-server[xorg,glvnd?]
	x11-drivers/nvidia-drivers[X,driver,glvnd?]
	x11-libs/libXrandr"

src_prepare() {
	if use glvnd ; then
		sed -in -e "/\/nvidia\/xorg/d" -e "s/\/nvidia/\/extensions\/nvidia/g" nvidia-xorg.conf
	else
		sed -in -e "/\/nvidia\/xorg/d" -e "s/\/nvidia/\/opengl\/nvidia/g" nvidia-xorg.conf
		sed -in -e "s/\/nvidia\//\/opengl\/nvidia\/lib\//g" nvidia-xinitrc
	fi
	eapply_user
}

src_install() {
	dobin nvidia-xrun
	insinto /etc/X11
	doins nvidia-xorg.conf
	insinto /etc/X11/xinit
	doins nvidia-xinitrc
	insinto /etc/default
	doins config/nvidia-xrun
}
