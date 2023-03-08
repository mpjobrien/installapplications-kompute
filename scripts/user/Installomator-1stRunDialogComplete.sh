#!/bin/sh

# Location of dialog and dialog command file
dialogApp="/usr/local/bin/dialog"
dialog_command_file="/var/tmp/dialog.log"

# Validate logged-in user

loggedInUser=$( echo "show State:/Users/ConsoleUser" | scutil | awk '/Name :/ { print $3 }' )

if [[ -z "${loggedInUser}" || "${loggedInUser}" == "loginwindow" ]]; then
    echo "${timestamp} - Pre-flight Check: No user logged-in; exiting."
    exit 1
else
    loggedInUserFullname=$( id -F "${loggedInUser}" )
    loggedInUserFirstname=$( echo "$loggedInUserFullname" | cut -d " " -f 1 )
    loggedInUserID=$(id -u "${loggedInUser}")
fi

#Determine WS1 GroupID to determine OG & Location
sitecode="PKED"
# sitecode=$(defaults read /Library/Managed\ Preferences/com.kompute.ws1.UserDetails.plist GroupIdentifier | cut -c 4-)

if [[ sitecode="PKED" ]]; then 
    location="St Anthony's Kedron"
elif [[ sitecode="PMAG" ]]; then 
    location="St Benedict's Mango Hill"
elif [[ sitecode="PBAR" ]]; then 
    location="St Joseph's Bardon"
else 
    sitecode="Brisbane Catholic Education"
fi

#Set Location Logo

if [[ sitecode="PKED" ]]; then 
    LOGO_PATH="https://images.squarespace-cdn.com/content/5f196055b939084eefc0d9fd/e9a251fc-b392-46c7-af6a-09b33509d314/Logo-PKED.png"
else 
    LOGO_PATH="https://images.squarespace-cdn.com/content/5f196055b939084eefc0d9fd/0c03b0c1-f953-4fea-b46a-dfb3f27eba9d/Logo-BCE.png"
fi


# Dialog display settings, change as desired
title="Installing Apps and other software"
message="## All done! \n A restart is required to complete the setup process. \n Please enter your password when requested to activate Filevault. \n Thanks!! 😊"
bannerImage="https://images.squarespace-cdn.com/content/5f196055b939084eefc0d9fd/a2338162-9d59-427b-93d2-9bb060e9d035/dialog-header-bce.png"
bannerText="Enjoy your new Mac!"
infobox="Analyzing input …" # Customize at "Update Setup Your Mac's infobox"
loggedInUser=$( scutil <<< "show State:/Users/ConsoleUser" | awk '/Name :/ && ! /loginwindow/ { print $3 }' )
serialNumber=$(system_profiler SPHardwareDataType | awk '/Serial Number/{print $4}')
osversion=$(sw_vers -productVersion)
model=$(system_profiler SPHardwareDataType | grep "Model Name:" | sed 's/Model Name://g' | sed -e 's/^[ \t]*//')

$dialogApp -p --title $title \
--message "$message" \
--icon $LOGO_PATH \
--button1text "Exit" \
--ontop \
--titlefont 'shadow=false, size=36' \
--messagefont 'size=14' \
--height '690' \
--width '1000' \
--position 'centre' \
--quitkey k \
--bannerimage $bannerImage \
--bannertext "$bannerText" \
--infobox "#### Model  \n $model \n#### macOS version  \n $osversion \n#### Serial number  \n $serialNumber \n#### Current user  \n $loggedInUser \n#### Location \n $location " \


exit 0