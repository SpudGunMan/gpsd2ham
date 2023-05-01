#!/usr/bin/env bash
# requires sudo apt-get install crudini xmlstarlet

#Set Grid to tempfile for conky
python3 gpsd2grid.py > /run/user/1000/gridinfo.txt
touch ~/.conkyrc

#Set $GRID for Ham Apps
GRID=$(cat /run/user/1000/gridinfo.txt)
echo "Setting Ham Apps to Grid: $GRID"

# Handler for .ini files
if [[ $(whereis crudini | grep bin) ]];then

    if [ -f ~/.wine/drive_c/RMS\ Express/RMS\ Express.ini ];then
        echo "RMS Express.ini found, updating"
        #Set RMS Express

        #Check for mycall
        if [ -f ~/.grid2app.mycall ];then
            CALL=$(cat ~/.grid2app.mycall)
            echo "using profile for $CALL"
        else
            read -p "Enter your CALLSIGN for RMS profile: " CALL
            echo $CALL > ~/.grid2app.mycall
        fi

        crudini --set ~/.wine/drive_c/RMS\ Express/RMS\ Express.ini $CALL 'Grid Square' $GRID
    fi

    if [ -f ~/.config/WSJT-X.ini ];then
        echo "WSJT-X.ini found, updating"
        #Set WSJT
        crudini --set ~/.config/WSJT-X.ini Configuration MyGrid $GRID
    fi
    
    if [ -f ~/.config/JS8Call.ini ];then
        echo "JS8Call.ini found, updating"
        #Set JS8Call
        crudini --set ~/.config/JS8Call.ini Configuration MyGrid $GRID
    fi

    if [ -f ~/.config/JTDX.ini ];then
        echo "JTDX.ini found, updating"
        #Set JTDX
        crudini --set ~/JTDX.ini Configuration MyGrid $GRID
    fi
    
    if [ -f ~/VarAC.ini ];then
        echo "VarAC.ini found, updating"
        #Set VarAC
        crudini --set ~/VarAC.ini MY_INFO MyLocator $GRID
    fi

    if [ -f ~/.config/ON4QZ/qsstv_9.0.conf ];then
        echo "qsstv_9.0.conf found, updating"
        #Set qsstv
        crudini --set ~/.config/ON4QZ/qsstv_9.0.conf PERSONAL locator $GRID
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

#Goodbye
echo "73.."
exit 0
