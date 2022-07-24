#!/bin/sh

# Check if running macOS
if ! [[ "$OSTYPE" =~ darwin* ]]; then
  echo "Sorry, this is meant to be run on macOS only"
  exit
fi

# helpers
function echo_ok { echo '\033[1;32m'"$1"'\033[0m'; }
function echo_warn { printf '\033[1;33m'"$1"'\033[0m'; }
function echo_error { echo '\033[1;31mERROR: '"$1"'\033[0m'; }
function run_script { cd ~ && source $HOME/.dotfiles/"$1"; }
function symlink { if [ ! -e "$2" ]; then ln -s $1 $2; fi; }

# Close any open System Preferences panes, to prevent them from overriding settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

# Keep-alive: update existing sudo time stamp until the script has finished
if test ! "$(command -v sudo)"; then
  echo_warn "The Script Require Root Access. Please Enter Your Password."
  sudo -v
  while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
  echo_ok "Done!"
fi

# XCode Command Line Tools from https://github.com/alrra/dotfiles/
echo_warn "Checking Xcode CLI tools..."
if ! xcode-select --print-path &>/dev/null; then
  xcode-select --install &>/dev/null
  until xcode-select --print-path &>/dev/null; do
    sleep 5 # Wait until the XCode Command Line Tools are installed
  done
  print_result $? ' XCode Command Line Tools Installed'
  sudo xcodebuild -license
  print_result $? 'Agree with the XCode Command Line Tools licence'
fi
echo_ok "Done!"

# Homebrew
if test ! "$(command -v brew)"; then
  echo_warn 'Installing Homebrew...'
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" &> /dev/null
  sudo chown -R $(whoami) .config
  sudo chown -R $(whoami) .gitconfig
  sudo chown -R $(whoami) $(brew --prefix)/*
  sudo chown -R $(whoami) /usr/local/*
  echo_ok "Done!"
fi

echo_warn "Installing packages..."
brew analytics off
mkdir -p ~/Library/Caches/Homebrew/Formula
# Otherwise might cuz trouble see : https://github.com/git-lfs/git-lfs/issues/2837
LANG=en_EN git lfs install
brew bundle install --no-lock --file=$PWD/tilde/Brewfile
# brew bundle install --no-lock --file=$HOME/.dotfiles/tilde/Brewfile

echo_warn "Cleaning Homebrew..."
brew doctor &> /dev/null
brew cleanup &> /dev/null
brew completions link &> /dev/null
echo_ok "Done!"

# Submodule stuff
cd ${HOME}/.dotfiles && git submodule update --init --recursive && cd ~

function prompt_user {
  echo_warn "\nDo you want to install $1 [y|N]"
  read response
  if [[ $response =~ (y|yes|Y) ]]; then
    run_script "$1"
    echo_ok "Done!"
  else
    echo_ok "Ok, skipped"
  fi
}

echo_warn 'Configuring vim...'
if [ ! -f "${HOME}/.vimrc" ]; then
  ln -sf ${HOME}/.dotfiles/vim-config/vimrc ${HOME}/.vimrc
fi
if [ ! -d "${HOME}/.config/nvim" ]; then
  mkdir ${HOME}/.config/nvim
fi
if [ ! -f "${HOME}/.config/nvim/init.vim" ]; then
  ln -s ${HOME}/.vimrc ${HOME}/.config/nvim/init.vim
fi
echo_ok "Done!"

if [ ! -f "${HOME}/.ssh/config" ]; then
  ln -s ${HOME}/tilde/ssh-config ${HOME}/.ssh/config
fi
if [ ! -f "${HOME}/.gnupg/gpg.conf" ]; then
  ln -s ${HOME}/tilde/gpg/gpg.conf ${HOME}/.gnupg/gpg.conf
fi
if [ ! -f "${HOME}/.gnupg/gpg-agent.conf" ]; then
  ln -s ${HOME}/tilde/gpg/gpg-agent.conf ${HOME}/.gnupg/gpg-agent.conf
fi
if [ ! -f "${HOME}/.hushlogin" ]; then
  ln -s ${HOME}/tilde/.hushlogin ${HOME}/.hushlogin
fi

prompt_user "utils/npm.sh"
prompt_user "utils/git-config.sh"
prompt_user "utils/zsh-config.sh"

# *******************************************************************

echo_warn 'Do you want to update apps preferences? [y|N]'
read response
if [[ $response =~ (y|yes|Y) ]]; then
  for file in ~/.dotfiles/apps/*
  do
    sh "$file"
  done
  echo_ok "Done!"
else
  echo_ok "Ok, skipped"
fi

# *******************************************************************

echo_warn 'Do you want to update the system security?'
prompt_user "settings/security.sh"
echo_ok "Done!"

# *******************************************************************

echo_warn 'Do you want to update the system configurations?'
prompt_user "settings/settings.sh"
echo_ok "Done!"

killall -HUP SystemUIServer

echo_warn "Almost done"
read -r -p "Do you wanna restart your mac to apply all changes ? [y|N] " response
if [[ -z $response || $response =~ ^(y|Y) ]]; then
  echo_warn "Restarting..."
  sudo fdesetup authrestart
  exit
fi
