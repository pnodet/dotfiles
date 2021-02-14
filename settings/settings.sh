#!/bin/sh

# Setting up the computer label & name
printf "What is this machine's label (Example: Paul's MacBook Pro) ?"
read mac_os_label
if [[ -z "$mac_os_label" ]]; then
    echo "ERROR: Invalid MacOS label."
    exit 1
fi

printf "What is this machine's name (Example: paul-macbook-pro) ?"
read mac_os_label
if [[ -z "$mac_os_name" ]]; then
    echo "ERROR: Invalid MacOS name."
    exit 1
fi

echo "Setting system Label and Name..."
sudo scutil --set ComputerName "$mac_os_label"
sudo scutil --set HostName "$mac_os_name"
sudo scutil --set LocalHostName "$mac_os_name"
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "$mac_os_name"


###############################################################################
# SSD-specific tweaks                                                         #
###############################################################################

# Prevent Time Machine from prompting to use new hard drives as backup volume
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

# Disable automatic backups Time Machine
sudo tmutil disable

# disable time machine
sudo defaults write /Library/Preferences/com.apple.TimeMachine MobileBackups -bool false
sudo defaults write /Library/Preferences/com.apple.TimeMachine AutoBackup -bool false

# Disable the sudden motion sensor as it’s not useful for SSDs
sudo pmset -a sms 0

###############################################################################
# Stuff                                                                       #
###############################################################################

sudo nvram StartupMute=%01 # System - Disable boot sound effects.

# dictation
defaults write com.apple.speech.recognition.AppleSpeechRecognition.prefs DictationIMMasterDictationEnabled -bool false

# advanced dictation
defaults write com.apple.speech.recognition.AppleSpeechRecognition.prefs DictationIMUseOnlyOfflineDictation -bool false

# "Bluetooth - Increase sound quality for headphones/headsets."
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40

# feedback sound when changing volume - options; 1 = yes, 0 = no
defaults write NSGlobalDomain com.apple.sound.beep.feedback -integer 0

###############################################################################
# Memory management                                                           #
###############################################################################

# Disable swap file. macOS will crash if mem will exceed max mem.
# sudo launchctl unload -w /System/Library/LaunchDaemons/com.apple.dynamic_pager.plist

# Enable swap back.
# sudo launchctl load -wF /System/Library/LaunchDaemons/com.apple.dynamic_pager.plist

# Disable automatic termination of inactive apps
defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true

# Disable Resume system-wide
# defaults write NSGlobalDomain NSQuitAlwaysKeepsWindows -bool false

# "Enable the debug menu in Disk Utility"
defaults write com.apple.DiskUtility DUDebugMenuEnabled -bool true
defaults write com.apple.DiskUtility advanced-image-options -bool true

###############################################################################
# Screen                                                                      #
###############################################################################

defaults write com.apple.screencapture location -string "$HOME/Downloads" # Save screenshots to download
defaults write com.apple.screencapture type -string "png"                             # Save screenshots in PNG format - options: BMP, GIF, JPG, PDF, TIFF
defaults write com.apple.screencapture disable-shadow -bool false                     # Disable shadow in screenshots
defaults write com.apple.screencapture show-thumbnail -bool false                     # Disable screenshot thumbnails

defaults write -g CGFontRenderingFontSmoothingDisabled -bool false                                  # Enable subpixel font rendering on non-Apple LCDs
sudo defaults write /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled -bool true # Enable HiDPI display modes

###############################################################################
# CD & DVD
###############################################################################

defaults write com.apple.digihub com.apple.digihub.dvd.video.appeared -dict action 1  # disable video dvd automatic action
defaults write com.apple.digihub com.apple.digihub.blank.dvd.appeared -dict action 1  # disable blank dvd automatic action
defaults write com.apple.digihub com.apple.digihub.blank.cd.appeared -dict action 1   # disable blank cd automatic action
defaults write com.apple.digihub com.apple.digihub.cd.music.appeared -dict action 1   # disable music cd automatic action
defaults write com.apple.digihub com.apple.digihub.cd.picture.appeared -dict action 1 # disable picture cd automatic action

###############################################################################
# Dock
###############################################################################

