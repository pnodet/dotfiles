#!/bin/sh

# Paul Nodet
# paul.nodet@gmail.com
# ressources from various github users configs, thanks to http://dotfiles.github.io

function require_cask() {
    echo "brew cask $1"
    brew list $1 --cask >/dev/null 2>&1 | true
    if [[ ${PIPESTATUS[0]} != 0 ]]; then
        echo "brew install $1 $2 --cask"
        brew install $1 --cask
        if [[ $? != 0 ]]; then
            echo "failed to install $1! aborting..."
            # exit -1
        fi
    fi
}

declare -a brew_cask_apps=(
    'adobe-creative-cloud'
    #'amethyst'
    #'brave-browser'
    #'brooklyn'
    'dozer'
    #'dropbox'
    'discord'
    #'evernote'
    'firefox-developer-edition'
    #'fontbase'
    'github'
    'gitkraken'
    'google-chrome'
    'handbrake'
    #'hyper'
    'java'
    #'maccy'
    'microsoft-words'
    'microsoft-powerpoint'
    'microsoft-excel'
    'microsoft-teams'
    'rectangle'
    'signal'
    #'shifty'
    'slack'
    #'soulseek'
    'spotify'
    'transmission'
    #'vlc'
    'visual-studio-code'
    'whatsapp'
    #'intellij-idea'
    #'keepassxc'
    #'pomotroid'
    #'rocket'
    #'santa'
    #'sublime-text'
    #'sublime-merge'
    #'steam'
    'tor-browser'
    #'tunnelblick'
    #'viscosity'
    'iina'
    'webtorrent'
    #'xcode'
)

for app in "${brew_cask_apps[@]}"; do
    require_cask "$app"
done

##############################################################################################################

declare -a mas_apps=(
    'Pages'
    'Keynote'
    'Numbers'
    'Amphetamine'
    'The Unarchiver'
    'Tweetbot'
    'Messenger'
    'Helium'
)
#TODO : Adobe ?
#TODO : improve by making the signing process auto ?
echo "What's your Apple Store account?"
read ACCOUNT
echo "Enter the password for $ACCOUNT"
read -s PASSWORD
mas signin --dialog $ACCOUNT "$PASSWORD"

# App Installation with mas (source : https://github.com/argon/mas/issues/41#issuecomment-245846651)
function require_mas() {
    # Check if the App is already installed
    mas list | grep -i "$1" >/dev/null
    if [ "$?" == 0 ]; then
        echo "==> $1 is already installed"
    else
        echo "==> Installing $1..."
        mas search "$1" | {
            read app_ident app_name
            mas install "$app_ident"
        }
    fi
}

read -r -p "Are you signed in the App Store ? [y|n]] " response
if [[ $response =~ (yes|y|Y) ]]; then
    for app in "${mas_apps[@]}"; do
        require_mas "$app"
    done
else
    echo "skipped"
fi

# Pop corn time
#https://mirror06.popcorntime.app/build/Popcorn-Time-0.4.4.pkg
