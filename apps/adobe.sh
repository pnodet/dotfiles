#!/bin/sh

# Paul Nodet
# paul.nodet@gmail.com
# ressources from various github users configs, thanks to http://dotfiles.github.io

# Creative Cloud
#open /usr/local/Caskroom/adobe-creative-cloud/latest/Creative Cloud Installer.app/

# Open Creative Cloud Installer app
app_path="$(brew cask info adobe-creative-cloud | awk '$1~/^\// {print $1}')/Creative Cloud Installer.app"
open -a "$app_path"

# Hide crufty Application folders
sudo chflags -v hidden /Applications/Adobe
sudo chflags -v hidden /Applications/Adobe*/Configuration
sudo chflags -v hidden /Applications/Adobe*/Resources
sudo chflags -v hidden /Applications/Utilities/Adobe*

# Remove Legal cruft
rm -rf /Applications/Adobe*/Legal* 2>/dev/null

# Remove uninstaller aliases
rm /Applications/Adobe*/Uninstall* 2>/dev/null
