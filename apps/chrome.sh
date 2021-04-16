#!/bin/sh

# Paul Nodet
# paul.nodet@gmail.com
# ressources from various github users configs, thanks to http://dotfiles.github.io

###############################################################################
# Chrome                                                                      #
###############################################################################

# "Chrome - Prevent native print dialog, use system dialog instead."
defaults write com.google.Chrome DisablePrintPreview -boolean true

# TODO : doesn't work on macOS Mojave,
# check for more info : https://apple.stackexchange.com/questions/338313/how-can-i-enable-backspace-to-go-back-in-safari-on-mojave
# "Allow hitting the Backspace key to go to the previous page in history"
# defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2BackspaceKeyNavigationEnabled -bool true;
