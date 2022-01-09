#!/bin/bash

if [  ${#} != 1 ]; then
    echo "usage: ${0} version"
    exit 1
fi

version=${1}

set -e

git clone https://github.com/delphes/delphes.git
pushd delphes
git checkout -b ${version} ${version}

cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=/opt/delphes/${version}
cmake --build build
cmake --install build

# Cleanup
popd
rm -rf delphes
