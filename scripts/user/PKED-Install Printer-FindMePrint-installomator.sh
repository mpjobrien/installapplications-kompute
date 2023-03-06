#!/bin/bash
  
# Determine OS version
osvers=$(sw_vers -productVersion | awk -F. '{print $2}')
  
# Determine working directory  
install_dir=`dirname $0`

# Internet check
if [[ "$(nc -z -v -G 10 1.1.1.1 53 2>&1 | grep -io "succeeded")" != "succeeded" ]]; then
    printlog "ERROR. No internet connection, we cannot continue."
    caffexit 90
fi

# No sleeping
/usr/bin/caffeinate -d -i -m -u &
caffeinatepid=$!
caffexit () {
    kill "$caffeinatepid" || true
    pkill caffeinate || true
    printlog "[LOG-END] Status $1"
    exit $1
}

# Install Ricoh Printer Drivers via Installomator 
if [ ! -e /usr/local/Installomator/Installomator.sh ]
then
	echo "ERROR. Installomator not found. Exiting!"
	exit 1
fi

/usr/local/Installomator/Installomator.sh ricohpsprinters DEBUG=0 NOTIFY=silent INSTALL=force

# Remove old print queues
echo "Removing old print queue..."
lpadmin -x PKED-Ricoh-FollowMePrintLPD

# Install new print queue
  
echo "Installing PKED-Ricoh-FollowMePrintLPD"
lpadmin -p PKED-Ricoh-FollowMePrintLPD -D "PKED-Find Me Print" -E -v lpd://10.239.70.110/St%20Anthonys%20Find-Me%20Print -m "/Library/Printers/PPDs/Contents/Resources/RICOH MP C6004" -L "St Anthonys School" -o Finisher=FinAMURBBK -o ColorModel=Gray -o printer-is-shared=false
exit 0