! ultimate goal: parse hsd format radiance data and then compute brightness temperature and incorporate that to mpas model data

! progress so far: 
!   - created a fortran program that can parse list of hsd data files specified in a text file and extract information on satellite id, band id and datetime of the observation
!   - this program is tested with a small (10 filenames) and large (5000 filenames) text input file and works as expected
!   - this can be tested with any number of hsd filenames (at least theoretically)

! to execute this fortran program: 
! gfortran -o process_himawari_l1b_data.x process_himawari_data.F90
! ./process_himawari_l1b_data.x
! 
! this will generate a text file in the present directory named output.txt where we will have the list of parsed filenames and extracted information

program preprocess_himawari_data

    implicit none

    ! declare variables
    integer, parameter :: max_files = 1000
    character(len=256) :: line
    character(len=38) :: filename
    character(len=12) :: datetime
    character(len=4)  :: coverage
    character(len=3)  :: sat_id, band_id, resolution
    integer :: outfile, num_files, indx, julian_day, unit, ios
    character(len=256), allocatable :: filenames(:)

    ! create a text file where logs will be written
    open(unit=outfile, file='output.txt', status='replace', action='write')

    write(outfile, *) ' ' // NEW_LINE('A') 
    write(outfile, *) ' ============ started parsing the list of files specified in the text file  ============ ' // NEW_LINE('A') 
    write(outfile, *) ' ' // NEW_LINE('A') 

    ! open the text file containing list of HSD data filenames
    unit = 1
    open(unit=unit, file='flist.txt', status='old', action='read', iostat=ios)
    if (ios /= 0) then
        print *, 'Error opening file: flist.txt'
        stop
    end if

    write(outfile, *) 'This is the list of Himawari HSD data files specified in the text file: ' // NEW_LINE('A') 
    write(outfile, *) ' ' // NEW_LINE('A') 

    ! count the number of lines (files) in the input text file
    num_files = 0
    do
        read(unit, '(A)', iostat=ios) line
        if (ios /= 0) exit
        num_files = num_files + 1
    end do

    ! allocate the num_files array to hold filenames
    allocate(filenames(num_files))

    ! print file names (one per line) from num_files array
    rewind(unit)
    do indx = 1, num_files
        read(unit, '(A)', iostat=ios) filenames(indx)
        write(outfile, *) trim(filenames(indx))   // NEW_LINE('A')
        if (ios /= 0) exit
    end do

    write(outfile, *) ' ' // NEW_LINE('A') 
    write(outfile, *) ' ============ finished parsing the list of files specified in the text file  ============ ' // NEW_LINE('A') 
    write(outfile, *) ' ' // NEW_LINE('A') 

    ! close the file as we are done counting the number of files
    close(unit)

    write(outfile, *) ' ' // NEW_LINE('A') 
    write(outfile, *) ' ================ started extracting information from file names  ================ ' // NEW_LINE('A') 
    write(outfile, *) ' ' // NEW_LINE('A') 

    ! open the text file containing list of HSD data filenames
    unit = 1
    open(unit=unit, file='long_flist.txt', status='old', action='read', iostat=ios)
    if (ios /= 0) then
        print *, 'Error opening file: file_list.txt'
        stop
    end if

    ! extract information on datetime, satellite id and band id for each of the filenames identified previously
    do
        read(unit, '(A)', iostat=ios) line
        if (ios /= 0) exit
        call parse_himawari_filename(trim(line), sat_id, datetime, band_id, coverage, resolution, julian_day)
        write(outfile, *) 'Retrieved information for filename: ', trim(line)  // NEW_LINE('A')
        write(outfile, *) ' Satellite ID: ', sat_id // NEW_LINE('A')
        write(outfile, *) ' Band ID: ', band_id // NEW_LINE('A') 
        write(outfile, *) ' Datetime: ', datetime // NEW_LINE('A') // NEW_LINE('A')
    end do

    write(outfile, *) ' ' // NEW_LINE('A') 
    write(outfile, *) ' ============== completed extracting information from file names  ============== ' // NEW_LINE('A') 
    write(outfile, *) ' ' // NEW_LINE('A') 

    ! close the file as we are done extracting information from filenames
    close(unit)

    ! close the log file
    close(outfile)

    print *, 'Output has been saved to output.txt'

contains

    subroutine parse_himawari_filename(filename, sat_id, datetime, band_id, coverage, resolution, julian_day)
        implicit none
        character(len=*), intent(in) :: filename
        character(len=3), intent(out) :: sat_id
        character(len=12), intent(out) :: datetime
        character(len=3), intent(out) :: band_id
        character(len=4), intent(out) :: coverage
        character(len=3), intent(out) :: resolution
        integer, intent(out) :: julian_day

        character(len=8) :: date
        character(len=4) :: hhmm
        integer :: year, month, day

        sat_id = filename(5:6)
        date = filename(8:15)
        hhmm = filename(17:20)
        datetime = date // hhmm  
        band_id = filename(23:24)
        coverage = filename(26:29)
        resolution = filename(32:33)

        read(date(1:4), '(I4)') year
        read(date(5:6), '(I2)') month
        read(date(7:8), '(I2)') day

        julian_day = compute_julian_day(year, month, day)

    end subroutine parse_himawari_filename

    integer function compute_julian_day(year, month, day)
        implicit none
        integer, intent(in) :: year, month, day
        integer :: a, y, m

        a = (14 - month) / 12
        y = year + 4800 - a
        m = month + 12*a - 3

        compute_julian_day = day + ((153*m + 2) / 5) + 365*y + (y / 4) - (y / 100) + (y / 400) - 32045

    end function compute_julian_day

end program preprocess_himawari_data
