#!/bin/bash
# simple script which loops over iota or beta states and computes norm. If this value comes
# out at less than 1 (or very close), chances are you've made a mistake. Possible causes could be 
# the FFT grid is not the same on all three sets of wfns, you've not included enough unoccupied kappa,
# or some other user error

for file in iota?.new
do
  echo -n $file " "
  awk '/#/{print $0} !/#/{sum+=($2*$2. + $3*$3.); print sum}'  $file | tail -1

done
