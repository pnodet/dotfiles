#!/bin/sh

# Paul Nodet
# paul.nodet@gmail.com
# ressources from various github users configs, thanks to http://dotfiles.github.io

# Create user `Sites` directory
mkdir -p "$HOME/Sites"

# Show user `Library` folder
chflags nohidden "${HOME}/Library"

# Create user `bin` directory
mkdir -p "$HOME/bin"

# Hide user `bin` folder
chflags -h hidden "${HOME}/bin"

# Quitting via ⌘ + Q; doing so will also hide desktop icons
defaults write com.apple.finder QuitMenuItem -bool true

# Window animations and Get Info animations
defaults write com.apple.finder DisableAllAnimations -bool true

# Icons for hard drives, servers, and removable media on the desktop
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowMountedServersOnDesktop -bool false
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false

# Visibility of hidden files
#defaults write com.apple.finder AppleShowAllFiles -bool true

# Filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Path bar
defaults write com.apple.finder ShowPathbar -bool true

# Text selection in Quick Look
defaults write com.apple.finder QLEnableTextSelection -bool true

# Full POSIX path as window title
defaults write com.apple.finder _FXShowPosixPathInTitle -bool false

# Search scope
# This Mac       : `SCev`
# Current Folder : `SCcf`
# Previous Scope : `SCsp`
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# File extension change warning
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Arrange by
# Kind, Name, Application, Date Last Opened,
# Date Added, Date Modified, Date Created, Size, Tags, None
defaults write com.apple.finder FXPreferredGroupBy -string "Kind"

# Spring loaded directories
defaults write NSGlobalDomain com.apple.springing.enabled -bool true

# Delay for spring loaded directories
defaults write NSGlobalDomain com.apple.springing.delay -float 0

# Writing of .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Disk image verification
defaults write com.apple.frameworks.diskimages skip-verify -bool true
defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true

# Automatically open a new Finder window when a volume is mounted
defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool false
defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool false
defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool false

# Set icon view settings on desktop and in icon views
for view in 'Desktop' 'FK_Standard' 'Standard'; do

  # Item info near icons
  /usr/libexec/PlistBuddy -c "Set :${view}ViewSettings:IconViewSettings:showItemInfo bool true" ~/Library/Preferences/com.apple.finder.plist

  # Item info to right of icons
  /usr/libexec/PlistBuddy -c "Set :${view}ViewSettings:IconViewSettings:labelOnBottom bool false" ~/Library/Preferences/com.apple.finder.plist

  # Snap-to-grid for icons
  /usr/libexec/PlistBuddy -c "Set :${view}ViewSettings:IconViewSettings:arrangeBy string grid" ~/Library/Preferences/com.apple.finder.plist

  # Grid spacing for icons
  /usr/libexec/PlistBuddy -c "Set :${view}ViewSettings:IconViewSettings:gridSpacing integer 100" ~/Library/Preferences/com.apple.finder.plist

  # Icon size
  /usr/libexec/PlistBuddy -c "Set :${view}ViewSettings:IconViewSettings:iconSize integer 32" ~/Library/Preferences/com.apple.finder.plist

done

# Preferred view style
# Icon View   : `icnv`
# List View   : `Nlsv`
# Column View : `clmv`
# Cover Flow  : `Flwv`
# After configuring preferred view style, clear all `.DS_Store` files
# to ensure settings are applied for every directory
# sudo find / -name ".DS_Store" --delete
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"

# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# View Options
# ColumnShowIcons    : Show preview column
# ShowPreview        : Show icons
# ShowIconThumbnails : Show icon preview
# ArrangeBy          : Sort by
#   dnam : Name
#   kipl : Kind
#   ludt : Date Last Opened
#   pAdd : Date Added
#   modd : Date Modified
#   ascd : Date Created
#   logs : Size
#   labl : Tags
/usr/libexec/PlistBuddy \
  -c "Set :StandardViewOptions:ColumnViewOptions:ColumnShowIcons bool    false" \
  -c "Set :StandardViewOptions:ColumnViewOptions:FontSize        integer 11" \
  -c "Set :StandardViewOptions:ColumnViewOptions:ShowPreview     bool    true" \
  -c "Set :StandardViewOptions:ColumnViewOptions:ArrangeBy       string  dnam" \
  ~/Library/Preferences/com.apple.finder.plist

# New window target
# Computer     : `PfCm`
# Volume       : `PfVo`
# $HOME        : `PfHm`
# Desktop      : `PfDe`
# Documents    : `PfDo`
# All My Files : `PfAF`
# Other…       : `PfLo`
defaults write com.apple.finder NewWindowTarget -string 'PfHm'
#defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"

# Warning before emptying Trash
defaults write com.apple.finder WarnOnEmptyTrash -bool false

# Empty Trash securely
defaults write com.apple.finder EmptyTrashSecurely -bool false

# AirDrop over Ethernet and on unsupported Macs running Lion
defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true

