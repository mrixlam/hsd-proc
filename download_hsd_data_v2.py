# Rubaiat Islam modifies this script based on the previous script developed by Ivette Hernandez Banos.
# The original version of the script is available here: https://github.com/mrixlam/hsd-proc/blob/main/download_hsd_data_v1.py

# -------------------------------------------------------------------------------------------------------------------
# Major Changes:
# - This version of the Python script can download HSD format data based on user specification
#     * Users now can select time, resolution, spatial coverage, band ID, etc., and only download selected data
#     * This script can detect the currently installed module of AWS and use that for data download
#     * Also added the functionality of calculating and printing total runtime at the end of the script executions
#     * Previously, Ivette added the capability of specifying the date range for HSD data download
# -------------------------------------------------------------------------------------------------------------------

# Runtime on derecho for v2 script [/glade/derecho/scratch/mrislam/work/pandac/radiance_data_processing/download_data]
#   - Download one day data for 20180105: 1359.11 seconds [~23 minutes] {total size: 36GB}
#   - Download one day data for 20180104: 1359.20 seconds [~23 minutes] {total size: 36GB}
#   - Download one day data for 20180103: 1349.53 seconds [~23 minutes] {total size: 36GB}
#   - Download one day data for 20180102: 1355.70 seconds [~23 minutes] {total size: 36GB}
#   - Download one day data for 20180101: 1358.59 seconds [~23 minutes] {total size: 37GB}

# Runtime on derecho for v1 script [/glade/derecho/scratch/mrislam/work/pandac/radiance_data_processing/download_data/v1]
#   - Download one day data for 20180105: 397.76 seconds [~6 minutes] {total size: 97GB} (2.7x larger download size than v2)
#   - Download one day data for 20180104: 419.04 seconds [~7 minutes] {total size: 97GB} (2.7x larger download size than v2)
#   - Download one day data for 20180103: 428.14 seconds [~7 minutes] {total size: 97GB} (2.7x larger download size than v2)
#   - Download one day data for 20180102: 434.55 seconds [~7 minutes] {total size: 97GB} (2.7x larger download size than v2)
#   - Download one day data for 20180101: 425.34 seconds [~7 minutes] {total size: 97GB} (2.7x larger download size than v2)

#!/usr/bin/env python3

from datetime import datetime, timedelta
import os
import subprocess
import time
import sys


def main():

    # Determine whether AWS CLI is installed in the system. If installed, print the location of the installation and use it. If not, throw an error message and stop executing the script.
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

    # Specify the directory where HSD data will be downloaded
    main_path = "/glade/derecho/scratch/mrislam/work/pandac/radiance_data_processing/download_data"

    # Specify the start and end date for the data retrieval period
    dateIni = "20180105"
    dateFin = "20180105"

    # We will use time delta to specify date increment
    delta = "1"

    # Create start and end date in datetime format
    datei = datetime.strptime(str(dateIni), "%Y%m%d")
    datef = datetime.strptime(str(dateFin), "%Y%m%d")

    # Specify the available time options (in HHMM) when the Himawari satellite has observation
    times = [
        "0000",
        "0010",
        "0020",
        "0030",
        "0040",
        "0050",
        "0100",
        "0110",
        "0120",
        "0130",
        "0140",
        "0150",
        "0200",
        "0210",
        "0220",
        "0230",
        "0240",
        "0250",
        "0300",
        "0310",
        "0320",
        "0330",
        "0340",
        "0350",
        "0400",
        "0410",
        "0420",
        "0430",
        "0440",
        "0450",
        "0500",
        "0510",
        "0520",
        "0530",
        "0540",
        "0550",
        "0600",
        "0610",
        "0620",
        "0630",
        "0640",
        "0650",
        "0700",
        "0710",
        "0720",
        "0730",
        "0740",
        "0750",
        "0800",
        "0810",
        "0820",
        "0830",
        "0840",
        "0850",
        "0900",
        "0910",
        "0920",
        "0930",
        "0940",
        "0950",
        "1000",
        "1010",
        "1020",
        "1030",
        "1040",
        "1050",
        "1100",
        "1110",
        "1120",
        "1130",
        "1140",
        "1150",
        "1200",
        "1210",
        "1220",
        "1230",
        "1240",
        "1250",
        "1300",
        "1310",
        "1320",
        "1330",
        "1340",
        "1350",
        "1400",
        "1410",
        "1420",
        "1430",
        "1440",
        "1450",
        "1500",
        "1510",
        "1520",
        "1530",
        "1540",
        "1550",
        "1600",
        "1610",
        "1620",
        "1630",
        "1640",
        "1650",
        "1700",
        "1710",
        "1720",
        "1730",
        "1740",
        "1750",
        "1800",
        "1810",
        "1820",
        "1830",
        "1840",
        "1850",
        "1900",
        "1910",
        "1920",
        "1930",
        "1940",
        "1950",
        "2000",
        "2010",
        "2020",
        "2030",
        "2040",
        "2050",
        "2100",
        "2110",
        "2120",
        "2130",
        "2140",
        "2150",
        "2200",
        "2210",
        "2220",
        "2230",
        "2240",
        "2250",
        "2300",
        "2310",
        "2320",
        "2330",
        "2340",
        "2350",
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
            datestr = date.strftime("%Y%m%d")  # Create datetime string
            yyyy = date.strftime("%Y")  # Extract year from datetime string
            mm = date.strftime("%m")  # Extract month from datetime string
            dd = date.strftime("%d")  # Extract day from datetime string

            # Create data directories where downloaded data will be saved
            obs_dir = os.path.join(main_path, datestr)
            if not os.path.exists(obs_dir):
                os.makedirs(obs_dir)

            # Create a list of available data files to be downloaded
            data_src = f"s3://noaa-himawari8/AHI-L1b-FLDK/{yyyy}/{mm}/{dd}/{timeX}/"
            print("")
            print(
                f" ============= Downloading L1b radiance data for Himawari8 from: {data_src} ============= "
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
                "*_FLDK_R20*S0101.DAT.bz2",
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
