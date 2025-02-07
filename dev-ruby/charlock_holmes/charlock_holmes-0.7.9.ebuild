# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33 ruby34"

RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_EXTENSIONS=(ext/charlock_holmes/extconf.rb)
RUBY_FAKEGEM_EXTENSION_LIBDIR="lib/charlock_holmes"

RUBY_FAKEGEM_GEMSPEC="charlock_holmes.gemspec"

inherit ruby-fakegem

DESCRIPTION="Character encoding detecting library for Ruby using ICU"
HOMEPAGE="https://github.com/brianmario/charlock_holmes"
SRC_URI="https://github.com/brianmario/charlock_holmes/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

ruby_add_bdepend "test? (
	dev-ruby/minitest )"

CDEPEND="dev-libs/icu:=
		sys-libs/zlib"
DEPEND+=" ${CDEPEND}"
RDEPEND+=" ${CDEPEND}"

all_ruby_prepare() {
	sed -i -e '/bundler/d' test/helper.rb || die

	# Avoid dependency on rake-compiler
	sed -i -e '/rake-compiler/,$ s:^:#:' Rakefile || die

	# Avoid using `which`, and we know make exists.
	sed -e '/which make/,/^end/ s:^:#:' \
		-i ext/charlock_holmes/extconf.rb || die

	sed -e 's/git ls-files/find/' -i ${RUBY_FAKEGEM_GEMSPEC} || die
}

each_ruby_test() {
	${RUBY} -Ilib test/*.rb || die
}
