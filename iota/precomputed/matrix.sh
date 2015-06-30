#!/bin/bash

for LHS in iota??? 
do 
  for RHS in iota??? 
  do
    matrix_element=`../../get_matrix_element.py $LHS $RHS ../../kappa/eigenvalues`
    echo -n $matrix_element
    echo -n " "
  done  
  echo   
done
