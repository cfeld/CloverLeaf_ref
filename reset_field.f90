!Crown Copyright 2012 AWE.
!
! This file is part of CloverLeaf.
!
! CloverLeaf is free software: you can redistribute it and/or modify it under 
! the terms of the GNU General Public License as published by the 
! Free Software Foundation, either version 3 of the License, or (at your option) 
! any later version.
!
! CloverLeaf is distributed in the hope that it will be useful, but 
! WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or 
! FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more 
! details.
!
! You should have received a copy of the GNU General Public License along with 
! CloverLeaf. If not, see http://www.gnu.org/licenses/.

!>  @brief Reset field driver
!>  @author Wayne Gaudin
!>  @details Invokes the user specified field reset kernel.

MODULE reset_field_module

CONTAINS

SUBROUTINE reset_field()

  USE clover_module
  USE reset_field_kernel_module

  IMPLICIT NONE

  INTEGER :: t

  REAL(KIND=8) :: kernel_time,timer

  IF(profiler_on) kernel_time=timer()

  IF(use_fortran_kernels)THEN
!$OMP PARALLEL
!$OMP DO
    DO t=1,tiles_per_task
      CALL reset_field_kernel(chunk%tiles(t)%field%x_min,   &
                            chunk%tiles(t)%field%x_max,     &
                            chunk%tiles(t)%field%y_min,     &
                            chunk%tiles(t)%field%y_max,     &
                            chunk%tiles(t)%field%density0,  &
                            chunk%tiles(t)%field%density1,  &
                            chunk%tiles(t)%field%energy0,   &
                            chunk%tiles(t)%field%energy1,   &
                            chunk%tiles(t)%field%xvel0,     &
                            chunk%tiles(t)%field%xvel1,     &
                            chunk%tiles(t)%field%yvel0,     &
                            chunk%tiles(t)%field%yvel1      )
    ENDDO
!$OMP END DO NOWAIT
!$OMP END PARALLEL
  ENDIF

  IF(profiler_on) profiler%reset=profiler%reset+(timer()-kernel_time)

END SUBROUTINE reset_field

END MODULE reset_field_module
