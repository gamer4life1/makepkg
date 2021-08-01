# Maintainer: Hunter Wittenborn
pkgname=makedeb-makepkg
pkgver=7.0.0
pkgrel=1
arch=(any)
depends=('curl' 'fakeroot' 'libarchive-tools' 'coreutils' 'binutils' 'zstd')
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

	# Copy makepkg binary
	install -Dm 555 "src/makepkg.sh" "${pkgdir}/usr/bin/makepkg"

	# Copy functions
	mkdir -p "${pkgdir}/usr/share/"
	cp -R "src/functions" "${pkgdir}/usr/share/makepkg"

	# Copy config file
	cp "src/makepkg.conf" "${pkgdir}/etc/makepkg.conf"

	# Copy makepkg-template
	install -Dm 555 "src/makepkg-template" "${pkgdir}/usr/bin/makepkg-template"
}
