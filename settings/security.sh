#!/usr/bin/env bash

# Enable FileVault
sudo fdesetup enable -user $USER > $HOME/FileVault_recovery_key.txt

# Enable System Integrity Protection (SIP)
sudo csrutil clear

# Enable the firewall with logging and stealth mode:
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setloggingmode on
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode on

# Disable built-in software from being auto-permitted to listen through firewall
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setallowsigned off

# Disable downloaded signed software from being auto-permitted to listen through firewall
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setallowsignedapp off

# Enable Gatekeeper
sudo spctl --master-enable

# Disable automatic loading of remote content by `Mail.app`
defaults write com.apple.mail-shared DisableURLLoading -bool true

# Disable Remote Apple Events
sudo systemsetup -setremoteappleevents off

# Disable Remote Login
sudo systemsetup -f -setremotelogin off

# Disable Safari Auto Open 'safe' Files
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

# Set AirDrop Discoverability to 'Contacts Only'
defaults write com.apple.sharingd DiscoverableMode -string 'Contacts Only'
sudo killall -HUP sharingd

# Set AppStore update check to every one (`1`) day
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

# Enable Automatic App Store Updates
sudo defaults write "/Library/Preferences/com.apple.commerce.plist" "AutoUpdate" -bool true

# Enable Automatic System Updates
declare -a keys

keys=(AutomaticCheckEnabled AutomaticDownload AutomaticallyInstallMacOSUpdates ConfigDataInstall CriticalUpdateInstall)

for key in "${keys[@]}"; do
  sudo defaults write "/Library/Preferences/com.apple.SoftwareUpdate.plist" "${key}" -bool true
done

# Set a firmware password
sudo firmwarepasswd -setpasswd

# Require an administrator password to access system-wide preferences
security -q authorizationdb read system.preferences > /tmp/system.preferences.plist
/usr/libexec/PlistBuddy -c 'Set :shared false' /tmp/system.preferences.plist
sudo security -q authorizationdb write system.preferences < /tmp/system.preferences.plist
rm '/tmp/system.preferences.plist'

# Require password immediately after sleep or screen saver begins
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0