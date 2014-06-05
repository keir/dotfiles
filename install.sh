#!/bin/sh
set -x
set -u

cd

if [ ! -d dotfiles ] ; then
  git clone git@github.com:keir/dotfiles.git
fi

cd dotfiles

# TODO: Install git, curl, zsh, vim if necessary.

# Installs dotfiles into your home directory via links, overwriting whatever
# else is there.
ln -f -s `pwd`/vimrc ~/.vimrc
ln -f -s `pwd`/vim ~/.vim
ln -f -s `pwd`/zshrc ~/.zshrc
ln -f -s `pwd`/gitconfig ~/.gitconfig
ln -f -s `pwd`/tmux.conf ~/.tmux.conf
