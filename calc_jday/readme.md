## compile fortran code and generate executables for two methods of julian day number (JDN) calculation: 
gfortran -o calculate_julian_day_wrfda.x calc_jday_from_wrfda_subroutine.f90 
gfortran -o calculate_julian_day_mrislam.x calc_jday_from_mrislam_subroutine.f90

## calculate JDN from mrislam method
run the following executables and use 2015, 07, and 09 as input for year, month and day, respectively
./calculate_julian_day_mrislam.x

** calculated JDN value: 2457213 **

## calculate JDN from wrfda method
run the following executables and use 2015, 07, 09, 12, and 00 as input for year, month, day, hour and minute, respectively
./calculate_julian_day_wrfda.x

** calculated JDN value: 19733040 **

## US Navy website to check retrieved julian number for verification: https://aa.usno.navy.mil/data/JulianDate
by using 2015, 07, 09, 12, and 00 as input for year, month, day, hour and minute, respectively, I was able to get JDN value of 2457213. 

## values calculated from my method was the same as that reported by the US Navy website but the WRFDA gave very different value! 