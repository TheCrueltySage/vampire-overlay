# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PLOCALES="ar_SA ay_WI be_BY be_BY@latin bg_BG cs_CZ de_DE fa_IR fr_FR el_GR es_AR es_BO es_ES it_IT ko_KR ja_JP lt_LT mk_MK nl_NL pl_PL pt_BR qu_WI ru_RU sk_SK sq_AL sr_SR sv_SE tg_TJ tk_TM tr_TR uk_UA vi_VN zh_CN zh_TW"

inherit l10n eutils qmake-utils git-r3

DESCRIPTION="Feature-rich dictionary lookup program"
HOMEPAGE="http://goldendict.org/"
EGIT_REPO_URI="https://github.com/goldendict/goldendict.git"
EGIT_BRANCH="qt4x5"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="debug"

RDEPEND="
	>=app-text/hunspell-1.2
	dev-libs/eb
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qthelp:5
	dev-qt/qtnetwork:5
	dev-qt/qtprintsupport:5
	dev-qt/qtsingleapplication[qt5]
	dev-qt/qtsql:5
	dev-qt/qtsvg:5
	dev-qt/qtwebkit:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	media-libs/libao
	media-libs/libogg
	media-libs/libvorbis
	sys-libs/zlib
	x11-libs/libXtst
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

PATCHES=(
	 "${FILESDIR}/${PN}-36a761108-qtsingleapplication-unbundle.patch"
)

src_prepare() {
	epatch_user
	l10n_for_each_disabled_locale_do editpro
	# don't install duplicated stuff and fix installation path
	sed -i \
		-e '/desktops2/d' \
		-e '/icons2/d' \
		${PN}.pro || die

	# add trailing semicolon
	sed -i -e '/^Categories/s/$/;/' redist/${PN}.desktop || die
}

src_configure() {
	PREFIX="${D}"/usr eqmake5
}

src_install() {
	emake install
	#l10n_for_each_locale_do insqm
}

editpro() {
	sed -e "s;locale/${1}.ts;;" -i ${PN}.pro || die
}

#insqm() {
#	insinto /usr/share/apps/${PN}/locale
#	doins locale/${1}.qm
#}
