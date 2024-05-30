! this is a simple fortran program that use subroutine da_get_julian_time from WRFDA to calculate julian day number

! to execute: 
! gfortran -o calculate_julian_day_wrfda.x calc_jday_from_wrfda_subroutine.f90

! then use calculate_julian_day_wrfda.x executable to calculate julian day
! calculate_julian_day_wrfda.x [you will be asked to enter year, month, date, hour and minute information]

! using calculate_julian_day_wrfda.x, i was able to get 19733040.000000000 as the julian day number for the following input parameter: 
! year = 2015
! month = 07
! day = 09
! hour = 12
! minute = 00

! here is a US Navy website to check retrieved julian number for verification: https://aa.usno.navy.mil/data/JulianDate
! at this website I found the julian day number (for the input parameters mentioned above) as: 2457213.000000

! something seems broken for this method of calculating julian day as the values seem very different from the US Navy website. 

program calculate_julian_day
    implicit none

    integer :: year, month, day, hour, minute
    real*8 :: gstime

    ! Prompt user for date and time input
    print *, "Enter year (e.g., 2024):"
    read(*,*) year
    print *, "Enter month (1-12):"
    read(*,*) month
    print *, "Enter day (1-31):"
    read(*,*) day
    print *, "Enter hour (0-23):"
    read(*,*) hour
    print *, "Enter minute (0-59):"
    read(*,*) minute

    ! Call the subroutine to calculate Julian Day Number
    call da_get_julian_time(year, month, day, hour, minute, gstime)

    ! Print the Julian Day Number
    print *, "Julian Day Number:", gstime

contains

    subroutine da_get_julian_time(year, month, day, hour, minute, gstime)
        !------------------------------------------------------------------------------
        ! Purpose: Calculate Julian time from year/month/day/hour/minute.
        !------------------------------------------------------------------------------
        implicit none

        integer, intent(in)  :: year
        integer, intent(in)  :: month
        integer, intent(in)  :: day
        integer, intent(in)  :: hour
        integer, intent(in)  :: minute
        real*8,  intent(out) :: gstime

        integer :: iw3jdn, ndays, nmind

        iw3jdn = day - 32075 + 1461 * (year + 4800 + (month - 14) / 12) / 4 &
            + 367 * (month - 2 - (month - 14) / 12 * 12) / 12 &
            - 3 * ((year + 4900 + (month - 14) / 12) / 100) / 4
        ndays = iw3jdn - 2443510

        nmind = ndays * 1440 + hour * 60 + minute
        gstime = float(nmind)
    end subroutine da_get_julian_time

end program calculate_julian_day
