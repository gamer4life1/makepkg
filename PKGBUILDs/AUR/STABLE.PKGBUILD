# Maintainer: Hunter Wittenborn <hunter@hunterwittenborn.com>
_release_type=stable

pkgname=makedeb-makepkg
pkgver={pkgver}
pkgrel=1
pkgdesc="Arch Linux build utility, modified for use with makedeb (stable release)"
arch=(any)
depends=('awk' 'libarchive' 'bzip2' 'coreutils' 'fakeroot' 'file' 'findutils' 'gettext' 'gnupg' 'grep' 'gzip' 'sed' 'ncurses' 'xz')
conflicts=('makedeb-makepkg-beta' 'makedeb-makepkg-alpha')
license=('GPL2')
url="https://github.com/makedeb/makepkg"

source=("git+file://${_gitdir}")
sha256sums=('SKIP')

package() {
	cd "makepkg-${pkgver}-${_release_type}"

	# Copy and configure makepkg
	install -Dm 555 "src/makepkg.sh" "${pkgdir}/usr/bin/makedeb-makepkg"
	sed -i 's|.*# REMOVE AT PACKAGING||g' "${pkgdir}/usr/bin/makedeb-makepkg"

	# Copy functions
	mkdir -p "${pkgdir}/usr/share/"
	cp -R "src/functions" "${pkgdir}/usr/share/makedeb-makepkg"
	chmod 555 "${pkgdir}/usr/share/makedeb-makepkg"
}
