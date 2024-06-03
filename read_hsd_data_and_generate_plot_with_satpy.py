# This script uses satpy to read HSD formar Himawari data and then produce a 4x3 plot panel based on user specification 

# It was generated based on the documenation available here: https://satpy.readthedocs.io/en/stable/examples/index.html and https://nbviewer.org/github/pytroll/pytroll-examples/blob/main/satpy/ahi_true_color_pyspectral.ipynb
# Last Updated: June 3, 2024

# to call this function, either in Jupyter Notebook or as standalone python script, please use: 
# read_hsd_data_and_generate_plot_with_satpy(base_dir="specify_your_data_directory", start_time_str="2018-01-01 00:00", hours=12, rgb_names=['true_color'])

# other options for rgb_names: [source: https://github.com/pytroll/satpy/blob/main/satpy/etc/composites/ahi.yaml]
#   - 'true_color', 
#   - 'airmass', 
#   - 'ash', 
#   - 'dust', 
#   - 'fog', 
#   - 'night_microphysics',
#   - 'fire_temperature', 
#   - 'natural_color', 
#   - 'cloud_phase_distinction',
#   - 'colorized_ir_clouds', 
#   - 'water_vapors1', 
#   - 'mid_vapor', 
#   - 'water_vapors2',
#   - 'convection', 
#   - 'cloudtop'

#!/usr/bin/env python3

# load necessary modules and libraries
from satpy import Scene, find_files_and_readers
from datetime import datetime, timedelta
import matplotlib.pyplot as plt
import os
import shutil

def read_hsd_data_and_generate_plot_with_satpy(base_dir, start_time_str, hours, rgb_names, output_plot='4x3_panel_plot.png'):

    # Specify the start time
    start_time = datetime.strptime(start_time_str, '%Y-%m-%d %H:%M')
    
    # Specify the location to save the temporary images
    output_dir = 'temp_images'
    os.makedirs(output_dir, exist_ok=True)

    # Define the list of timestamps for the given hourly data points
    timestamps = [start_time + timedelta(hours=i) for i in range(hours)]

    # Loop through each timestamp and generate images
    for timestamp in timestamps:
        files = find_files_and_readers(start_time=timestamp,
                                       end_time=timestamp,
                                       base_dir=base_dir,
                                       reader='ahi_hsd')

        scene = Scene(files, reader='ahi_hsd', reader_kwargs={'calib_mode': 'update', 'mask_space': False})

        # Loop through the rgb_names
        for rgbname in rgb_names:
            scene.load([rgbname])

            # Save image
            filename = os.path.join(output_dir, f'himawari_ahi_{rgbname}_{timestamp.strftime("%Y%m%d%H%M")}.png')
            scene.save_dataset(rgbname, filename=filename)

    # Create a figure and axis for a 4x3 panel plot
    fig, axes = plt.subplots(4, 3, figsize=(15, 15))

    # Loop through the axes and timestamps to load and plot the images
    for ax, (timestamp, rgbname) in zip(axes.flatten(), [(ts, rn) for ts in timestamps for rn in rgb_names]):
        filename = os.path.join(output_dir, f'himawari_ahi_{rgbname}_{timestamp.strftime("%Y%m%d%H%M")}.png')
        img = plt.imread(filename)
        ax.imshow(img)
        ax.set_title(f'{rgbname.capitalize()} - {timestamp.strftime("%Y-%m-%d %H:%M")}')
        ax.axis('off')  # Hide the axis

    # Adjust layout
    plt.tight_layout()

    # Save the panel plot to the specified output file
    plt.savefig(output_plot)

    # Show the plot
    plt.show()

    # Clean up temporary images
    shutil.rmtree(output_dir)
