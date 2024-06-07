#!/bin/bash

# Base directory containing the subdirectories with .bz2 files
BASE_DIR="/glade/derecho/scratch/mrislam/work/pandac/data/himawari"

# Loop through each subdirectory
for SUBDIR in "$BASE_DIR"/*; do
  if [ -d "$SUBDIR" ]; then

    echo "-----------------------------------------------------------------------------------------------------------------------------"
    echo "------ Uncompressing bzip2 format himawari HSD data from $SUBDIR ------"
    echo "-----------------------------------------------------------------------------------------------------------------------------"

    # Check if there are any HSD files in the subdirectory
    HSD_FILES=("$SUBDIR"/HS_H08_*_FLDK_R20_S0101.DAT.bz2)
    
    if [ ${#HSD_FILES[@]} -gt 0 ]; then

      # Loop through each HSD file in the subdirectory
      for FILE in "${HSD_FILES[@]}"; do
        if [ -f "$FILE" ]; then
          # Uncompress HSD files
          echo "---- Currently uncompressing $FILE ----"
          bzip2 -d "$FILE"
        fi
      done
    else
      echo " "
      echo " "
      echo "------------- No data in the directory: $SUBDIR ----------------------"
      echo " "
      echo " "
    fi
  fi
done

