# Maintainer: Hunter Wittenborn <hunter@hunterwittenborn.com>
_release=$${release}
_target=$${target}

pkgname=$${pkgname}
pkgver=$${pkgver}
pkgrel=$${pkgrel}
arch=(any)
depends=($${depends})
conflicts=($${conflicts})
license=('GPL2')
url="https://github.com/makedeb/makepkg"

source=("makepkg::git+${url}/#tag=v${pkgver}-${pkgrel}-${_release}")
sha256sums=('SKIP')

prepare() {
	cd makepkg/
	make prepare TARGET="${_target}"
}

package() {
	cd makepkg/
	make package DESTDIR="${pkgdir}" TARGET_OS="${_target}"
}
