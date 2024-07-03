#!/bin/bash

# FTP server details
FTP_SERVER="ftp.ptree.jaxa.jp"
FTP_USERNAME="enter_your_username"
FTP_PASSWORD="enter_your_password"

# File to store selected file URLs
OUTPUT_FILE="selected_files.txt"

# Log into the FTP server, find files matching the pattern and then save their direct download links
lftp -u $FTP_USERNAME,$FTP_PASSWORD $FTP_SERVER <<EOF | grep 'HS_.*_FLDK_R20_.*\.DAT.bz2' | sed "s|^|ftp://$FTP_SERVER/|g" > "$OUTPUT_FILE"
find /
bye
EOF

echo "Selected file URLs saved to $OUTPUT_FILE."
