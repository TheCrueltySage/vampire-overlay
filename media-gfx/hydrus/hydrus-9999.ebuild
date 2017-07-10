# $Header: $
EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit git-r3 eutils
inherit python-single-r1

DESCRIPTION="*booru style image collector and viewer"
HOMEPAGE="http://hydrusnetwork.github.io/hydrus/ https://github.com/hydrusnetwork/hydrus"
EGIT_REPO_URI="https://github.com/hydrusnetwork/hydrus.git"
IUSE="+ffmpeg"

LICENSE="WTFPL"
SLOT="0"
KEYWORDS=""

RDEPEND="
	media-libs/opencv[python,${PYTHON_USEDEP}]
	dev-python/pafy[${PYTHON_USEDEP}]
	dev-python/flvlib[${PYTHON_USEDEP}]
	dev-python/hsaudiotag[${PYTHON_USEDEP}]

	dev-python/twisted-core[${PYTHON_USEDEP}]
	dev-python/twisted-web[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/PyPDF2[${PYTHON_USEDEP}]
	dev-python/beautifulsoup[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/lz4[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/potr[${PYTHON_USEDEP}]
	dev-python/pycrypto[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/PySocks[${PYTHON_USEDEP}]
	dev-python/twisted-web[${PYTHON_USEDEP}]
	dev-python/wxpython:3.0[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]
	dev-python/send2trash[${PYTHON_USEDEP}]

	sys-apps/coreutils

	ffmpeg? ( virtual/ffmpeg )
	${PYTHON_DEPS}"

DEPEND="${RDEPEND}"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

src_prepare() {
	epatch "${FILESDIR}/paths-in-opt.patch"

	epatch_user

	# remove useless directories and files due to paths-in-opt.patch
	rm Readme.txt
	rm -r db/
	
	chmod a-x include/*.py
	rm -f "include/pyconfig.h"
	rm -f "include/Test"*.py
	rm -rf "static/testing"
}

src_compile() {
	python2 -OO -m compileall -f .
}

src_install() {
	DOC="/usr/share/doc/${PF}"
	elog "Hydrus includes an excellent help, that can either be viewed at"
	elog "${DOC}/html/index.html"
	elog "or accessed through the hydrus help menu."

	dodoc COPYING README.md
	rm COPYING README.md

	dohtml -r help/
	rm -r help/
	ln -s "${DOC}/html" help

	use ffmpeg && ln -s "$(which ffmpeg)" bin/ffmpeg

	insopts -m0755
	insinto /opt/${PN}
	doins -r ${S}/* || die "Failed to move hydrus to opt."

	exeinto /usr/bin
	doexe "${FILESDIR}/hydrus-server"
	doexe "${FILESDIR}/hydrus-client"
}
