#!/usr/bin/env python3
# GPSD to Ham Radio Grid-Maidenhead Locator v1.0
# This script will read the gpsd daemon and output the Maidenhead Locator
# based on the gpsd example code in gpsd project
# by K7MHI Kelly Keeton 2023
# Version 1.0.0

import gps  #sudo apt install gpsd gpsd-tools python-gps
import maidenhead as mh  #pip3 install maidenhead

#initialize the connection to gpsd and loop until we get data needed ctl-c to exit
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
            print("NOFIX")
            break

except KeyboardInterrupt:
    # Ctrl-C pressed
    print(' NOFIX')

#Cleanup, and leave
session.close()
exit(0)
