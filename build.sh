#!/bin/sh

DEB_NAME=obs-plugin-backgroundremoval
DEB_VERSION=${1:-1.1.13}
DEB_ARCH=`dpkg --print-architecture`

dpkg -s podman 2>/dev/null >/dev/null
if [ $? -ne 0 ]; then
	echo "ERROR: 'podman' not installed, please install like so and re-run this script:"
	echo "       sudo apt install -y podman"
	exit 1
fi

if [ -d ./build ]; then
	rm -rf "./build"
fi
mkdir ./build

podman build --build-arg PACKAGE_VERSION="${DEB_VERSION}" --tag "${DEB_NAME}:${DEB_VERSION}" .
podman run --env CPU_ARCH=`uname -m` --interactive --tty --rm --volume "${PWD}/build:/build" "${DEB_NAME}:${DEB_VERSION}"

if [ -d "./${DEB_NAME}_${DEB_VERSION}" ]; then
	rm -rf "./${DEB_NAME}_${DEB_VERSION}/"
fi
mkdir --parents "./${DEB_NAME}_${DEB_VERSION}/DEBIAN"
cat << EOF > "./${DEB_NAME}_${DEB_VERSION}/DEBIAN/control"
Package: ${DEB_NAME}
Version: ${DEB_VERSION}
Architecture: ${DEB_ARCH}
Depends: obs-studio
Maintainer: Juergen Pabel <juergen@pabel.net>
Description: OBS Studio plugin backgroundremoval
EOF

(cd ./build ; tar cf - .) | (cd "./${DEB_NAME}_${DEB_VERSION}" ; tar xf -)
dpkg-deb --root-owner-group --build "${DEB_NAME}_${DEB_VERSION}" && dpkg-name -o -s . "./${DEB_NAME}_${DEB_VERSION}.deb"
