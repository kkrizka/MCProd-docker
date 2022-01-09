#!/bin/bash

if [  ${#} != 1 ]; then
    echo "usage: ${0} version"
    exit 1
fi

version=${1}

set -e

mkdir rivet_build
pushd rivet_build
wget https://gitlab.com/hepcedar/rivetbootstrap/raw/${version}/rivet-bootstrap
chmod +x rivet-bootstrap

INSTALL_PREFIX=/opt/rivet/${version} ./rivet-bootstrap

popd

# Cleanup
rm -rf rivet_build
