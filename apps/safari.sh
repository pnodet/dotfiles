#!/bin/sh

# Paul Nodet
# paul.nodet@gmail.com
# ressources from various github users configs, thanks to http://dotfiles.github.io

###############################################################################
# Safari & WebKit                                                             #
###############################################################################

# remove downloads list items
# 0 = manually
# 1 = when safari quits
# 2 = upon successful download
# 3 = after a day
defaults write com.apple.Safari DownloadsClearingPolicy -int 3

# open pages in tabs instead of windows
# 0 = never
# 1 = automatically
# 2 = always
defaults write com.apple.Safari TabCreationPolicy -int 1

defaults write com.apple.Safari HomePage -string "about:blank"           # Safari - Set home page to 'about:blank' for faster loading.
defaults write com.apple.Safari AlwaysRestoreSessionAtLaunch -bool false # Safari opens with: a new window
defaults write com.apple.Safari NewWindowBehavior -int 1                 # new windows open with: empty page
defaults write com.apple.Safari NewTabBehavior -int 1                    # new tabs open with: empty page

defaults write com.apple.Safari PreloadTopHit -bool false                # preload top hit in the background
defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true # Show the full URL in the address bar (note: this still hides the scheme)
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false        # Prevent Safari from opening ‘safe’ files automatically after downloading
defaults write com.apple.Safari ProxiesInBookmarksBar "()"               # Remove useless icons from Safari’s bookmarks bar
defaults write com.apple.Safari ShowSidebarInTopSites -bool false        # Hide Safari’s sidebar in Top Sites

defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false # Safari - Use Contains instead of Starts With in search banners.
defaults write com.apple.Safari DebugSnapshotsUpdatePolicy -int 2           # Disable Safari’s thumbnail cache for History and Top Sites
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true              # Safari - Add a context menu item for showing the Web Inspector in web views.

defaults write com.apple.Safari WebKitStorageBlockingPolicy -int 1     # Prevent cross-site tracking- options : 0 = no; 1 = yes
defaults write com.apple.Safari SendDoNotTrackHTTPHeader -bool true    # do not get tracked
defaults write com.apple.Safari WarnAboutFraudulentWebsites -bool true # warn about fraudulent websites
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true    # Safari - Enable debug menu.

# Privacy: don’t send search queries to Apple
#TODO : Redundant :
defaults write com.apple.Safari.plist UniversalSearchEnabled -bool NO
defaults write com.apple.Safari UniversalSearchEnabled -bool false

#TODO: Redundant :
defaults write com.apple.Safari SuppressSearchSuggestions -bool true
defaults write com.apple.Safari.plist SuppressSearchSuggestions -bool YES
#
defaults write com.apple.Safari.plist WebsiteSpecificSearchEnabled -bool NO

# Press Tab to highlight each item on a web page
defaults write com.apple.Safari WebKitTabToLinksPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2TabsToLinks -bool true

# Use Backspace/Delete to Go Back a Page
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2BackspaceKeyNavigationEnabled -bool YES

# Hide Safari’s bookmarks bar by default
defaults write com.apple.Safari ShowFavoritesBar -bool false
#defaults write com.apple.Safari ShowFavoritesBar-v2 -bool true

# days of keeping history
# defaults write com.apple.Safari HistoryAgeInDaysLimit -int 1

# enable java
defaults write com.apple.Safari WebKitJavaEnabled -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaEnabled -bool true

# enable javaScript
defaults write com.apple.Safari WebKitJavaScriptEnabled -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaScriptEnabled -bool true

# Safari - Enable the Develop menu and the Web Inspector.
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true
