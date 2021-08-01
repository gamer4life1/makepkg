#!/usr/bin/env bash
set -xe

build() {
	# Get value of $pkgver from master PKGBUILD
	pkgver="$(cat PKGBUILD | grep '^pkgver=' | awk -F '=' '{print $2}')"

	# Set pkgver in deployment PKGBUILD
	sed -i "s|pkgver={pkgver}|pkgver='${pkgver}'|" "PKGBUILDs/LOCAL/${branch^^}.PKGBUILD"

	# Create package
	cd PKGBUILDs/LOCAL

	useradd user
	chmod 777 ./ -R

	sudo -u user -- makedeb -p "${branch^^}.PKGBUILD" --nodeps
}

publish() {
	cd PKGBUILDs

	# Get name of built deb name
	debname="$(find ./ | grep '\.deb$')"

	# Upload package
	curl "https://${proget_server}/debian-packages/upload/makedeb/main/${debname}" \
	     --user "api:${proget_api_key}" \
	     --upload-file "${debname}"
}

##################
## BEGIN SCRIPT ##
##################
"${1}"
