#!/bin/sh

cd ~ && ln -sf ${HOME}/dotfiles/git-config/.gitconfig ${HOME}/.gitconfig

## Github
# TODO: setup ssh : use this from https://gist.github.com/kevinelliott/7152e00d6567e223902a4775b5a0a0be

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