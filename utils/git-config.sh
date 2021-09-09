#!/bin/sh
rm ~/.gitconfig
ln -sf ~/.dotfiles/git-config/.gitconfig ~/.gitconfig
ln -sf ~/.dotfiles/tilde/.gitignore ~/.gitignore

## Github
# TODO: setup ssh : use this from https://gist.github.com/kevinelliott/7152e00d6567e223902a4775b5a0a0be

echo 'Checking for SSH key, generating one if it does not exist...'

# Generate new ssh-key
ssh-keygen -t rsa -b 4096 -C "paul.nodet@gmail.com"

echo 'Copy this public key to Github.com'
cat ~/.ssh/id_rsa.pub
open 'https://github.com/account/ssh'

echo 'Test connection'
ssh -T git@github.com

# Git global config
git config --global user.name "Paul Nodet"
git config --global user.email "paul.nodet@gmail.com"
git config --global github.user pnxdxt
#git config --global github.token your_token_here

git config --global core.excludesfile ~/.gitignore

##############################################################################################################

# github.com/jamiew/git-friendly
# the `push` command which copies the github compare URL to my clipboard is heaven
# sh -c "$(curl https://raw.github.com/jamiew/git-friendly/master/install.sh)"

# speed up git status (to run only in chromium repo)
#git config status.showuntrackedfiles no
#git update-index --untracked-cache

# NICE UTILS FROM https://github.com/mhartl/git-utils
#sudo gem install git-utils