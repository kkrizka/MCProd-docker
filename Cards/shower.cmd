! Inputs and outputs
Main:numberOfEvents = -1
Beams:frameType     = 4
Beams:LHEF          = unweighted_events.lhe.gz
HEPMCoutput:file    = tag_1_pythia8_events.hepmc

LHEFInputs:nSubruns = 1
Main:subrun         = 0

! Stuff I blindly copied from the MG5 default cmd
SysCalc:fullCutVariation = off
HEPMCoutput:scaling      = 1.0000000000e+09
Check:epTolErr           = 1.0000000000e-02
JetMatching:etaJetMax    = 1.0000000000e+03
JetMatching:setMad       = off
