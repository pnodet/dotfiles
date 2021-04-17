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

function prompt_user() {
  printf "Do you want to install $1 [y|N]"
  read response
  if [[ $response =~ (y|yes|Y) ]]; then
    run_script "$1"
    echo_ok "Done!"
  else
    echo_ok "Ok, skipped"
  fi
}

# Close any open System Preferences panes, to prevent them from overriding settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

# Keep-alive: update existing sudo time stamp until the script has finished
echo_warn "The Script Require Root Access. Please Enter Your Password."
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# XCode Command Line Tools from https://github.com/alrra/dotfiles/
echo_warn "Installing Xcode CLI tools..."
if ! xcode-select --print-path &>/dev/null; then
  xcode-select --install &>/dev/null
  until xcode-select --print-path &>/dev/null; do
    sleep 5 # Wait until the XCode Command Line Tools are installed
  done
  print_result $? ' XCode Command Line Tools Installed'
  sudo xcodebuild -license
  print_result $? 'Agree with the XCode Command Line Tools licence'
fi

# Homebrew
if test ! "$(command -v brew)"; then
  echo_warn 'Installing Homebrew'
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  sudo chown -R $(whoami) $(brew --prefix)/*
  sudo chown -R $(whoami) .config
  sudo chown -R $(whoami) .gitconfig
fi

# Just to avoid a potential bug
brew -v
brew analytics off
mkdir -p ~/Library/Caches/Homebrew/Formula
brew doctor

linuxify_check_dirs() {
  result=0
  for dir in /usr/local/bin /usr/local/sbin; do
    if [[ ! -d $dir || ! -w $dir ]]; then
      echo_error "$dir must exist and be writeable"
      result=1
    fi
  done
  return $result
}

set -euo pipefail
linuxify_check_dirs

# *******************************************************************

# install utils via brew bundle
brew bundle -f ~/.dotfiles/Brewfile

# allow mtr to run without sudo
mtrlocation=$(brew info mtr | grep Cellar | sed -e 's/ (.*//')

# e.g. `/Users/paulirish/.homebrew/Cellar/mtr/0.86`
sudo chmod 4755 "$mtrlocation"/sbin/mtr
sudo chown root "$mtrlocation"/sbin/mtr

# Otherwise might cuz trouble see : https://github.com/git-lfs/git-lfs/issues/2837
LANG=en_EN git lfs install 

#Setting up QLColorCode
defaults write org.n8gray.QLColorCode textEncoding UTF-16
defaults write org.n8gray.QLColorCode webkitTextEncoding UTF-16
defaults write org.n8gray.QLColorCode font "Fira Code Pro"
defaults write org.n8gray.QLColorCode fontSizePoints 10
defaults write org.n8gray.QLColorCode hlTheme zenburn
defaults write org.n8gray.QLColorCode extraHLFlags "-W -J 160"
defaults write org.n8gray.QLColorCode pathHL /usr/local/bin/highlight

# Quicklook stuff
xattr -d -r com.apple.quarantine ~/Library/QuickLook
qlmanage -r

# Submodule stuff
cd ~/.dotfiles && git submodule update --init --recursive

# *******************************************************************

echo_warn 'This script will configure some global npm packages'
prompt_user "utils/npm.sh"
echo_ok "Done!" 

# *******************************************************************

echo_warn 'This script will configure zsh'
prompt_user "utils/zsh-config.sh"
echo_ok "Done!"

# *******************************************************************

echo_warn 'Configuring vim'
ln -sf ~/.dotfiles/vim-config/vimrc ${HOME}/.vimrc
ln -sf ~/.dotfiles/vim-config/init.vim ${HOME}/.config/nvim
echo_ok "Done!"

# *******************************************************************

echo_warn 'This script will configure git'
prompt_user "utils/git-config.sh"
echo_ok "Done!"

# *******************************************************************

echo_warn 'Configuring VS Code settings'
rm -rf ~/Library/Application\ Support/Code/User
ln -s ${HOME}/dotfiles/vscode-config ~/Library/Application\ Support/Code/User
echo_ok "Done!"

# *******************************************************************

# TODO: Adobe ?
# TODO: improve by making the signing process auto ?

read -r -p "Install apps? WARNING : If yes please login the App Store before ! [y|N] " response
if [[ $response =~ (y|yes|Y) ]]; then
  brew bundle -f ~/.dotfiles/apps/Brewfile
  echo_ok "Done!"
else
  echo_ok "skipped"
fi

# *******************************************************************

echo_warn 'Do you want to update the system security?'
prompt_user "settings/security.sh"
echo_ok "Done!"

# *******************************************************************

echo_warn 'Do you want to update the system configurations?'
prompt_user "settings/settings.sh"
echo_ok "Done!"

# *******************************************************************

if groups "${USER}" | grep -q -w admin; then
  echo_warn "${USER} is admin"
  read -r -p "Do you want to create an hidden admin user and demote this user? [y|N] " response
  if [[ $response =~ (yes|y|Y) ]]; then
    run_script "settings/admin.sh"
    echo_ok "ok"
  else
    echo_ok "skipped"
  fi
else
  echo "${USER} is not admin"
fi

# *******************************************************************

killall -HUP SystemUIServer

echo_warn "Almost done"
read -r -p "Do you wanna restart your mac to apply all changes ? [y|N] " response
if [[ -z $response || $response =~ ^(y|Y) ]]; then
  echo_warn "Restarting..."
  sudo fdesetup authrestart
  exit
fi