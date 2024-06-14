#!/bin/bash

# Specify the location for the parent directory (Year) containing .bz2 data files
BASE_DIR="/glade/derecho/scratch/mrislam/work/pandac/data/himawari/2017"

# Create a function to decompress individual HSD data file
decompress_file() {
  FILE=$1
  if [ -f "$FILE" ]; then
    echo "---- Currently uncompressing $FILE ----"
    bzip2 -d "$FILE"
  fi
}

export -f decompress_file

# Create a temporary file list that we will use later to store the list of HSD files
FILE_LIST=$(mktemp)

# Loop through each subdirectory for the parent directory
for SUBDIR in "$BASE_DIR"/*; do
  if [ -d "$SUBDIR" ]; then
    echo "-----------------------------------------------------------------------------------------------------------------------------"
    echo "------ Uncompressing bzip2 format himawari HSD data from $SUBDIR ------"
    echo "-----------------------------------------------------------------------------------------------------------------------------"

    # Checking if there are any HSD files in the subdirectory
    HSD_FILES=("$SUBDIR"/HS_H08_*_FLDK_R20_S0101.DAT.bz2)
    
    if [ ${#HSD_FILES[@]} -gt 0 ]; then
      # Add HSD files to the list
      for FILE in "${HSD_FILES[@]}"; do
        if [ -f "$FILE" ]; then
          echo "$FILE" >> "$FILE_LIST"
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

# Finally, running the HSD data decompression process in parallel using MPI
if [ -s "$FILE_LIST" ]; then
  echo "Running decompression with MPI..."
  cat "$FILE_LIST" | xargs -n 1 -P 1 -I {} bash -c 'decompress_file "{}"'
else
  echo "No files to decompress."
fi

# Clean up
rm "$FILE_LIST"

