#!/bin/sh

# Installs dotfiles into your home directory via links.
ln -f -s `pwd`/vimrc ~/.vimrc
ln -f -s `pwd`/zshrc ~/.zshrc
ln -f -s `pwd`/gitconfig ~/.gitconfig
ln -f -s `pwd`/tmux.conf ~/.tmux.conf
