#!/bin/sh

# Installs dotfiles into your home directory via links.
ln -s `pwd`/vimrc ~/.vimrc
ln -s `pwd`/zshrc ~/.zshrc
ln -s `pwd`/gitconfig ~/.gitconfig
ln -s `pwd`/tmux.conf ~/.tmux.conf
