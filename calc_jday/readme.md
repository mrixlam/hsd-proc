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

## comparison for JDN values for some other date/time: 

* --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* DATE/TIME  |  JDN for mrislam    |  JDN for US Navy website  |                                                        URL
* --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* 20240101   |        2460311      |       2460311             | https://aa.usno.navy.mil/calculated/juliandate?ID=AA&date=2024-01-01&era=AD&time=12%3A00%3A00.000&submit=Get+Date
* --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* 19700606   |        2440744      |       2440744             | https://aa.usno.navy.mil/calculated/juliandate?ID=AA&date=1970-06-06&era=AD&time=12%3A00%3A00.000&submit=Get+Date
* --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* 18500308   |        2396825      |       2396825             | https://aa.usno.navy.mil/calculated/juliandate?ID=AA&date=1850-03-08&era=AD&time=12%3A00%3A00.000&submit=Get+Date
* --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* 19910419   |        2448366      |       2448366             | https://aa.usno.navy.mil/calculated/juliandate?ID=AA&date=1991-04-19&era=AD&time=12%3A00%3A00.000&submit=Get+Date
* --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* 20150607   |        2457181      |       2457181             | https://aa.usno.navy.mil/calculated/juliandate?ID=AA&date=2015-06-07&era=AD&time=12%3A00%3A00.000&submit=Get+Date
* --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* 20190820   |        2458716      |       2458716             | https://aa.usno.navy.mil/calculated/juliandate?ID=AA&date=2019-08-20&era=AD&time=12%3A00%3A00.000&submit=Get+Date
* --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* 20200220   |        2458900      |       2458900             | https://aa.usno.navy.mil/calculated/juliandate?ID=AA&date=2020-02-20&era=AD&time=12%3A00%3A00.000&submit=Get+Date
* --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* 20231007   |        2460225      |       2460225             | https://aa.usno.navy.mil/calculated/juliandate?ID=AA&date=2023-10-07&era=AD&time=12%3A00%3A00.000&submit=Get+Date
* --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
