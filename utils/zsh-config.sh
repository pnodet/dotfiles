#!/bin/sh

# Make sure you are using zsh 
chsh -s /bin/zsh

# get to the home folder move zsh config to home
ln -sf ~/.dotfiles/zsh-config ~/.zsh-config
# then link the startup files
zsh ~/.zsh-config/bootstrap.sh
# init plugins
zinit update
sleep 5