#!/bin/bash

# Define the base directory path
input_dir="/glade/derecho/scratch/mrislam/work/pandac/data/himawari"
output_dir="/glade/derecho/scratch/mrislam/work/pandac/conversion/obs2ioda/himawari"

# Define the list of times
times=('0000' '0100' '0200' '0300' '0400' '0500' '0600' '0700' '0800' '0900' '1000' '1100'  
       '1200' '1300' '1400' '1500' '1600' '1700' '1800' '1900' '2000' '2100' '2200' '2300')

# Construct the list of yyyymmdd directories
dirs=("$input_dir"/2017/2017*)
num_dirs=${#dirs[@]}

# Extract the yyyymmdd part from each directory path and store them in an array
yyyymmdd_list=()
for dir in "${dirs[@]}"; do
    if [[ -d "$dir" ]]; then
        yyyymmdd=$(basename "$dir")
        yyyymmdd_list+=("$yyyymmdd")
    fi
done

# Print the yyyymmdd_list array
echo "List of yyyymmdd directories: ${yyyymmdd_list[@]}"

# Loop over the yyyymmdd_list and convert hsd data with obs2ioda
for yyyymmdd in "${yyyymmdd_list[@]}"; do
    # extract yyyy information from yyyymmdd
    yyyy=${yyyymmdd:0:4}
    # prepare output directory where we will save converted files
    new_dir="$output_dir/$yyyy/$yyyymmdd"
    mkdir -p "$new_dir"
    # navigate to the output data directory
    cd "$new_dir"
    echo "Created and navigated to directory: $new_dir"
    # create a symbolic link for obs2ioda executable
    ln -svf /glade/work/mrislam/pandac/software/obs2ioda/obs2ioda-v2/src/obs2ioda-v2.x ./
    # loop over hhmm and convert hsd data
    for hhmm in "${times[@]}"; do
        data_file="$input_dir/2017/$yyyymmdd/HS_H08_${yyyymmdd}_${hhmm}_B01_FLDK_R20_S0101.DAT"
        if [[ -f "$data_file" ]]; then
            ./obs2ioda-v2.x -i "$input_dir/2017/$yyyymmdd" -ahi -t ${yyyymmdd}${hhmm} -s 72
        else
            echo "Data file $data_file not found!"
        fi
    done
done

