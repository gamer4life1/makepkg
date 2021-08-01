#!/usr/bin/env bash
set -xe

build() {
	# Get value of $pkgver from master PKGBUILD
	pkgver="$(cat PKGBUILD | grep '^pkgver=' | awk -F '=' '{print $1}')"

	# Set pkgver in deployment PKGBUILD
	sed -i "s|pkgver={pkgver}|pkgver='${pkgver}'" "PKGBUILDs/LOCAL/${branch^^}.PKGBUILD"

	# Create package
	cd PKGBUILDs

	makedeb -p "${branch^^}.PKGBUILD" --nodeps
}

publish() {
	cd PKGBUILDs

	# Get name of built deb name
	debname="$(find ./*.deb 2> /dev/null)"

	# Upload package
	curl "https://${proget_server}/debian-packages/upload/makedeb/main/${debname}" \
	     --user "api:${proget_api_key}" \
	     --upload-file "${debname}"
}

##################
## BEGIN SCRIPT ##
##################
"${1}"
