!       program projector.f90

implicit none

integer i,ii, j, ik, ix, iy, iz, nx, ny, nz, Nsteps, nvoxel, counter, nband_KS
real(8) pi, real_value(:), imag_value(:)
character(1) filecounter1
character(2) filecounter2
character(3) filecounter3
character(4) filecounter4
complex(8) complex_value, norm, alpha
character(128) fin, fin_real, fin_imag, iso_real, iso_imag, std_dir
complex(8) ISO_wfn(:),KS_wfn(:), sum
allocatable :: ISO_wfn, KS_wfn, real_value, imag_value

nx = 288   ! these need to be set to dim of wfn file
ny = 100
nz = 120
nvoxel = nx*ny*nz

nband_KS = 2 ! this is system specific 
! Define pi
pi = 2.0*asin(1.0)

CALL getarg(1,iso_real)
CALL getarg(2,iso_imag)

! Open necessary files
open(1,file=iso_real,status='old')
open(2,file=iso_imag,status='old')

! Get the number of steps
Nsteps = 0
100 read(1,*,END=200) 
Nsteps = Nsteps + 1
goto 100
200 continue
REWIND (1) 

!print *, '# This file has ', Nsteps, ' lines in it'

do i=1,3

  read(1,*)
  read(2,*)

end do

! Allocate array and read from file
allocate( ISO_wfn(nx*ny*nz) )
allocate( real_value(nx*ny*nz) )
allocate( imag_value(nx*ny*nz) )

do i=1,nvoxel/5    ! there are 5 numbers per line
      read(1,*,err=300) (real_value((i-1)*5 + ik),ik=1,5)
      read(2,*,err=300) (imag_value((i-1)*5 + ik),ik=1,5)
end do

300 continue

norm = 0.0

do i=1,nvoxel
   ISO_wfn(i) = cmplx(real_value(i),imag_value(i))
   norm = norm + ISO_wfn(i)*CONJG(ISO_wfn(i))
end do

print *, '# The norm of the isolated state is', real(norm)
print *, '# I think it should be', nx*ny*nz, 'i.e. ', real(norm)*100./(nx*ny*nz), '%'

close(1)
close(2)

deallocate(real_value)
deallocate(imag_value)

! the gas phase wfn is now ready

do ii=1,nband_KS
    allocate( KS_wfn(nx*ny*nz) )
    allocate( real_value(nx*ny*nz) )
    allocate( imag_value(nx*ny*nz) )

       if      (ii < 10)   then
         write(unit=filecounter1, fmt='(I1)') ii 
         open(1,file="../kappa/WR.01.001.0000" // filecounter1 // ".dx",status='old')
         open(2,file="../kappa/WI.01.001.0000" // filecounter1 // ".dx",status='old')
       else if (ii < 100)  then
         write(unit=filecounter2, fmt='(I2)') ii
         open(1,file="../kappa/WR.01.001.000" // filecounter2 // ".dx",status='old')
         open(2,file="../kappa/WI.01.001.000" // filecounter2 // ".dx",status='old')
       else if (ii < 1000) then
         write(unit=filecounter3, fmt='(I3)') ii
         open(1,file="../kappa/WR.01.001.00" // filecounter3 // ".dx",status='old')
         open(2,file="../kappa/WI.01.001.00" // filecounter3 // ".dx",status='old')
       else
         write(unit=filecounter4, fmt='(I4)') ii
         open(1,file="../kappa/WR.01.001.0" // filecounter4 // ".dx",status='old')
         open(2,file="../kappa/WI.01.001.0" // filecounter4 // ".dx",status='old')
       end if

  do i=1,3

    read(1,*) ! skips the header
    read(2,*)

  end do

  do i=1,nvoxel/5   ! there are 5 numbers per line
      read(1,*,err=400) (real_value((i-1)*5 + ik),ik=1,5)
      read(2,*,err=400) (imag_value((i-1)*5 + ik),ik=1,5)
  end do

  400 continue

  norm = 0.0

  do i=1,nvoxel
   KS_wfn(i) = cmplx(real_value(i),imag_value(i))
   norm = norm + KS_wfn(i)*CONJG(KS_wfn(i))
  end do

  sum = 0.

  do i=1,nvoxel
    sum = CONJG(ISO_wfn(i))*KS_wfn(i) + sum 
  end do


  alpha = sum/(nx*ny*nz)
  print *, ii, real(alpha), aimag(alpha)

  deallocate(KS_wfn)
  deallocate(real_value)
  deallocate(imag_value)

end do



deallocate(ISO_wfn)

END
