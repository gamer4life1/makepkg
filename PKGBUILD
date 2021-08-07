# Maintainer: Hunter Wittenborn
pkgname=makedeb-makepkg
pkgver=7.3.0
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

package() {
	cd "${_foldername}"

	# Copy and configure makepkg
	install -Dm 555 "src/makepkg.sh" "${pkgdir}/usr/bin/${pkgname}"
	sed -i 's|.*# REMOVE AT PACKAGING||g' "${pkgdir}/usr/bin/${pkgname}"
  sed -i "s|makepkg_version='git'|makepkg_version='${pkgver}-${pkgrel}'|" "${pkgdir}/usr/bin/${pkgname}"

	# Copy functions
	mkdir -p "${pkgdir}/usr/share/"
	cp -R "src/functions" "${pkgdir}/usr/share/${pkgname}"
	chmod 555 "${pkgdir}/usr/share/${pkgname}"

	# Copy config file
	install -Dm 444 "src/makepkg.conf" "${pkgdir}/etc/makepkg.conf"

	# Copy makepkg-template
	install -Dm 555 "src/makepkg-template" "${pkgdir}/usr/bin/makepkg-template"

	# Set target OS
	sed -i 's|target_os="arch"|target_os="debian"|' "${pkgdir}/usr/bin/${pkgname}"

	# Create pacman binary
	touch "${pkgdir}/usr/bin/pacman"
	chmod 555 "${pkgdir}/usr/bin/pacman"
}
