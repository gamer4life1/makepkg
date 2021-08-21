# Maintainer: Hunter Wittenborn <hunter@hunterwittenborn.com>
pkgname=makedeb-makepkg
pkgver=8.4.0
pkgrel=1
arch=(any)
depends=('curl' 'fakeroot' 'libarchive-tools' 'coreutils' 'binutils' 'zstd' 'gettext')
conflicts=('makepkg')
license=('GPL2')
url="https://github.com/hwittenborn/makepkg"

# Used to obtain folder names for local repository
_gitdir=$(git rev-parse --show-toplevel)
_foldername=$(basename "${_gitdir}")

source=("git+file://${_gitdir}")
sha256sums=('SKIP')

prepare() {
  # Remove prebuild commands, and set package version.
  sed -i 's|.*# REMOVE AT PACKAGING||g' "${_foldername}/src/makepkg.sh"
  sed -i "s|makepkg_version='git'|makepkg_version='${pkgver}-${pkgrel}'|" "${_foldername}/src/makepkg.sh"

  # Set target OS
  sed -i 's|target_os="arch"|target_os="debian"|' "${_foldername}/src/makepkg.sh"
}

package() {
	cd "${_foldername}"

  # Copy makepkg
	install -Dm 555 "src/makepkg.sh" "${pkgdir}/usr/bin/makedeb-makepkg"

	# Copy functions
	mkdir -p "${pkgdir}/usr/share/"
	cp -R "src/functions/" "${pkgdir}/usr/share/makedeb-makepkg/"
	chmod 555 "${pkgdir}/usr/share/makedeb-makepkg/"

	# Copy config file
	install -Dm 444 "src/makepkg.conf" "${pkgdir}/etc/makepkg.conf"

	# Copy makepkg-template
	install -Dm 555 "src/makepkg-template" "${pkgdir}/usr/bin/makepkg-template"

	# Create pacman binary
	touch "${pkgdir}/usr/bin/pacman"
	chmod 555 "${pkgdir}/usr/bin/pacman"
}
