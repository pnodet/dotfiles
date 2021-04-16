#!/bin/sh

# Paul Nodet
# paul.nodet@gmail.com
# ressources from various github users configs, thanks to http://dotfiles.github.io

###############################################################################
# Terminal                                                                    #
###############################################################################

# Only use UTF-8 in Terminal.app
defaults write com.apple.terminal StringEncodings -array 4

# Enable “focus follows mouse” for Terminal.app and all X11 apps
# i.e. hover over a window and start typing in it without clicking first
defaults write com.apple.terminal FocusFollowsMouse -bool true
#defaults write org.x.X11 wm_ffm -bool true

# Enable Secure Keyboard Entry in Terminal.app
# See: https://security.stackexchange.com/a/47786/8918
defaults write com.apple.terminal SecureKeyboardEntry -bool true

# Disable the annoying line marks
defaults write com.apple.Terminal ShowLineMarks -int 0

# Setup terminal Snazzy theme
echo "change terminal theme for Snazzy"
cd ~/Downloads && curl https://raw.githubusercontent.com/sindresorhus/terminal-snazzy/master/Snazzy.terminal > Snazzy.terminal && open Snazzy.terminal
sleep 2 # Wait a bit to make sure the theme is downloaded
defaults write com.apple.terminal 'Default Window Settings' -string 'Snazzy'
defaults write com.apple.terminal 'Startup Window Settings' -string 'Snazzy'
