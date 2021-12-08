#!/bin/bash

# Exit on error
set -e

# Work directory
me=$(pwd)

# Run!
/opt/MG5aMC/3.3.1/bin/mg5_aMC < ${me}/Cards/dijet.proc
./runGridpack.sh PROC_dijet/run_01_gridpack.tar.gz
