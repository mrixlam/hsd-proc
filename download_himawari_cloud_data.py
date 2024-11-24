####################################################################################################################
#
#    Script Name: download_himawari_cloud_data.py
#
#    Functionality: Downloads Himawari H09 cloud data from NOAA's AWS repository based on the user defined criteria for 
#    start date, end date, temporal frequency and saves them to a user specified location.
#
#    Author: Rubaiat Islam (mrislam@ucar.edu)
#    Last Modified: November 23, 2024
#
####################################################################################################################

#!/usr/bin/env python3

from datetime import datetime, timedelta
import os
import subprocess
import time
import sys

def main():

    # Determine whether AWS CLI is installed in the system. If installed, print the location of the installation and use it. If not, 
    # throw an error message and stop executing the script.

    result = subprocess.run(["which", "aws"], capture_output=True, text=True)
    if result.returncode != 0:
        print("")
        print(
            "============= Error! AWS was not found in the system. Please install or module load AWS to proceed ============="
        )
        print("")
        sys.exit(1)
    else:
        aws_location = result.stdout.strip()
        print("")
        print(
            f"========================== AWS is installed! Using installation from {aws_location} =========================="
        )
        print("")

    # Specify the directory where Himawari cloud data will be downloaded
    main_path = "/glade/derecho/scratch/mrislam/work/pandac/data/AHI-L2-FLDK-Clouds"

    # Specify the start and end date for the data retrieval period
    dateIni = "20240601"        # Start date formatted as ccyymmdd
    dateFin = "20240630"        # End date formatted as ccyymmdd

    # We will use time delta to specify date increment
    delta = "1"

    # Create start and end date in datetime format
    datei = datetime.strptime(str(dateIni), "%Y%m%d")
    datef = datetime.strptime(str(dateFin), "%Y%m%d")

    # This script downloads data once every hour but if there is a need to download data for a different frequency, 
    # variable {times} should be modified accordingly

    # Specify the available time options (in HHMM) when the Himawari satellite has observation 
    times = [
        "0000",
        "0100",
        "0200",
        "0300",
        "0400",
        "0500",
        "0600",
        "0700",
        "0800",
        "0900",
        "1000",
        "1100",
        "1200",
        "1300",
        "1400",
        "1500",
        "1600",
        "1700",
        "1800",
        "1900",
        "2000",
        "2100",
        "2200",
        "2300",
    ]

    # Take note of the starting time for the Python script execution. This will later be used to compute runtime
    start_time = time.time()

    # Construct a for loop to generate the list of data files and then download them
    for timeX in times:
        print("")
        print(
            f" ======================================= Preparing list of downloadable files for {timeX}Z ======================================= "
        )
        print("")
        date = datei
        while date <= datef:
            datestr = date.strftime("%Y%m%d")   # Create datetime string
            yyyy = date.strftime("%Y")          # Extract year from datetime string
            mm = date.strftime("%m")            # Extract month from datetime string
            dd = date.strftime("%d")            # Extract day from datetime string
            hh = date.strftime("%H")            # Extract day from datetime string

            # If we need the output directory names to be formatted as 'ccyymmddhh', use dirname = date.strftime("%Y%m%d%H")  
            # If we need the output directory names to be formatted as 'ccyymmdd', use dirname = date.strftime("%Y%m%d")  

            # Create data directories where downloaded data will be saved
            dirname = date.strftime("%Y%m%d%H") 
            print(f"Directory Name: {dirname}")
            obs_dir = os.path.join(main_path, dirname)
            if not os.path.exists(obs_dir):
                os.makedirs(obs_dir)

            # Create a list of available data files to be downloaded
            data_src = f"s3://noaa-himawari9/AHI-L2-FLDK-Clouds/{yyyy}/{mm}/{dd}/{timeX}/"
            print("")
            print(
                f" ============= Downloading L2 cloud data for Himawari9 from: {data_src} ============= "
            )
            print("")

            # Download the data files using AWS CLI
            cmd = [
                "aws",
                "s3",
                "cp",
                "--no-sign-request",
                "--recursive",
                "--exclude",
                "*",
                "--include",
                "AHI-*_v1r1_h09_s*.nc",
                data_src,
                obs_dir,
            ]
            subprocess.run(cmd)

            date += timedelta(days=int(delta))

    end_time = time.time()  # Record the end time
    total_runtime = end_time - start_time  # Calculate the total runtime

    # Print total runtime after the successful execution of the script
    print(f"Total runtime: {total_runtime:.2f} seconds")

if __name__ == "__main__":
    main()
