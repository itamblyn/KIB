#!/bin/bash

# this script is intended to show the process. You would likely run this as three separate jobs
# note that paratec uses a large number of cores, e.g. 512

# generate charge density
cp input.scf input
paratec >& OUT

# keep a copy of charge density
cp CD CD.scf 

# write out GW stuff, save converged wavefunctions
cp input.nscf input
paratec >& OUT

# read in wavefunctions, write out ascii
cp input.wfnout input

# mkdir to store them in (paratec will fail if this dir is not present)
mkdir vis

paratec >& OUT