# Desktop Enabled
defaults write com.apple.finder CreateDesktop -bool false

# Expand the following File Info panes:
# “General”, “Open with”, and “Sharing & Permissions”
defaults write com.apple.finder FXInfoPanesExpanded -dict \
  General -bool true \
  OpenWith -bool true \
  Privileges -bool true

###############################################################################
# Finder.                                                                     #
###############################################################################

defaults write com.apple.finder QuitMenuItem -bool true                     # Finder: Allow quitting via ⌘ + Q; doing so will also hide desktop icons
defaults write com.apple.finder DisableAllAnimations -bool true             # Finder: Disable window animations and Get Info animations
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false # iCloud: Save to disk by default : true = save to icloud

# Disable this feature, only if you use disk image from trusted sources
# "Disable disk image verification"
defaults write com.apple.frameworks.diskimages skip-verify -bool true
defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true

# "Set the default location for new Finder windows"
# For other paths, use 'PfDe' and 'file:///full/path/here/'
# New Finder window opens in home directory
defaults write com.apple.finder NewWindowTarget -string "PfLo"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"

defaults write com.apple.finder ShowStatusBar -bool true                   # Finder: Show status bar.
defaults write com.apple.finder ShowPathbar -bool true                     # Finder: Show path bar.
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"        # Use column view in all Finder windows by default : options : `icnv`, `clmv`, `Flwv`
defaults write com.apple.finder _FXSortFoldersFirst -bool true             # Keep folders on top when sorting by name (version 10.12 and later)
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true         # Display full POSIX path as Finder window title
defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 2            # Set sidebar icon size to medium
defaults write com.apple.finder SidebarShowingiCloudDesktop -bool false    # Hide iCloud drive in drives
defaults write com.apple.finder SidebarShowingSignedIntoiCloud -bool false # Hide iCloud drive in drives
defaults write com.apple.finder ShowRecentTags -bool true                  # Show tags

defaults write com.apple.finder EmptyTrashSecurely -bool true # Empty Trash securely by default
defaults write com.apple.finder WarnOnEmptyTrash -bool true   # Enable the warning before emptying the Trash

defaults write NSGlobalDomain com.apple.springing.enabled -bool true # Enable spring loading for directories
defaults write NSGlobalDomain com.apple.springing.delay -float 0     # Remove the spring loading delay for directories
defaults write NSGlobalDomain AppleShowAllExtensions -bool true      # Finder: show all filename extensions
defaults write com.apple.finder QLEnableTextSelection -bool true     # Finder: Allow text selection in Quick Look.

#defaults write com.apple.finder FXDefaultSearchScope -string "SCcf" # When performing a search, search the current folder by default

# Show item info to the right of the icons on the desktop
#/usr/libexec/PlistBuddy -c "Set DesktopViewSettings:IconViewSettings:labelOnBottom false" ~/Library/Preferences/com.apple.finder.plist

# Expand the following File Info panes:
# “General”, “Open with”, and “Sharing & Permissions”
defaults write com.apple.finder FXInfoPanesExpanded -dict \
  General -bool true \
  OpenWith -bool true \
  Privileges -bool true

# "Automatically open a new Finder window when a volume is mounted"
defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true

# Show item info near icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist

# Enable snap-to-grid for icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist

# Increase grid spacing for icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist

# Increase the size of icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:iconSize 40" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:iconSize 40" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:iconSize 40" ~/Library/Preferences/com.apple.finder.plist

# Remove Dropbox’s green checkmark icons in Finder
#file=/Applications/Dropbox.app/Contents/Resources/emblem-dropbox-uptodate.icns
#[ -e "${file}" ] && mv -f "${file}" "${file}.bak"

# Issue on macOS Mojave, for more info
# FIXME
# check https://github.com/mathiasbynens/dotfiles/issues/865
### show the ~/Library folder
# show extended attributes
#ls -la@e ~/
#xattr ~/Library
#xattr -p com.apple.FinderInfo ~/Library
#xattr -l ~/Library
# show extended attributes to copy / paste for restore with xattr -wx
#xattr -px com.apple.FinderInfo ~/Library
# delete all extended attributes
#xattr -c ~/Library
# delete specific extended attribute
if [[ $(xattr -l ~/Library | grep com.apple.FinderInfo) == "" ]]; then
  :
else
  xattr -d com.apple.FinderInfo ~/Library
fi
# set folder flag to not hidden
chflags nohidden ~/Library

# "Finder - Show the ~/Volumes folder."
# sudo chflags nohidden /Volumes

#defaults write com.apple.Finder AppleShowAllFiles -bool true # Finder: show hidden files by default

### undo show the ~/Library folder
# set extended attribute
#xattr -wx com.apple.FinderInfo "00 00 00 00 00 00 00 00 40 00 00 00 00 00 00 00
#00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00" ~/Library
#xattr -l ~/Library
#chflags hidden ~/Library
#ls -la@e ~/
