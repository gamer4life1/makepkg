# Maintainer: Hunter Wittenborn <hunter@hunterwittenborn.com>
pkgname=makedeb-makepkg-alpha
pkgver={pkgver}
pkgrel=1
pkgdesc="Arch Linux build utility, modified for use with makedeb (alpha release)"
arch=(any)
depends=('curl' 'fakeroot' 'libarchive-tools' 'coreutils' 'binutils' 'zstd')
conflicts=('makepkg' 'makedeb-makepkg' 'makedeb-makepkg-beta')
replaces=('makepkg')
provides=('makepkg')
license=('GPL2')
url="https://github.com/hwittenborn/makepkg"

# Used to obtain folder names for local repository
_gitdir=$(git rev-parse --show-toplevel)
_foldername=$(basename "${_gitdir}")

source=("git+file://${_gitdir}")
sha256sums=('SKIP')

package() {
	cd "${_foldername}"

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

	# Set target OS
	sed -i 's|target_os="arch"|target_os="debian"|' "${pkgdir}/usr/bin/makedeb-makepkg"

	# Create pacman binary
	touch "${pkgdir}/usr/bin/pacman"
	chmod 555 "${pkgdir}/usr/bin/pacman"
}
