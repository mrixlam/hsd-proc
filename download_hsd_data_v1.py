#!/usr/bin/env python3

from datetime import datetime, timedelta
import sys, glob, os
#import netCDF4
#import numpy
#import xarray

def main():

    main_path = '/glade/p/mmm/parc/ivette/pandac/Observations/ahi' #'/Users/ivette/Documents/MMM_2022/AHI'

    dateIni='20180415'
    dateFin='20180424'

    delta='1'

    datei = datetime.strptime(str(dateIni), "%Y%m%d")
    datef = datetime.strptime(str(dateFin), "%Y%m%d")

    date  = datei

    while (date <= datef):
      datestr = date.strftime("%Y%m%d")
      hh      = date.strftime("%H")
      yyyy    = date.strftime("%Y")
      mm      = date.strftime("%m")
      dd      = date.strftime("%d")
      
      obs_dir = main_path+ '/' + datestr
      if not os.path.exists(obs_dir):
        os.makedirs(obs_dir)
        
      os.system('/glade/work/ivette/my_npl_clone_new/bin/aws s3 sync s3://noaa-himawari8/AHI-L1b-FLDK/'+yyyy+'/'+mm+'/'+dd+'/  '+obs_dir+' --no-sign-request')
      
      #ds = xarray.open_mfdataset(obs_dir+'/*.nc',combine = 'by_coords', concat_dim="time")
      #ds.to_netcdf('OR_ABI-L1b-RadF-M6_G16')
      
      #files = glob.glob(obs_dir+'/*.nc')
      #with open('files_list/flist_'+datestr+'.txt', 'w') as f:
      #  for i in files:
      #    f.write(i.split('/')[-1])
      #    f.write('\n')
            
      date = date + timedelta(days=int(delta))

if __name__ == '__main__': 
  main()
