!       program get_matrix_element.f90

implicit none

integer i,ii, j, ik, ix, iy, iz, nx, ny, nz, Nsteps, nvoxel, counter, nband_KS, N
character(128) fin, fin_lhs, fin_rhs, fin_operator
real(8) pi, operator_value(:), real_value, imag_value
character(5) dummy1, dummy2, dummy3, dummy4
complex(8) complex_value, expectation_value, alpha_lhs, alpha_rhs, operator_val, sum
allocatable :: operator_value

print *, "Does this do what I think it does?"

nband_KS = 1244 
allocate(operator_value(nband_KS))

! Define pi
pi = 2.0*asin(1.0)

CALL getarg(1,fin_lhs)
CALL getarg(2,fin_rhs)
CALL getarg(3,fin_operator)

! Open necessary files
open(1,file=fin_lhs,status='old')
open(2,file=fin_rhs,status='old')
open(3,file=fin_operator,status='old')

! Get the number of steps
Nsteps = 0
100 read(1,*,END=200) 
Nsteps = Nsteps + 1
goto 100
200 continue
REWIND (1) 

!print *, '# This file has ', Nsteps, ' lines in it'

do i=1,2    ! skips the header in both iota and beta
  read(1,*)
  read(2,*)
end do

do i=1,nband_KS
   read(3,*) dummy1, dummy2, dummy3, operator_value(i), dummy4
end do

expectation_value = 0.0

do ii=1,nband_KS
    read(1,*) N, real_value, imag_value
    alpha_lhs = cmplx(real_value,imag_value)  
    read(2,*) N, real_value, imag_value
    alpha_rhs = cmplx(real_value,imag_value)
    expectation_value = expectation_value+  alpha_lhs*operator_value(ii)*CONJG(alpha_rhs)
end do    

print *, expectation_value

!
!  do i=1,nvoxel    ! there are 5 numbers per line
!      read(1,*,err=400) (real_value((i-1)*5 + ik),ik=1,5)
!      read(2,*,err=400) (imag_value((i-1)*5 + ik),ik=1,5)
!  end do

END
