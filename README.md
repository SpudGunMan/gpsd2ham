# GPSd to HAM apps
This is another program to take gpsd daemon and convert to grid square for ham radio. I hope the simplicity will allow its functionality to long term stability. I like python.

Implementing the GPS and Maidenhead modules in Python3 for lightweight stable, one time setting of location data. 

This is intended more for set-up and tear-down type, Field and Park Activities vs mobile use. As modifying the apps while running is better left to the UDP servers (possible enhancement script)

## Requirements
python3, bash, ntpq, **crudini, jq,** gpsd. 
Maidenhead and gps python modules last tested with gps.Version: 3.22

```
sudo apt-get install crudini jq
pip3 install maidenhead
```
assumptions are you have the other bits operating

# Installation

`git clone https://github.com/SpudGunMan/gpsd2ham`

## Use

`grid2app.sh`

## Updates the Following apps "ini" files

Supported Apps
- WSJT-X /-Z
- JS8Call
- JTDX
- RMS Express
- VarAC
- FLdigi
- QSSTV 9
- K Log
- Codec2 FreeDATA
- SparkSDR
- PAT Winlink Client
- Conky-temp-file used in KM4ACK scripts

Partial Support
- *VarIM*, there are multiple modems and only setting for a single modem at the moment.

## gpsd2nmea.sh

This script will send gpsd data via gpspipe (gpsd-cient) into netcat for use with winlink

Supported Apps
- Winlink Express

## Using Android as GPS over IP / hotspot

On an android device download the APK from https://github.com/tiagoshibata/Android-GPSd-Forwarder project.

Edit the `/etc/sysconfig/gpsd` config file and make sure that the OPTIONS parameter has a UDP source that accepts packets on port 9999.
```
# Options for gpsd, including serial devices
OPTIONS="udp://*:9999"
# Set to 'true' to add USB devices automatically via udev
USBAUTO="false"
```
- Connect your phone via IP, with hotspot for example
- in the APK GPSd-Fowarder set the IP of the GPSD service and port 9999, press Start

### Dev Notes
- Recomened to run the tool before you start your QSO-app
- submit issues or ideas
- back up if worried
  - grid2app.sh line 7 BACKUP=0 #set to 1 to enable config backups ideal for inital confirmations but leave off for daily use
- only looking at ntp for GPS at the moment not chrony might enhance that

## Activation Helper Files
I also wrote a helper script to launch this and setup my park log archive directory, you might enjoy it as well?
```
wget https://raw.githubusercontent.com/SpudGunMan/SpudGunMan/main/pota-scripts/potactivate.sh
chmod +x potactivate.sh
```

Another one for cleaning up and hacking the MY_SIG for pota on the adif files (handy for the activator)
```
wget https://raw.githubusercontent.com/SpudGunMan/SpudGunMan/main/pota-scripts/potadify.sh
chmod +x potadify.sh
```

### grid2pota.sh
Helper Script for POTA offline CSV-DB Access `grid2pota.sh` is part of this project as well since it depends on and fits well with overall theme. the script can be used with or without this project, but needs to download the database once from pota.app web. the script is not by default enabled with execute `chmod +x grid2pota.sh`


