#!/usr/bin/env python

# the eigenvalue file is of the form
# 1  1 1  -24.305 -24.305

import sys
import numpy as np
import random
from numpy import linalg as LA

inputFile = open(sys.argv[1],'r')  # this gives the projection of the iota onto each kappa state
for line in inputFile:
    last=line
diagonal_n = int(last.split()[0]) # figures out how many states are used in projection
print diagonal_n

inputFile.seek(0) # rewind

inputFile.readline() # skip header
inputFile.readline()


LHS_DFT = np.zeros(diagonal_n, dtype=np.complex)

for line in inputFile.readlines():

    n, alpha = int(line.split()[0]) - 1, np.complex(float(line.split()[1]), float(line.split()[2]))
    LHS_DFT[n] = alpha

inputFile.close()

inputFile = open(sys.argv[2],'r')  # this gives the projection of the HOMO onto each KS state

inputFile.readline() # skip header
inputFile.readline()

RHS_DFT = np.zeros(diagonal_n, dtype=np.complex)

for line in inputFile.readlines():

    n, alpha = int(line.split()[0]) - 1, np.complex(float(line.split()[1]), float(line.split()[2]))
    RHS_DFT[n] = alpha

inputFile.close()

inputFile = open(sys.argv[3],'r')

eig_dft_array = np.zeros(diagonal_n, dtype=np.float)
eig_gw_array = np.zeros(diagonal_n, dtype=np.float)

iprime = []

for line in inputFile.readlines():
    n = int(line.split()[0]) - 1
    eig_dft_array[n] = float(line.split()[3])
    eig_gw_array[n]  = float(line.split()[4])
    
sum_dft = 0.
sum_gw = 0.

for i in range(diagonal_n):

    omega_dft = eig_dft_array[i]
    omega_gw = eig_gw_array[i]
        
    sum_dft += LHS_DFT[i]*omega_dft*np.conj(RHS_DFT[i])
    sum_gw +=  LHS_DFT[i]*omega_gw*np.conj(RHS_DFT[i])

inputFile.close()

print sum_dft
