# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_{5,6,7,8} )

inherit python-r1 git-r3

DESCRIPTION="A curses mixer for pulseaudio"
HOMEPAGE="https://github.com/GeorgeFilipkin/pulsemixer"
EGIT_REPO_URI="https://github.com/GeorgeFilipkin/pulsemixer.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""

RDEPEND="${PYTHON_DEPS} media-sound/pulseaudio"

src_install() {
	dobin pulsemixer
	python_replicate_script "${D}/usr/bin/pulsemixer"
	dodoc README.md
}
