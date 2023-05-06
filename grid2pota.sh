#!/bin/bash
# 
# POTA - Parks On The Air Park Lookup Tool
# Uses grid square to return simple list of parks from CSV DB
# copyright 2023 by K7MHI Kelly Keeton // MIT License
# version 1.1.0

# Check if the POTA CSV file exists, download if not
if [ ! -f pota_all_parks.csv ]; then
    # Get the latest POTA CSV file
    wget -q https://pota.app/all_parks_ext.csv -O pota_all_parks.csv
    echo "POTA CSV File Downloaded"
else
    # Check if the POTA CSV file is older than 100 days
    if test `find "pota_all_parks.csv" -mtime +100`; then
        # Get the latest POTA CSV file
        rm pota_all_parks.csv
        wget -q https://pota.app/all_parks_ext.csv -O pota_all_parks.csv
        echo "POTA CSV File Updated"
    fi
fi

# Attempt to get grid from 'conky location' if it exists
if [ -f /run/user/1000/gridinfo.txt ]; then
    grid=$(cat /run/user/1000/gridinfo.txt)
fi

# Set Grid with gpsd2grid.py if it exists
if [ -f gpsd2grid.py ]; then
    # Run gpsd2grid.py and set output to gps variable
    echo "Attempting gpsd2grid.py acuire, will auto-exit in 10 seconds"
    gps=$(timeout 10s python3 gpsd2grid.py)


    # Check if GPSD2GRID returned a valid grid
    if [[ "$gps" == *"NOFIX"* ]]; then
        echo "GPSD2GRID: No GPS Fix"
    else
        # Set grid to gpsd2grid.py output
        grid=$gps
    fi
fi

# grid is not set yet, prompt user for input
if [ -z "$grid" ]; then
    read -p "Please Enter Grid:" grid

    # Check if grid is valid via regex match
    if [[ $grid =~ [A-R]{2}[0-9]{2}[a-w]? ]]; then
        echo "Using Grid: $grid"
    else
        echo "Grid is Invalid (example CN88ri) exiting"
        exit 1
    fi
fi

# Check if the POTA CSV file exists, run processing
if [ -f pota_all_parks.csv ]; then
    # Set the park variable with parkID and parkName and grid from CSV
    park_csv=$(grep $grid pota_all_parks.csv | cut -d, -f1,2,8)

    # Check if the park variable is empty from full grid search
    if [ -z "$park_csv" ]; then
        echo "No POTA Park Found for $grid trying 5 digit search ${grid:0:5}"
        park_csv=$(grep ${grid:0:5} pota_all_parks.csv | cut -d, -f1,2,8)

        # Check if the park variable is empty from 5 digit grid search
        if [ -z "$park_csv" ]; then
            echo "No POTA Park Found for ${grid:0:5} trying 4 digit search ${grid:0:4}"
            park_csv=$(grep ${grid:0:4} pota_all_parks.csv | cut -d, -f1,2,8)

            # Check if the park variable is empty from 4 digit grid search
            if [ -z "$park_csv" ]; then
                echo "No POTA Park Found for $grid exiting"
                exit 1
            else
                # Print the park variable from 4 digit grid search
                echo "Park: $park_csv"
            fi

        else
            # Print the park variable from 5 digit grid search
            echo "Park: $park_csv"
        fi

    else
        # Print the park variable from full grid search
        echo "Park: $park_csv"
    fi

fi

echo "73.." # End of Script
exit 0
