#!/bin/sh
rm ~/.gitconfig
ln -sf ~/.dotfiles/git-config/.gitconfig ~/.gitconfig
ln -sf ~/.dotfiles/tilde/.gitignore ~/.gitignore

## Github
echo 'Checking for SSH key, generating one if it does not exist...'
if [ ! -f "~/.ssh/id_rsa.pub" ]; then
  ssh-keygen -t rsa -b 4096 -C "paul.nodet@gmail.com"
fi

echo 'Copy this public key to Github.com'
cat ~/.ssh/id_rsa.pub
open 'https://github.com/account/ssh'

echo 'Test connection'
ssh -T git@github.com

# Git global config
git config --global user.name "Paul Nodet"
git config --global user.email "paul.nodet@gmail.com"
git config --global github.user pnxdxt
git config --global core.excludesfile ~/.gitignore
