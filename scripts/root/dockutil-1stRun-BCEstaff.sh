#!/bin/bash

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# 
# version 2.0
# Written by: Mischa van der Bent
#
# Permission is granted to use this code in any way you want.
# Credit would be nice, but not obligatory.
# Provided "as is", without warranty of any kind, express or implied.
#
# DESCRIPTION
# This script configures users docks using docktutil
# source dockutil https://github.com/kcrawford/dockutil/
# 
# REQUIREMENTS
# dockutil Version 3.0.0 or higher installed to /usr/local/bin/
# Compatible with macOS 11.x and higher
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

export PATH=/usr/bin:/bin:/usr/sbin:/sbin

# COLLECT IMPORTANT USER INFORMATION
# Get the currently logged in user
currentUser=$( echo "show State:/Users/ConsoleUser" | scutil | awk '/Name :/ { print $3 }' )

# Get uid logged in user
uid=$(id -u "${currentUser}")

# Current User home folder - do it this way in case the folder isn't in /Users
userHome=$(dscl . -read /users/${currentUser} NFSHomeDirectory | cut -d " " -f 2)

# Path to plist
plist="${userHome}/Library/Preferences/com.apple.dock.plist"

# Convenience function to run a command as the current user
# usage: runAsUser command arguments...
runAsUser() {  
	if [[ "${currentUser}" != "loginwindow" ]]; then
		launchctl asuser "$uid" sudo -u "${currentUser}" "$@"
	else
		echo "no user logged in"
		exit 1
	fi
}

# Check if dockutil is installed
if [[ -x "/usr/local/bin/dockutil" ]]; then
    dockutil="/usr/local/bin/dockutil"
else
    echo "dockutil not installed in /usr/local/bin, exiting"
    exit 1
fi

# Version dockutil
dockutilVersion=$(${dockutil} --version)
echo "Dockutil version = ${dockutilVersion}"

# Create a clean Dock
runAsUser "${dockutil}" --remove all --no-restart ${plist}
echo "clean-out the Dock"

# Full path to Applications to add to the Dock
apps=(
"/System/Applications/Launchpad.app"
"/Applications/Microsoft Edge.app"
"/Applications/Google Chrome.app"
"/System/Volumes/Preboot/Cryptexes/App/System/Applications/Safari.app"
"/System/Applications/Calendar.app"
"/System/Applications/Notes.app"
"/Applications/Microsoft Outlook.app"
"/Applications/Microsoft Teams.app"
"/Applications/Microsoft Word.app"
"/Applications/Microsoft OneNote.app"
"/Applications/Microsoft Powerpoint.app"
"/Applications/Microsoft Excel.app"
"/Applications/Microsoft Teams.app"
"/Applications/Classroom.app"
"/System/Applications/Freeform.app"
"/System/Applications/System Settings.app"
)

# Loop through Apps 
for app in "${apps[@]}"; 
do
	runAsUser "${dockutil}" --add "$app" --no-restart ${plist};

done

# Add Application Folder to the Dock
# runAsUser "${dockutil}" --add /Applications --view grid --display folder --sort name --no-restart ${plist}

# Add logged in users Downloads folder to the Dock
runAsUser "${dockutil}" --add ${userHome}/Downloads --view list --display stack --sort dateadded --no-restart ${plist}

# Disable show recent
# runAsUser defaults write com.apple.dock show-recents -bool FALSE
# echo "Hide show recent from the Dock"

# sleep 3

# Kill dock to use new settings
killall -KILL Dock
echo "Restarted the Dock"

echo "Finished creating default Dock"

exit 0