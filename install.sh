#!/bin/bash
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
ln -f -s `pwd`/bashrc ~/.bashrc
ln -f -s `pwd`/gitconfig ~/.gitconfig
ln -f -s `pwd`/tmux.conf ~/.tmux.conf

mkdir -p ~/.ipython/profile_default/
ln -f -s `pwd`/ipython_config.py ~/.ipython/profile_default/ipython_config.py

# Install sensible behaviour for home/end on macOS.
# See: http://cobus.io/osx/2017/02/09/OSX_Home_End_Keys.html
#      https://damieng.com/blog/2015/04/24/make-home-end-keys-behave-like-windows-on-mac-os-x
if [ "$(uname)" == "Darwin" ] ; then
  mkdir -p ~/Library/KeyBindings
  ln -s `pwd`/DefaultKeyBinding.dict $HOME/Library/KeyBindings/
fi

# Fix Visual Studio Code key repeat for Vim emulation.
#
# Apple has a feature that breaks key repeat in Vim and VSCode; disable it. For
# more details, see the VSCode Vim plugin page:
#
#   https://github.com/VSCodeVim/Vim#mac-setup
#
if [ "$(uname)" == "Darwin" ] ; then
  defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false
fi
