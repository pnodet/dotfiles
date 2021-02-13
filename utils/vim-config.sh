#!/bin/sh

mkdir -p ~/.vim/pack/themes/start
mkdir -p ~/.config/nvim/themes


cd ~/.vim/pack/themes/start && git clone https://github.com/dracula/vim.git dracula

ln -sf ~/.dotfiles/vim-config/vimrc ${HOME}/.vimrc
ln -sf ~/.dotfiles/vim-config/init.vim ${HOME}/.config/nvim