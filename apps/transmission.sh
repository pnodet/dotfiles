#!/bin/sh

# Paul Nodet
# paul.nodet@gmail.com
# ressources from various github users configs, thanks to http://dotfiles.github.io

###############################################################################
# Transmission.                                                               #
###############################################################################

## General

defaults write org.m0k.transmission AutoSize -bool true               # Automatically size window to fit all transfers
defaults write org.m0k.transmission BadgeDownloadRate -bool false     # Download Badge
defaults write org.m0k.transmission BadgeUploadRate -bool false       # Upload Badge
defaults write org.m0k.transmission CheckRemoveDownloading -bool true # Prompt user for removal of active transfers only when downloading
defaults write org.m0k.transmission CheckQuitDownloading -bool true   # Prompt user for quit with active transfers only when downloading
defaults write org.m0k.transmission NSRequiresAquaSystemAppearance 0  # Force dark UI

## Transfers
mkdir -p "${HOME}/Documents/Torrents"
sudo chflags -h hidden "${HOME}/Documents/Torrents" # Hide incomplete downloads folder
defaults write org.m0k.transmission UseIncompleteDownloadFolder -bool true
defaults write org.m0k.transmission IncompleteDownloadFolder -string "${HOME}/Documents/Torrents"

# Default download location
mkdir "${HOME}/Documents/Movies"
defaults write org.m0k.transmission DownloadLocationConstant -bool true
defaults write org.m0k.transmission DownloadChoice -string "Constant"
defaults write org.m0k.transmission DownloadFolder -string "${HOME}/Documents/Movies"

# Don’t prompt for confirmation before downloading
defaults write org.m0k.transmission DownloadAsk -bool false
defaults write org.m0k.transmission MagnetOpenAsk -bool false

# Trash original torrent files
defaults write org.m0k.transmission DeleteOriginalTorrent -bool true

# Display window when opening a torrent file
defaults write org.m0k.transmission DownloadAskMulti -bool true
defaults write org.m0k.transmission DownloadAskManual -bool true

# Automatic Import
defaults write org.m0k.transmission AutoImport -bool true
defaults write org.m0k.transmission AutoImportDirectory -string "$HOME/Downloads/"

defaults write org.m0k.transmission RandomPort -bool true                   # Randomize port on launch
defaults write org.m0k.transmission WarningDonate -bool false               # Donate message
defaults write org.m0k.transmission WarningLegal -bool false                # Legal disclaimer
defaults write org.m0k.transmission StatusBar -bool true                    # Status bar
defaults write org.m0k.transmission SmallView -bool true                    # Small view
defaults write org.m0k.transmission PiecesBar -bool false                   # Pieces bar
defaults write org.m0k.transmission FilterBar -bool true                    # Pieces bar
defaults write org.m0k.transmission DisplayProgressBarAvailable -bool false # Availability
