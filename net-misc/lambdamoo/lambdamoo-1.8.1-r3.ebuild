# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit autotools toolchain-funcs

DESCRIPTION="networked mud that can be used for different types of collaborative software"
HOMEPAGE="https://sourceforge.net/projects/lambdamoo/"
SRC_URI="https://downloads.sourceforge.net/lambdamoo/LambdaMOO-${PV}.tar.gz"

LICENSE="LambdaMOO GPL-2"
SLOT="0"
KEYWORDS="~sparc ~x86"
IUSE=""

DEPEND="app-alternatives/yacc"
RDEPEND=""

S=${WORKDIR}/MOO-${PV}

src_prepare() {
	default

	eapply "${FILESDIR}"/${PV}-enable-outbound.patch
	sed -i Makefile.in \
		-e '/ -o /s|$(CFLAGS)|& $(LDFLAGS)|g' \
		|| die "sed Makefile.in"
	eautoreconf
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS} -DHAVE_MKFIFO=1"
}

src_install() {
	dosbin moo
	insinto /usr/share/${PN}
	doins Minimal.db
	dodoc *.txt README*

	newinitd "${FILESDIR}"/lambdamoo.rc ${PN}
	newconfd "${FILESDIR}"/lambdamoo.conf ${PN}
}
