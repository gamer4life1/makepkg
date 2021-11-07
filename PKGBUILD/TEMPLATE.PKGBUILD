# Maintainer: Hunter Wittenborn <hunter@hunterwittenborn.com>
_release=$${release}
_target=$${target}

pkgname=$${pkgname}
pkgver=$${pkgver}
pkgrel=$${pkgrel}
arch=(any)
depends=($${depends})
makedepends=($${makedepends})
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

    if [[ "${_target}" == "local" || "${_target}" == "mpr" ]]; then
        make package DESTDIR="${pkgdir}" PACMAN_BINARY=1
    else
	    make package DESTDIR="${pkgdir}"
    fi
}
