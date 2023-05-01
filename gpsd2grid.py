#! /usr/bin/env python3
# GPSD to Ham Radio Grid-Maidenhead Locator v0.1
# This script is based on the gpsd example code in gpsd project
# by K7MHI Kelly Keeton 2023
#
import gps               #installed with gpsd last tested with Version: 3.22
import maidenhead as mh  #pip3 install maidenhead

#initialize the connection to gpsd and loop until we get data needed
session = gps.gps(mode=gps.WATCH_ENABLE)
try:
    while 0 == session.read():
        if not (gps.MODE_SET & session.valid):
            # not useful, probably not a TPV message
            continue

        if ((gps.isfinite(session.fix.latitude) and
             gps.isfinite(session.fix.longitude))):
            
            #maidenhead locator to 3 digits on stdout and leave loop
            print (mh.to_maiden (session.fix.latitude, session.fix.longitude,3))
            break

        else:
            print("NO GPS FIX")
            continue
except KeyboardInterrupt:
    print('73..')

#Cleanup, and leave
session.close()
exit(0)