defaults write com.apple.Dock orientation -string left # Dock - Position left
defaults write com.apple.dock tilesize -integer 48     # Set the icon size apps to 48 pixels
defaults write com.apple.dock autohide -bool true               # Dock - Automatically hide and show.
defaults write com.apple.dock autohide-delay -float 0.1         # Modify the auto-hiding Dock delay
defaults write com.apple.dock autohide-time-modifier -float 0.3 # Modify the animation when hiding/showing the Dock
defaults write com.apple.dock magnification -bool true          # Enable Dock magnification
defaults write com.apple.dock largesize -int 54                 # Set the magnification max icon size of apps to 54 pixels
defaults write com.apple.dock mineffect -string "genie" # Minimize/maximize window effect : options: scale, genie
defaults write -g AppleWindowTabbingMode -string manual # Prefer tabs when opening documents : always, fullscreen or manual
defaults write com.apple.dock minimize-to-application -bool true  # Minimize windows into their application’s icon
defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true # Enable spring loading for all Dock items
defaults write com.apple.dock mouse-over-hilite-stack -bool true  # Enable highlight hover effect for the grid view of a stack (Dock)
defaults write com.apple.dock show-process-indicators -bool true  # Show indicator for open applications in the Dock
#defaults write com.apple.dock static-only -bool true # Show only open applications in the Dock
#defaults write com.apple.dock single-app -bool TRUE # Single App mode
defaults write com.apple.dock showhidden -bool true     # Hidden App mode
defaults write com.apple.dock showhidden -bool true     # Make Dock icons of hidden applications translucent
defaults write com.apple.dock scroll-to-open -bool true # Scroll-to-open App mode
defaults write com.apple.dock launchanim -bool true     # Animate opening applications from the Dock
defaults write com.apple.dock hide-mirror -bool true    # Make Dock more transparent
defaults write com.apple.dock show-recents -bool false  # show last used applications in the dock

###############################################################################
# Trackpad, mouse, keyboard, Bluetooth accessories, and input                 #
###############################################################################

# TODO:

#cd ~ && cd /Volumes/Macintosh\ HD/Library/Keyboard\ Layouts/
#curl -sSL https://raw.githubusercontent.com/pnodet/macsetup/master/dotfiles/Better_French.bundle/Contents/Resources/Better_French.keylayout -o Better_French.keylayout
#https://support.apple.com/lt-lt/guide/terminal/trmlkbrd/mac

# "Trackpad - Enable tap to click for current user and the login screen."
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# how to right click
defaults write NSGlobalDomain ContextMenuGesture -int 1
defaults write com.apple.AppleMultitouchTrackpad TrackpadRightClick -bool true

# 0 = two finger click or 1 = click left bottom corner of trackpad or 2 = click right bottom corner of trackpad :
defaults write com.apple.AppleMultitouchTrackpad TrackpadCornerSecondaryClick -int 0

# "Disable press-and-hold for keys in favor of key repeat"
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# "Set a blazingly fast keyboard repeat rate"
defaults write NSGlobalDomain KeyRepeat -int 1         # normal minimum is 2 (30 ms), you can use 1
defaults write NSGlobalDomain InitialKeyRepeat -int 10 # normal minimum is 15 (225 ms), you can use 10

# "Follow the keyboard focus while zoomed in"
sudo defaults write com.apple.universalaccess closeViewZoomFollowsFocus -bool false

# "Zoom should use nearest neighbor instead of smoothing."
sudo defaults write com.apple.universalaccess 'closeViewSmoothImages' -bool false

# "Automatically illuminate built-in MacBook keyboard in low light"
defaults write com.apple.BezelServices kDim -bool true

# "Turn off keyboard illumination when computer is not used for 5 minutes"
defaults write com.apple.BezelServices kDimTime -int 300

# "Enable full keyboard access for all controls"
# (e.g. enable Tab in modal dialogs)
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool true # False to Disable auto-correct
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false    # Auto capitalization
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool true # Substitute double space with dot and space
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false # Smart quotes
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false  # Smart dashes

###############################################################################
# Dashboard, and hot corners                                                  #
###############################################################################

# changing notification banner persistence time (value in seconds)
defaults write com.apple.notificationcenterui bannerTime 1

# Disable time to leave
defaults write com.apple.iCal "TimeToLeaveEnabled" -bool false

defaults write com.apple.dock expose-animation-duration -float 0.1 # Speed up Mission Control animations
defaults write com.apple.dock mru-spaces -bool false               # Don’t automatically rearrange Spaces based on most recent use
defaults write -g AppleSpacesSwitchOnActivate -bool true           # when switching applications, switch to respective space

