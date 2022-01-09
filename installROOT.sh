#!/bin/bash

if [  ${#} != 1 ]; then
    echo "usage: ${0} version"
    exit 1
fi

version=${1}

set -e

git clone --branch ${version} https://github.com/root-project/root.git root_src
cmake -DCMAKE_INSTALL_PREFIX=/opt/ROOT/${version} -Broot_build -Sroot_src
cmake --build root_build
cmake --install root_build

# Cleanup
rm -rf root_src root_build
