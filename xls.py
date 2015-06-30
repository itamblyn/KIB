#!/usr/bin/env python

## converts the matrix.dat file into a csv file easily opened in something like excel

import sys
import numpy as np

e_fermi = float(sys.argv[1])
print 'warning, subtrated ', e_fermi

inputFile = open('matrix.dat','r')  # this gives the projection of the HOMO onto each KS state

outputFile_real = open('real.csv','w')
outputFile_real_txt = open('real.txt','w')
outputFile_imag = open('imag.csv','w')
outputFile_imag_txt = open('imag.txt','w')
outputFile_mag = open('mag.csv','w')

i = 0

for line in inputFile.readlines():
    j = 0
    for element in line.split():
        real = np.real(np.complex(element))
        imag = np.imag(np.complex(element))
        magnitude = np.sqrt(np.complex(element)*np.conj(np.complex(element)))
        outputFile_real.write(str(real) + ',')
        outputFile_real_txt.write(str(real) + ' ')
        outputFile_imag.write(str(imag) + ',')
        outputFile_imag_txt.write(str(imag) + ' ')
        if (i != j):
            outputFile_mag.write(str(np.real(magnitude)) + ',')
        else:
            outputFile_mag.write(str(real-e_fermi) + ',')
        j += 1

    i +=1
    outputFile_real.write('\n')
    outputFile_real_txt.write('\n')
    outputFile_imag.write('\n')
    outputFile_imag_txt.write('\n')
    outputFile_mag.write('\n')
inputFile.close()

