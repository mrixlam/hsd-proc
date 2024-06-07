#!/bin/bash

# Define the base directory path
base_dir="/glade/derecho/scratch/mrislam/work/pandac/radiance_data_processing/obs_ioda/work"

# Define the ioda directory path
ioda_dir="$base_dir/output"

# Create the ioda directory if it doesn't exist
mkdir -p "$ioda_dir"

# Define the list of times
times=('0000' '0010' '0020' '0030' '0040' '0050' '0100' '0110' '0120' '0130' '0140' '0150' 
       '0200' '0210' '0220' '0230' '0240' '0250' '0300' '0310' '0320' '0330' '0340' '0350' 
       '0400' '0410' '0420' '0430' '0440' '0450' '0500' '0510' '0520' '0530' '0540' '0550' 
       '0600' '0610' '0620' '0630' '0640' '0650' '0700' '0710' '0720' '0730' '0740' '0750' 
       '0800' '0810' '0820' '0830' '0840' '0850' '0900' '0910' '0920' '0930' '0940' '0950' 
       '1000' '1010' '1020' '1030' '1040' '1050' '1100' '1110' '1120' '1130' '1140' '1150' 
       '1200' '1210' '1220' '1230' '1240' '1250' '1300' '1310' '1320' '1330' '1340' '1350' 
       '1400' '1410' '1420' '1430' '1440' '1450' '1500' '1510' '1520' '1530' '1540' '1550' 
       '1600' '1610' '1620' '1630' '1640' '1650' '1700' '1710' '1720' '1730' '1740' '1750' 
       '1800' '1810' '1820' '1830' '1840' '1850' '1900' '1910' '1920' '1930' '1940' '1950' 
       '2000' '2010' '2020' '2030' '2040' '2050' '2100' '2110' '2120' '2130' '2140' '2150' 
       '2200' '2210' '2220' '2230' '2240' '2250' '2300' '2310' '2320' '2330' '2340' '2350')

# Loop through each directory in the specified base directory
for dir in "$base_dir"/input/201*; do
    if [[ -d "$dir" ]]; then  # Check if it's a directory
        yyyymmdd=$(basename "$dir") # Extract the directory name
        echo "The extracted date (yyyymmdd) is: $yyyymmdd"
        
        # Create a new directory inside the ioda directory with the name of the extracted date
        new_dir="$ioda_dir/$yyyymmdd"
        mkdir -p "$new_dir"
        
        # Change to the new directory
        cd "$new_dir"
        
        # Create a symbolic link inside the new directory
        ln -svf /glade/derecho/scratch/mrislam/work/pandac/radiance_data_processing/obs2ioda/obs2ioda-v2/src/obs2ioda-v2.x ./

        # Loop through each time in the list
        for hhmm in "${times[@]}"; do
            # Define the data file path with the current time
            data_file="$base_dir/input/$yyyymmdd/HS_H08_${yyyymmdd}_${hhmm}_B01_FLDK_R20_S0101.DAT"
        
            # Check if the data file exists
            if [[ -f "$data_file" ]]; then
                # Run the obs2ioda-v2.x executable with the data file
                ./obs2ioda-v2.x -i "$base_dir/input/$yyyymmdd" -ahi -t ${yyyymmdd}${hhmm} -s 72
            else
                echo "Data file $data_file not found!"
            fi
        done
    fi
done

