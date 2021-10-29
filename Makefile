# Used to obtain folder names for local repository
GITDIR=$(git rev-parse --show-toplevel)
FOLDERNAME=$(basename "${GITDIR}")
BINDIR := /usr/bin

all:
	# Remove prebuild commands, and set package version.
	sed -i 's|.*# REMOVE AT PACKAGING||g' "src/makepkg.sh"
	sed -i "s|makepkg_version='git'|makepkg_version='${pkgver}-${pkgrel}'|" "src/makepkg.sh"

	# Set target OS
	sed -i 's|target_os="arch"|target_os="debian"|' "src/makepkg.sh"

clean:
	echo "nothing to clean"

install:

	# Copy makepkg
	install -Dm 555 "src/makepkg.sh" "${DESTDIR}/usr/bin/makedeb-makepkg"

	# Copy functions
	mkdir -p "${DESTDIR}/usr/share/"
	cp -R "src/functions/" "${DESTDIR}/usr/share/makedeb-makepkg/"
	chmod 555 "${DESTDIR}/usr/share/makedeb-makepkg/"

	# Copy config file
	install -Dm 444 "src/makepkg.conf" "${DESTDIR}/etc/makepkg.conf"

	# Copy makepkg-template
	install -Dm 555 "src/makepkg-template" "${DESTDIR}/usr/bin/makepkg-template"

	# Create pacman binary
	touch "${DESTDIR}/usr/bin/pacman"
	chmod 555 "${DESTDIR}/usr/bin/pacman"