# "Don’t group windows by application in Mission Control"
# (i.e. use the old Exposé behavior instead)
defaults write com.apple.dock expose-group-by-app -bool false

# Change the layout of Launchpad.
defaults write com.apple.dock springboard-columns -int 7 # Change ‘X’ into the number of icons to be showed in a single row
defaults write com.apple.dock springboard-rows -int 4    # Change ‘X’ to the number of rows

# Hot corners
# Possible values:
#  0: No-op
#  2: Mission Control
#  3: Show application windows
#  4: Desktop
#  5: Start screen saver
#  6: Disable screen saver
#  7: Dashboard
# 10: Put display to sleep
# 11: Launchpad
# 12: Notification Center

# Modifiers : no modifier key is 0, Shift is 131072, Control is 262144, Option is 524288 and Command is 1048576.

# Top left screen corner → No-op
defaults write com.apple.dock wvous-tl-corner -int 0
defaults write com.apple.dock wvous-tl-modifier -int 0
# Top right screen corner → Launchpad
defaults write com.apple.dock wvous-tr-corner -int 11
defaults write com.apple.dock wvous-tr-modifier -int 0
# Bottom left screen corner + ⌥ → Put display to sleep
defaults write com.apple.dock wvous-bl-corner -int 5
defaults write com.apple.dock wvous-bl-modifier -int 524288
# Bottom right screen corner → Mission Control
defaults write com.apple.dock wvous-br-corner -int 2
defaults write com.apple.dock wvous-br-modifier -int 0

###############################################################################
# Power                                                                       #
###############################################################################

# UI
defaults write com.apple.menuextra.battery ShowTime -string "YES"   # Remaining battery time
defaults write com.apple.menuextra.battery ShowPercent -string "YES" # Percentage

sudo pmset -a lidwake 1               # Enable lid wakeup
sudo pmset -a standbydelayhigh 8000   # Sets the number of seconds your Mac waits to enter standby at high battery
sudo pmset -a standbydelaylow 1800    # Sets the number of sectons your Mac waits to enter standby at low battery
sudo pmset -a highstandbythreshold 25 # Sets the threshold inbetween

# On battery
sudo pmset -b displaysleep 3 # Display sleep: 3 min
sudo pmset -b sleep 10       # Computer sleep: 10 min
sudo pmset -b disksleep 10   # Put the hard disk(s) to sleep when possible: 10 min
sudo pmset -b lessbright 0   # AVOID slightly dimming the display when using battery power source
sudo pmset -b halfdim 1      # Automatically reduce brightness before display goes to sleep
sudo pmset -b darkwakes 0    # activate powernap - options : 0=no, 1=yes
sudo pmset -b autorestart 1  # Start up automatically after a power failure

# Power Adapter (Plug)
sudo pmset -c displaysleep 10 # Display sleep: 10 min
sudo pmset -c sleep 30        # Computer sleep: 30 min
sudo pmset -c disksleep 20    # Put the hard disk(s) to sleep when possible: 20 min
sudo pmset -c womp 0          # Disable Wake for network access
sudo pmset -c halfdim 1       # Automatically reduce brightness before display goes to sleep
sudo pmset -c darkwakes 0     # activate powernap - options : 0=no, 1=yes
sudo pmset -c autorestart 1   # Start up automatically after a power failure

# Restart automatically if the computer freezes
sudo systemsetup -setrestartfreeze on

###############################################################################
# MacBookPro Touch Bar                                                        #
###############################################################################

# touchbar without fn keys - options : fullControlStrip or app
sudo defaults write com.apple.touchbar.agent PresentationModeGlobal -string fullControlStrip

# touchbar when pressing fn - options : fullControlStrip or app
sudo defaults write com.apple.touchbar.agent PresentationModeFnModes -dict-add functionKeys -string app

###############################################################################
# Restart process                                                             #
###############################################################################

echo "Changing settings and restarting Dock, Launchpad, ControlStrip…"

# restart ControlStrip
killall ControlStrip

# Force a restart of Launchpad with the following command to apply the changes:
defaults write com.apple.dock ResetLaunchPad -bool TRUE
killall Dock

# applying changes without having to logout
killall usernoted
killall NotificationCenter
killall sighup usernoted
killall sighup NotificationCenter