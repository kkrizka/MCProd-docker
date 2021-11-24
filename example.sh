#!/bin/bash

me=$(pwd)

/opt/MG5aMC/3.3.0/bin/mg5_aMC < ${me}/Cards/dijet.proc
./PROC_dijet/bin/generate_events -f
pushd PROC_dijet/Events/run_01
/opt/pythia/8.306/MG5aMC_PY8_interface ${me}/Cards/shower.cmd
/opt/delphes/3.5.0/bin/DelphesHepMC2 ${me}/Cards/delphes_card_default.dat delphes.root tag_1_pythia8_events.hepmc
