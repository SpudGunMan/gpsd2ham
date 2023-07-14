#!/bin/bash
# convert gpsd output to nmea sentences over tcp
# this script is intended to be used with gpsd and gps-client installed
# copyright 2024 by K7MHI Kelly Keeton, MIT License
# version 1.0.0

#set port to listen on defaults to localhost:1234
PORT=1234

#use gpspipe to get gpsd output to nmea sentences
if [[ $(whereis gpspipe | grep bin) ]];then
    #gpspipe is installed
    echo "piping hot GPS being delivered to port $PORT"
    gpspipe -r | nc -l -p $PORT
else
    echo "gpspipe is not installed"
    exit 1
fi

echo "gpsd2nmea.sh exiting"
exit 0
```
