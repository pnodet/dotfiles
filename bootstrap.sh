#!/bin/sh

# Check if running macOS
if ! [[ "$OSTYPE" =~ darwin* ]]; then
  echo "Sorry, this is meant to be run on macOS only"
  exit
fi

# helpers
function echo_ok { echo -e '\033[1;32m'"$1"'\033[0m'; }
function echo_warn { echo -e '\033[1;33m'"$1"'\033[0m'; }
function echo_error  { echo -e '\033[1;31mERROR: '"$1"'\033[0m'; }

function run_script() {
  cd ~ && source $HOME/.dotfiles/"$1"
}

# Close any open System Preferences panes, to prevent them from overriding settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

# Do we need to ask for sudo password or is it already passwordless?

grep -q 'NOPASSWD:     ALL' /etc/sudoers.d/$LOGNAME >/dev/null 2>&1
if [ $? -ne 0 ]; then
  echo_warn "The Script Require Root Access. Please Enter Your Password."
  sudo -v

  # Keep-alive: update existing sudo time stamp until the script has finished
  while true; do
    sudo -n true
    sleep 60
    kill -0 "$$" || exit
  done 2>/dev/null &

fi

# XCode Command Line Tools
# thanks to https://github.com/alrra/dotfiles/blob/ff123ca9b9b/os/os_x/installs/install_xcode.sh

echo "Installing Xcode CLI tools..."
if ! xcode-select --print-path &>/dev/null; then

  xcode-select --install &>/dev/null # Prompt user to install the XCode Command Line Tools

  until xcode-select --print-path &>/dev/null; do
    sleep 5 # Wait until the XCode Command Line Tools are installed
  done

  print_result $? ' XCode Command Line Tools Installed'
  # Prompt user to agree to the terms of the Xcode license
  # https://github.com/alrra/dotfiles/issues/10
  sudo xcodebuild -license
  print_result $? 'Agree with the XCode Command Line Tools licence'

fi

cd ~/.dotfiles && git pull --recurse-submodules

if test ! "$(command -v brew)"; then
  echo 'Installing Homebrew'
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  sudo chown -R $(whoami) $(brew --prefix)/*
  sudo chown -R $(whoami) .config
  sudo chown -R $(whoami) .gitconfig
fi
brew -v
brew analytics off

# Just to avoid a potential bug
mkdir -p ~/Library/Caches/Homebrew/Formula
brew doctor

linuxify_check_dirs() {
  result=0

  for dir in /usr/local/bin /usr/local/sbin; do
    if [[ ! -d $dir || ! -w $dir ]]; then
      echo "$dir must exist and be writeable"
      result=1
    fi
  done

  return $result
}

set -euo pipefail
linuxify_check_dirs

# install utils via brew bundle
brew bundle -f ~/.dotfiles/Brewfile
# allow mtr to run without sudo
mtrlocation=$(brew info mtr | grep Cellar | sed -e 's/ (.*//')
#  e.g. `/Users/paulirish/.homebrew/Cellar/mtr/0.86`
sudo chmod 4755 "$mtrlocation"/sbin/mtr
sudo chown root "$mtrlocation"/sbin/mtr

LANG=en_EN git lfs install #otherwise might cuz trouble see : https://github.com/git-lfs/git-lfs/issues/2837

# *******************************************************************

read -r -p "Install fonts? [y|N] " response
if [[ $response =~ (y|yes|Y) ]]; then
  brew bundle -f ~/.dotfiles/Brewfile-fonts
  echo "Done!"
else
  echo "skipped"
fi

# *******************************************************************

echo "node -v"
node -v
if [[ $? != 0 ]]; then
    echo "node not found, installing via homebrew"
    brew install node
    node -v
fi

sudo npm install npm@latest -g
npm -v

# Install npm packages globally without sudo on macOS
cd ~ && mkdir "${HOME}/.npm-packages"         # Create a directory for global packages
npm config set prefix "${HOME}/.npm-packages" # Tell npm where to store globally installed packages

# *******************************************************************

read -r -p "config zsh? [y|N] " response
if [[ $response =~ (y|yes|Y) ]]; then
  run_script "utils/zsh-config.sh"
  echo "Done!"
else
  echo "skipped"
fi

# *******************************************************************

read -r -p "config vim? [y|N] " response
if [[ $response =~ (y|yes|Y) ]]; then
  run_script "utils/vim-config.sh"
  echo "Done!"
else
  echo "skipped"
fi

# *******************************************************************

read -r -p "config git? [y|N] " response
if [[ $response =~ (y|yes|Y) ]]; then
  run_script "utils/git-config.sh"
  echo "Done!"
else
  echo "skipped"
fi

# *******************************************************************

read -r -p "config vscode? [y|N] " response
if [[ $response =~ (y|yes|Y) ]]; then
  run_script "utils/vscode-config.sh"
  echo "Done!"
else
  echo "skipped"
fi

# *******************************************************************

# TODO: Adobe ?
# TODO: improve by making the signing process auto ?

read -r -p "Install apps? If yes please login the App Store before ! [y|N] " response
if [[ $response =~ (y|yes|Y) ]]; then
  brew bundle -f ~/.dotfiles/apps/Brewfile
  echo "Done!"
else
  echo "skipped"
fi

# *******************************************************************

read -r -p "Do you want to update the system security? [y|n]] " response
if [[ $response =~ (yes|y|Y) ]]; then
  run_script "settings/01_security.sh"
  echo "Your security settings have been updated!"
else
  echo "skipped"
fi

# *******************************************************************

read -r -p "Do you want to update the system configurations? [y|n]] " response
if [[ $response =~ (yes|y|Y) ]]; then
  run_script "settings/02_settings.sh"
  echo "Your settings have been updated!"
else
  echo "skipped"
fi

# *******************************************************************

if groups "${USER}" | grep -q -w admin; then
  echo "${USER} is admin"
  read -r -p "Do you want to create an hidden admin user and demote this user? [y|n]] " response
  if [[ $response =~ (yes|y|Y) ]]; then
    run_script "settings/05_admin.sh"
    echo "ok"
  else
    echo "skipped"
  fi
else
  echo "${USER} is not admin"
fi

# *******************************************************************

echo "Almost done"
read -r -p "Do you wanna restart your mac to apply all changes ? [y|n] " response
if [[ -z $response || $response =~ ^(y|Y) ]]; then
  echo "Restarting..."
  sudo fdesetup authrestart
  exit
fi