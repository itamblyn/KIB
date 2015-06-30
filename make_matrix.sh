#!/bin/bash

for LHS in iota?.new 
do 
  for RHS in iota?.new 
  do
    matrix_element=`~/git/KIB/get_matrix_element.py $LHS $RHS edft`
    echo -n $matrix_element
    echo -n " "
  done  
  echo   
done
