#!/bin/sh

mkdir ~/.config/nvim
mkdir ~/.config/nvim/themes

cd ~/.config/nvim/themes && git clone https://github.com/dracula/vim.git dracula

cd && ln -sf ~/.dotfiles/vim-config/vimrc ${HOME}/.vimrc
