# -----------------------------------------------------------------------------------------

# This is the main module that process hsd data with obs2ioda in parallel 
# Please make sure that main.sh and process_hsd_data.sh are available in the same directory
# To execute, use ./main.sh that will use process_hsd_data.sh. 

# Author: Rubaiat Islam
# Last updated: 2024-06-23

# -----------------------------------------------------------------------------------------

#!/bin/bash

# Define the base directory path
input_dir="/glade/derecho/scratch/mrislam/work/pandac/data/himawari"

# Construct the list of yyyymmdd directories
dirs=($(ls -d "$input_dir"/2017/2017*))

# Extract the yyyymmdd part from each directory path and store them in an array
yyyymmdd_list=()
for dir in "${dirs[@]}"; do
    if [[ -d "$dir" ]]; then
        yyyymmdd=$(basename "$dir")
        yyyymmdd_list+=("$yyyymmdd")
    fi
done

# Print the yyyymmdd_list array
# echo "List of yyyymmdd directories: ${yyyymmdd_list[@]}"

# Export the necessary variables and functions for the subprocesses
export input_dir

# Limit the number of parallel jobs. I was able to make this process work for 64 processors.
# For higher numbers, e.g., 128, inadequate memory leads to job termination
max_jobs=64
current_jobs=64

# Process each directory
for yyyymmdd in "${yyyymmdd_list[@]}"; do
    ./process_hsd_old.sh "$yyyymmdd" &
    ((current_jobs++))

    # Wait for some jobs to finish if we reach the max_jobs limit
    if [[ $current_jobs -ge $max_jobs ]]; then
        wait -n
        ((current_jobs--))
    fi
done

# Wait for all remaining background jobs to finish
wait

# Alternative 1: Use xargs to parallelize the processing of directories
# printf "%s\n" "${yyyymmdd_list[@]}" | xargs -n 1 -P 1 ./process_hsd_old.sh

# Alternative 2: Use parallel to process directories in parallel
# printf "%s\n" "${yyyymmdd_list[@]}" | parallel -j 64 ./process_hsd_old.sh {}


