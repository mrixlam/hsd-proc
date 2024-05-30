! this is a simple fortran program that use subroutine da_get_julian_time from WRFDA to calculate julian day number

! to execute: 
! gfortran -o calculate_julian_day_mrislam.x calc_jday_from_mrislam_subroutine.f90

! then use calculate_julian_day_mrislam.x executable to calculate julian day
! calculate_julian_day_mrislam.x [you will be asked to enter year, month, date, hour and minute information]

! using calculate_julian_day_mrislam.x, i was able to get 2457213.000000 as the julian day number for the following input parameter: 
! year = 2015
! month = 07
! day = 09

! here is a US Navy website to check retrieved julian number for verification: https://aa.usno.navy.mil/data/JulianDate
! at this website I found the julian day number (for the input parameters mentioned above) as: 2457213.000000

! these were an exact match!

program calculate_julian_day
    implicit none

    integer :: year, month, day, julian_day

    ! Prompt user for date input
    print *, "Enter year (e.g., 2024):"
    read(*,*) year
    print *, "Enter month (1-12):"
    read(*,*) month
    print *, "Enter day (1-31):"
    read(*,*) day

    ! Call the function to calculate Julian Day Number
    julian_day = compute_julian_day(year, month, day)

    ! Print the Julian Day Number
    print *, "Julian Day Number:", julian_day

contains

    integer function compute_julian_day(year, month, day)
        implicit none
        integer, intent(in) :: year, month, day
        integer :: a, y, m

        a = (14 - month) / 12
        y = year + 4800 - a
        m = month + 12 * a - 3

        compute_julian_day = day + ((153 * m + 2) / 5) + 365 * y + (y / 4) - (y / 100) + (y / 400) - 32045
    end function compute_julian_day

end program calculate_julian_day
