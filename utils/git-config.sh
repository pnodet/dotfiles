#!/bin/sh

ln -sf ${HOME}/.dotfiles/git-config/.gitconfig ${HOME}/.gitconfig

## Github
# TODO: setup ssh : use this from https://gist.github.com/kevinelliott/7152e00d6567e223902a4775b5a0a0be

#Generate new ssh-key
#$ ssh-keygen -t rsa -b 4096 -C "paul.nodet@gmail.com"

# Copy public key to Github.com
#cat ~/.ssh/id_rsa.pub

# Test connection
#ssh -T git@github.com

#pub=$HOME/.ssh/id_ed25519.pub
#echo 'Checking for SSH key, generating one if it does not exist...'
#[[ -f $pub ]] || ssh-keygen -t ed25519

#echo 'Copying public key to clipboard. Paste it into your Github account...'
#[[ -f $pub ]] && cat $pub | pbcopy
#open 'https://github.com/account/ssh'

# Git global config
#git config --global user.name "Paul Nodet"
#git config --global user.email "paul.nodet@gmail.com"
#git config --global github.user pnodet
#git config --global github.token your_token_here

#git config --global core.editor "code -w"
#git config --global color.ui true

##############################################################################################################


# github.com/jamiew/git-friendly
# the `push` command which copies the github compare URL to my clipboard is heaven
# sh -c "$(curl https://raw.github.com/jamiew/git-friendly/master/install.sh)"

# speed up git status (to run only in chromium repo)
#git config status.showuntrackedfiles no
#git update-index --untracked-cache

# faster git server communication.
# TODO
# like a LOT faster. https://opensource.googleblog.com/2018/05/introducing-git-protocol-version-2.html
#git config protocol.version 2

# NICE UTILS FROM https://github.com/mhartl/git-utils
#sudo gem install git-utils