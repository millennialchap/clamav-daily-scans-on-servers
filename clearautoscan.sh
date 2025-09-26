#!/bin/bash

#written by MillennialChap 2025 - https://millennialchap.com
#Script under the GNU AGPLv3 license.

# Variables
directory="/var/log/clamav/autoscan/";
current_month=$(date +'%Y-%m');

# Check directory for existing files
for file in "$directory"/clamav-*.log; do
    # Check if the file is actually there
    echo "Check if the file is actually there"
    if [[ -f "$file" ]]; then
        # Extracting the date
        echo "Extracting the date"
        file_date=$(basename "$file" | cut -d'-' -f2-3)
        
        # Check if the date is equal to the current month & year
        echo "Check if the date is equal to the current month & year"
        if [[ "$file_date" != "$current_month" ]]; then
            # Delete the file
            echo "Delete the file"
            rm "$file"
            echo "Gelöscht: $file"
        fi
    fi
done
