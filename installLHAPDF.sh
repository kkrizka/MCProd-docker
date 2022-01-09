#!/bin/bash

if [  ${#} != 1 ]; then
    echo "usage: ${0} version"
    exit 1
fi

version=${1}

set -e

wget -O LHAPDF.tar.gz https://lhapdf.hepforge.org/downloads/?f=LHAPDF-${version}.tar.gz
tar -xvzf LHAPDF.tar.gz
rm LHAPDF.tar.gz

pushd LHAPDF-${version}

./configure --prefix=/opt/LHAPDF/${version}
make
make install

popd

# Cleanup
rm -rf LHAPDF-${version}
