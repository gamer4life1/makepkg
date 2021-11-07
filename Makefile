CONFIG_FILE = $(shell cat .data.json)
CURRENT_VERSION = $(shell echo '$(CONFIG_FILE)'  | jq -r -r '. | .current_pkgver + "-" + .current_pkgrel')

.ONESHELL:

all:
	true

prepare:
	sed -i 's|.*# REMOVE AT PACKAGING||g' src/makepkg.sh
	sed -i 's|$$$${MAKEPKG_VERSION}|$(CURRENT_VERSION)|' src/makepkg.sh
	sed -i 's|$$$${TARGET_OS}|$(TARGET_OS)|' src/makepkg.sh

ifeq ("$(TARGET_OS)", "debian")
	sed -i 's|target_os="arch"|target_os="debian"|' src/makepkg.sh
endif

package:
	install -Dm 755 src/makepkg.sh '$(DESTDIR)/usr/bin/makedeb-makepkg'
	
	cd src/functions/
	find ./ -type f -exec install -Dm 755 '{}' '$(DESTDIR)/usr/share/makedeb-makepkg/{}' \;
	cd ../../
	
	install -Dm 644 src/makepkg.conf '$(DESTDIR)/etc/makepkg.conf'
	install -Dm 755 src/makepkg-template '$(DESTDIR)/usr/bin/makepkg-template'

ifeq ("$(PACMAN_BINARY)", "1")
	touch '$(DESTDIR)/usr/bin/pacman'
	chmod 755 '$(DESTDIR)/usr/bin/pacman'
endif

# This is for use by dpkg-buildpackage. Please use prepare and package instead.
install:
	$(MAKE) prepare TARGET_OS="debian"
	$(MAKE) package DESTDIR="$(DESTDIR)" PACMAN_BINARY=1

