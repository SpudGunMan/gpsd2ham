# GPSd to HAM apps
This is another program to take gpsd daemon and convert to grid square for ham radio. I hope the simplicity will allow its functionality to long term stability. I like python.

Implimenting the GPS and Maidenhead modules in Python3 for lightweight stable, one time setting of location data. This is indended more for set-up and tear-down type, Field and Park Activities vs mobile use, as modifying the apps while running is better left to the UDP servers (possible enhancment scrip)

## Requirements
python3, bash, crudini, gpsd, maidenhead and gps python modules last tested with gps.Version: 3.22

`sudo apt-get install crudini xmlstarlet`

# Installation

`git clone https://github.com/spudgunman/gpsd2ham`

## Use

`grid2app.sh`

have not tested error conditions or many distros - alpha release

## Updates the Following apps static files

Recomened to run the tool before you start your QSO-app

- WSJT-X /-Z
- JS8Call
- JTDX
- RMS Express
- VarAC
- FLdigi
- QSSTV 9


