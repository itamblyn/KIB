!       program projector.f90

implicit none

integer i, ii, j, ik, ix, iy, iz, nx, ny, nz
integer Nsteps, nvoxel, counter, nband_KS, nband_ISO
real(8) real_value(:), imag_value(:)
character(1) filecounter1
character(2) filecounter2
character(3) filecounter3
character(4) filecounter4
complex(8) complex_value, norm, alpha
character(128) iso_real, iso_imag, std_dir
complex(8) ISO_wfn(:), KS_wfn(:,:), sum
allocatable :: ISO_wfn, KS_wfn, real_value, imag_value

write(6,*) 'How many ISO wavefunctions? '
read(5,*)   nband_ISO

nx = 208
ny =  52
nz = 52
nvoxel = nx*ny*nz
nband_KS = 120 ! should be big number

open(3,file='all.dat')

allocate( KS_wfn(nx*ny*nz,nband_KS) )
print *, 'KS_wfn array was sucessfully allocated'
allocate( real_value(nx*ny*nz) )
allocate( imag_value(nx*ny*nz) )

do ii=1,nband_KS
       if      (ii < 10)   then
         write(unit=filecounter1, fmt='(I1)') ii
         open(1,file="../KS/WR.01.001.00" // filecounter1 // ".dx",status='old')
         open(2,file="../KS/WI.01.001.00" // filecounter1 // ".dx",status='old')
       else if (ii < 100)  then
         write(unit=filecounter2, fmt='(I2)') ii
         open(1,file="../KS/WR.01.001.0" // filecounter2 // ".dx",status='old')
         open(2,file="../KS/WI.01.001.0" // filecounter2 // ".dx",status='old')
       else
         write(unit=filecounter3, fmt='(I3)') ii
         open(1,file="../KS/WR.01.001." // filecounter3 // ".dx",status='old')
         open(2,file="../KS/WI.01.001." // filecounter3 // ".dx",status='old')
       end if

  do i=1,3
    read(1,*) ! skips the header
    read(2,*)
  end do

  do i=1,nvoxel    ! there are 5 numbers per line
      read(1,*,err=400) (real_value((i-1)*5 + ik),ik=1,5)
      read(2,*,err=400) (imag_value((i-1)*5 + ik),ik=1,5)
  end do

  400 continue

  do i=1,nvoxel
   KS_wfn(i,ii) = cmplx(real_value(i),imag_value(i))
  end do
  print *, 'Read state ', ii

end do

deallocate(real_value)
deallocate(imag_value)

print *, 'Kappa states have been read into RAM, proceeding to iota/beta '

do ii=1,nband_ISO
! Allocate array and read from file
    allocate( ISO_wfn(nx*ny*nz) )
    allocate( real_value(nx*ny*nz) )
    allocate( imag_value(nx*ny*nz) )

       if      (ii < 10)   then
         write(unit=filecounter1, fmt='(I1)') ii
         open(1,file="WR.01.001.00" // filecounter1 // ".dx",status='old')
         open(2,file="WI.01.001.00" // filecounter1 // ".dx",status='old')
       else if (ii < 100)  then
         write(unit=filecounter2, fmt='(I2)') ii
         open(1,file="WR.01.001.0" // filecounter2 // ".dx",status='old')
         open(2,file="WI.01.001.0" // filecounter2 // ".dx",status='old')
       else
         write(unit=filecounter3, fmt='(I3)') ii
         open(1,file="WR.01.001." // filecounter3 // ".dx",status='old')
         open(2,file="WI.01.001." // filecounter3 // ".dx",status='old')
       end if

    do i=1,3

      read(1,*)
      read(2,*)

    end do

    do i=1,nvoxel    ! there are 5 numbers per line
      read(1,*,err=300) (real_value((i-1)*5 + ik),ik=1,5)
      read(2,*,err=300) (imag_value((i-1)*5 + ik),ik=1,5)
    end do

    300 continue

    norm = 0.0

    do i=1,nvoxel
       ISO_wfn(i) = cmplx(real_value(i),imag_value(i))
       norm = norm + ISO_wfn(i)*CONJG(ISO_wfn(i))
    end do

    write(3,*) '# The norm of the isolated state is', real(norm)
    write(3,*) '# I think there should be', nx*ny*nz, 'i.e. ', real(norm)*100./(nx*ny*nz), '%'

    close(1)
    close(2)

    deallocate(real_value)
    deallocate(imag_value)

! the gas phase wfn is now ready

    do j=1,nband_KS

      sum = 0.

      do i=1,nvoxel
        sum = CONJG(ISO_wfn(i))*KS_wfn(i,j) + sum 
      end do

      alpha = sum/(nx*ny*nz)
      write(3,*) j, real(alpha), aimag(alpha)
    end do
    
    deallocate(ISO_wfn)
    print *, 'ISO_wfn ', ii, ' complete' 

end do

close(3)
deallocate(KS_wfn)

END
