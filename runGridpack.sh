#!/bin/bash

# Exit on error
set -e

# Cleanup existing
if [ -e madevent ]; then
    rm -rf madevent
fi

# Prepare gridpack
if [ ${#} != 1 ]; then
    echo "usage: ${0} gridpack.tar.gz"
    exit 1
fi

tar -xvf ${1}
cd madevent
./bin/compile
#./bin/clean4grid

# Generate events
./bin/gridrun 1000 0 1
./bin/madevent pythia8 GridRun_0 -f
./bin/madevent delphes GridRun_0 -f
