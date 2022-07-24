#!/bin/sh

# Make sure you are using zsh
if test ! "$(command -v zsh)"; then
	chsh -s /bin/zsh
fi

# remove old zsh files if
rm -rf ${HOME}/.zsh-config
rm -rf ${HOME}/.zinit
rm -rf ${HOME}/.zlogin
rm -rf ${HOME}/.zprofile
rm -rf ${HOME}/.zshenv
rm -rf ${HOME}/.zshrc

# get to the home folder link zsh-config to home
ln -sf ${HOME}/.dotfiles/zsh-config ${HOME}/.zsh-config
# then link the startup files
zsh ${HOME}/.zsh-config/bootstrap.sh

if [ ! -d "${HOME}/.config" ]; then
  mkdir -p ~/.config
fi

if [ ! -f "${HOME}/.config/starship.toml" ]; then
	ln -s ~/.dotfiles/tilde/starship.toml ~/.config/
fi
