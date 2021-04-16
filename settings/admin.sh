#!/bin/sh

#Check if running as root and if not elevate
amiroot=$(sudo -n uptime 2>&1 | grep -c "load")
if [ "$amiroot" -eq 0 ]; then
  echo "The Script Require Root Access. Please Enter Your Password."
  sudo -v
  echo
fi

# Keep-alive: update existing `sudo` time stamp until `.osx` has finished
while true; do
  sudo -n true
  sleep 60
  kill -0 "$$" || exit
done 2>/dev/null &

# Close any open System Preferences panes, to prevent them from overriding settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

echo "What's the name for the new user? e.g. master"
read Admin_username
echo "Enter the password for $Admin_username"
read -s Admin_password

sudo defaults write /Library/Preferences/com.apple.loginwindow Hide500Users -bool YES
# Create new user
sudo dscl . -create /Users/${Admin_username}
sudo dscl . -create /Users/${Admin_username} UserShell /bin/zsh
sudo dscl . -create /Users/${Admin_username} RealName "Admin User"
sudo dscl . -create /Users/${Admin_username} UniqueID $(((RANDOM % 490) + 1))
sudo dscl . -create /Users/${Admin_username} PrimaryGroupID 1000
sudo dscl . -create /Users/${Admin_username} NFSHomeDirectory /Local/Users/username
# Create password for new user
sudo dscl . -passwd /Users/${Admin_username} ${Admin_password}
# Make new user admin
sudo dscl . -append /Groups/admin GroupMembership ${Admin_username}
# Hide new user
#sudo dscl . create /Users/${Admin_username} IsHidden 1
# Hide new user Directory
sudo mv /Users/${Admin_username} /var/${Admin_username}
sudo dscl . create /Users/${Admin_username} NFSHomeDirectory /var/${Admin_username}
# Delete new user Public Folder
sudo dscl . delete "/SharePoints/Admin User's Public Folder"

#TODO Make old user not admin

echo "Your settings have been updated!"