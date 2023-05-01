#!/usr/bin/env bash
# This script will update the following apps with your current grid square
# requires gpsd2grid.py and sudo apt-get install crudini
# by K7MHI Kelly Keeton 2023

#user variables
BACKUP=0 #set to 1 to enable config backups ideal for inital confirmations but leave off for daily use

#Set Grid to tempfile for conky
python3 gpsd2grid.py > /run/user/1000/gridinfo.txt

#Set $GRID for Ham Apps
GRID=$(cat /run/user/1000/gridinfo.txt)

#Check for GPSD Errors and halt if found
if grep "NOFIX" /run/user/1000/gridinfo.txt || [ -z "$GRID" ] || [ ! -f /run/user/1000/gridinfo.txt ];then
    echo "GPSD Error, NO-GPS-FIX"
    exit 1
else
    echo "Setting Ham Apps to Grid: $GRID"
fi

# Handler for .ini files
if [[ $(whereis crudini | grep bin) ]];then

    if [ -f ~/.wine/drive_c/RMS\ Express/RMS\ Express.ini ];then
        echo "RMS Express.ini found, updating"

        #Check for mycall
        if [ -f ~/.grid2app.mycall ];then
            CALL=$(cat ~/.grid2app.mycall)
            echo "using profile for $CALL"
        else
            read -p "Enter your CALLSIGN for RMS profile: " CALL
            echo $CALL > ~/.grid2app.mycall
        fi

        #Set RMS Express
        if [ $BACKUP -eq 1 ];then
            cp ~/.wine/drive_c/RMS\ Express/RMS\ Express.ini ~/.wine/drive_c/RMS\ Express/RMS\ Express.ini.bak
        fi
        crudini --set ~/.wine/drive_c/RMS\ Express/RMS\ Express.ini $CALL 'Grid Square' $GRID
    fi

    if [ -f ~/.config/WSJT-X.ini ];then
        echo "WSJT-X.ini found, updating"
        #Set WSJT
        if [ $BACKUP -eq 1 ];then
            cp ~/.config/WSJT-X.ini ~/.config/WSJT-X.ini.bak
        fi
        crudini --set ~/.config/WSJT-X.ini Configuration MyGrid $GRID

        #check for ntp-gps edits
        if grep GPS /etc/ntp.conf;then
            ntpq -p | grep -E 'SHM|offset'
        else
            echo "INFORMATION: NTP is not set to collect from GPS"
        fi

    fi
    
    if [ -f ~/.config/JS8Call.ini ];then
        echo "JS8Call.ini found, updating"
        #Set JS8Call
        if [ $BACKUP -eq 1 ];then
            cp ~/.config/JS8Call.ini ~/.config/JS8Call.ini.bak
        fi
        crudini --set ~/.config/JS8Call.ini Configuration MyGrid $GRID
    fi

    if [ -f ~/.config/JTDX.ini ];then
        echo "JTDX.ini found, updating"
        #Set JTDX
        if [ $BACKUP -eq 1 ];then
            cp ~/.config/JTDX.ini ~/.config/JTDX.ini.bak
        fi
        crudini --set ~/.config/JTDX.ini Configuration MyGrid $GRID
    fi
    
    if [ -f ~/VarAC.ini ];then
        echo "VarAC.ini found, updating"
        #Set VarAC
        if [ $BACKUP -eq 1 ];then
            cp ~/VarAC.ini ~/VarAC.ini.bak
        fi
        crudini --set ~/VarAC.ini MY_INFO MyLocator $GRID
    fi

    if [ -f ~/.config/ON4QZ/qsstv_9.0.conf ];then
        echo "qsstv_9.0.conf found, updating"
        #Set qsstv
        if [ $BACKUP -eq 1 ];then
            cp ~/.config/ON4QZ/qsstv_9.0.conf ~/.config/ON4QZ/qsstv_9.0.conf.bak
        fi
        crudini --set ~/.config/ON4QZ/qsstv_9.0.conf PERSONAL locator $GRID
    fi

    if [ -f ~/varim/varim.ini ];then
        echo "varim.ini found, updating however due to issues with varim.ini, updates port2"
        #Set varim
        if [ $BACKUP -eq 1 ];then
            cp ~/varim/varim.ini ~/varim/varim.ini.bak
        fi
        crudini --set ~/varim/varim.ini port gridsq $GRID
    fi

else
    echo "crudini not found, launched: sudo apt-get install crudini"
    echo "Please re-run this script after crudini is installed"
    sudo apt-get install crudini
fi

#Handler for Flat Files
if [ -f ~/.fldigi/fldigi_def.xml ];then
    echo "fldigi_def.xml found, updating"
    #FLDigi uses unparsable "XML"
    sed -i "s/<MYLOC>.*<\/MYLOC>/<MYLOC>$GRID<\/MYLOC>/g" ~/.fldigi/fldigi_def.xml
fi

if [ -f ~/.conkyrc ];then
    #reset Conky by reaction
    touch ~/.conkyrc
fi

if [ -f ~/.config/FreeDATA/config.json ];then
    echo "FreeDATA config.json found, not ready to edit json yet"
    #Set FreeDATA
    if [ $BACKUP -eq 1 ];then
        cp ~/.config/FreeDATA/config.json ~/.config/FreeDATA/config.json.bak
    fi
    #sed -i "s/\"mygrid\": \".*\",/\"mygrid\": \"$GRID\",/g" ~/.config/FreeDATA/config.json
fi

#Goodbye
echo "73.."
exit 0
