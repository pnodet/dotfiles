#!/bin/sh

rm ${HOME}/.gitconfig
ln -sf ${HOME}/.dotfiles/git-config/.gitconfig ${HOME}/.gitconfig

if [ ! -f "${HOME}/.gitignore" ]; then
	ln -sf ${HOME}/.dotfiles/tilde/gitignore ${HOME}/.gitignore
fi

if [ ! -f "${HOME}/.gitattributes" ]; then
	ln -sf ${HOME}/.dotfiles/tilde/gitattributes ${HOME}/.gitattributes
fi

## Github
echo 'Checking for SSH key, generating one if it does not exist...'
if [ ! -f "${HOME}/.ssh/id_rsa.pub" ]; then
  ssh-keygen -t rsa -b 4096 -C "paul.nodet@gmail.com"
	echo 'Copy this public key to Github.com'
	cat ${HOME}/.ssh/id_rsa.pub
	open 'https://github.com/account/ssh'
	read -p "Press enter to continue"
fi

echo 'Test connection'
ssh -T git@github.com

# Git global config
git config --global user.name "pnxdxt"
git config --global user.email "paul.nodet@gmail.com"
git config --global github.user pnxdxt
git config --global core.excludesfile ${HOME}/.gitignore
