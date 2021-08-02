# Maintainer: Hunter Wittenborn <hunter@hunterwittenborn.com>
_release_type=stable

pkgname=makedeb-makepkg
pkgver={pkgver}
pkgrel=1
pkgdesc="Arch Linux build utility, modified for use with makedeb (stable release)"
arch=(any)
depends=('curl' 'fakeroot' 'libarchive-tools' 'coreutils' 'binutils' 'zstd' 'gettext')
conflicts=('makedeb-makepkg-beta' 'makedeb-makepkg-alpha')
replaces=('makepkg')
provides=('makepkg')
license=('GPL2')
url="https://github.com/makedeb/makepkg"

source=("${url}/archive/refs/tags/v${pkgver}-${_release_type}.tar.gz")
sha256sums=('SKIP')

package() {
	cd "makepkg-${pkgver}-${_release_type}"

	# Copy and configure makepkg
	install -Dm 555 "src/makepkg.sh" "${pkgdir}/usr/bin/makedeb-makepkg"
  sed -i 's|.*# REMOVE AT PACKAGING||g' "${pkgdir}/usr/bin/makedeb-makepkg"
  sed -i "s|makepkg_version='git'|makepkg_version='${pkgver}-${pkgrel}'|" "${pkgdir}/usr/bin/makedeb-makepkg"

	# Copy functions
	mkdir -p "${pkgdir}/usr/share/"
	cp -R "src/functions" "${pkgdir}/usr/share/makedeb-makepkg"
	chmod 555 "${pkgdir}/usr/share/makedeb-makepkg"

	# Copy config file
	install -Dm 444 "src/makepkg.conf" "${pkgdir}/etc/makepkg.conf"

	# Copy makepkg-template
	install -Dm 555 "src/makepkg-template" "${pkgdir}/usr/bin/makepkg-template"

	# Create pacman binary
	touch "${pkgdir}/usr/bin/pacman"
	chmod 555 "${pkgdir}/usr/bin/pacman"
}
