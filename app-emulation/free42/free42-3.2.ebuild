# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

MY_PV="${PN}-nologo-${PV}"

DESCRIPTION="An HP-42S Calculator Simulator"
HOMEPAGE="https://thomasokken.com/free42/"
SRC_URI="https://thomasokken.com/free42/upstream/${MY_PV}.tgz"
S=${WORKDIR}/${MY_PV}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+alsa"

DEPEND="app-accessibility/at-spi2-core
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:3
	alsa? ( media-libs/alsa-lib )"
RDEPEND="${DEPEND}"

DOCS=( CREDITS HISTORY README )

PATCHES=(
	"${FILESDIR}/${PN}-3.0.14-fix-makefile.patch"
	"${FILESDIR}/${PN}-3.0.16-fix-build-intel-lib.patch"
)

src_compile() {
	local myconf
	use alsa && myconf="AUDIO_ALSA=yes"
	emake CC="$(tc-getCC)" CXX="$(tc-getCXX)" ${myconf} -C gtk
	emake -C gtk clean
	emake CC="$(tc-getCC)" CXX="$(tc-getCXX)" BCD_MATH=1 ${myconf} -C gtk
}

src_install() {
	default
	dobin gtk/free42bin gtk/free42dec
}
