# GPSd to HAM apps
This is another program to take gpsd daemon and convert to grid square for ham radio. I hope the simplicity will allow its functionality to long term stability. I like python.

Implementing the GPS and Maidenhead modules in Python3 for lightweight stable, one time setting of location data. 

This is intended more for set-up and tear-down type, Field and Park Activities vs mobile use. As modifying the apps while running is better left to the UDP servers (possible enhancement script)

## Requirements
python3, bash, ntpq, crudini, gpsd. 
Maidenhead and gps python modules last tested with gps.Version: 3.22

```
sudo apt-get install crudini
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

Partial Support
- *VarIM*
- *Codec2 FreeDATA*

### Dev Notes
- Recomened to run the tool before you start your QSO-app
- submit issues or ideas
- back up if worried
  - grid2app.sh line 7 BACKUP=0 #set to 1 to enable config backups ideal for inital confirmations but leave off for daily use
- only looking at ntp for GPS at the moment not chrony might enhance that

