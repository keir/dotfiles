# Copyright (c) 2014 Keir Mierle
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

OPERATING_SYSTEM=$(uname)

# ==== Options ================================================================

# Enable support for stuff like e.g. 'ls *^(a|b)' for negated globs.
setopt extended_glob

# Change into directories just with their name (no "cd" necessary).
setopt autocd

# Always push directories to the stack. Best used in conjunction with 'sd'
# (search directories) command that uses FZF to look at previous directories
# and pick one.
setopt autopushd

# ==== History ================================================================

# Store starting and ending timestamps for every command in the history.
setopt extended_history

# Don't execute immediately when doing history substitution.
setopt hist_verify

# Don't truncate existing history file when full; rename first to <hist>.new.
setopt hist_save_by_copy

# Don't make history entries for subsequent duplicate commands. Does not alter
# previous history commands that are duplicated (e.g. 'make; make; make' ->
# 'make', but 'make; ls; make' would be unchanged).
setopt hist_ignore_dups

# Do not display a line previously found.
setopt hist_find_no_dups

# We DO want to save multiple lines for multi-line commands.
unsetopt hist_reduce_blanks

# Append history to a shared file, after commands complete. Also attach the
# time to execute each command. Exclusive with options: inc_append_history,
# append_history, and share_history.
unsetopt append_history
unsetopt inc_append_history
unsetopt inc_append_history_time
setopt share_history

export HISTFILE=$HOME/.zsh-history
export HISTSIZE=1000000  # A million should be enough.
export SAVEHIST=1000000

# ==== Paths ==================================================================
function append_path {
  export PATH=$PATH:$1
}

# First appended paths are searched first.
append_path $HOME/wrk/phabricator/arcanist/bin
append_path $HOME/dotfiles/bin
append_path $HOME/bin

# For Rust's Cargo package manager.
append_path $HOME/.cargo/bin

# For pipsi.
append_path $HOME/.local/bin

append_path /usr/local/sbin
append_path /usr/local/bin
append_path /usr/sbin
append_path /usr/bin
append_path /sbin
append_path /bin

if [[ $OPERATING_SYSTEM == 'Darwin' ]] ; then
  # The Mac OS X Git installer puts Git here.
  append_path /usr/local/git/bin

  # Pip installed binaries go here.
  append_path /usr/local/share/python
fi

# ==== Editors ================================================================

export EDITOR=vim

# If EDITOR=vim, zsh assumes you also want Vim style keybindings on the command
# line. Since I don't want that, explicitly set Emacs style bindings.
bindkey -e

# ==== Colors =================================================================
# Make using 256 colors less annoying. This adds the variables $FG[color],
# $BG[color], and $FX[effect] to make colorizing easier. The color value must
# be a zero-padded number (always 3 digits).

typeset -Ag FX FG BG

FX=(
  reset     "[00m"
  bold      "[01m" no-bold      "[22m"
  italic    "[03m" no-italic    "[23m"
  underline "[04m" no-underline "[24m"
  blink     "[05m" no-blink     "[25m"
  reverse   "[07m" no-reverse   "[27m"
)

for color in {000..255}; do
  FG[$color]="[38;5;${color}m"
  BG[$color]="[48;5;${color}m"
done

# ==== Prompt =================================================================

# Gives the $fg_bold[color] variables for use in the prompt.
autoload -U colors && colors

# Expand the prompt with normal ZSH variable expansion before prompt-ifying.
setopt prompt_subst

# Print the current branch, or nothing if not on a branch.
git_branch() {
  git symbolic-ref HEAD 2> /dev/null | cut -d'/' -f3
}

# Find a Python; try for Python3 first.
zsh_prompt_python=$(which python3)
if ! [ -x "${zsh_prompt_python}" ] ; then
  zsh_prompt_python=python
fi

# Pick four colors at random, seeded by the hostname, when the shell is
# launched. Using all these colors in the prompt makes for a more distinct
# pattern for each host than only coloring one part of the prompt differently.
function get_host_color {
  ${zsh_prompt_python} -c "
from __future__ import print_function
import random
import socket
random.seed(socket.gethostname())
for i in range($1):
  random.randint(0, 255)
print('%03d' % random.randint(0, 255))
"
}

c1="$FG[$(get_host_color 1)]"
c2="$FG[$(get_host_color 2)]"
c3="$FG[$(get_host_color 3)]"
c4="$FG[$(get_host_color 4)]"

PROMPT=""
PROMPT="$PROMPT%{$c1%}==== "
PROMPT="$PROMPT%{$fg_bold[white]%}%* "  # Time
PROMPT="$PROMPT%{$c2%}==== "
PROMPT="$PROMPT%{$fg_bold[white]%}%n"   # Username
PROMPT="$PROMPT%{$fg_bold[magenta]%}@"
PROMPT="$PROMPT%{$fg_bold[white]%}%m "  # Hostname
PROMPT="$PROMPT%{$c3%}==== "
PROMPT="$PROMPT%{$fg_bold[white]%}%~ "  # Directory
PROMPT="$PROMPT%{$c4%}==== "
PROMPT="$PROMPT%{$fg_bold[green]%}\$(git_branch)  "
# Yes, the newline is necessary.
PROMPT="$PROMPT
"
# Show # for root, % for normal user.
# Show #/% in green for a successful command, red otherwise.
PROMPT="$PROMPT%(?.%{$fg_bold[green]%}.%{$fg_bold[red]%})%# "
PROMPT="$PROMPT%{$reset_color%}"

# Set the terminal title; set the window name for tmux and screen.
function auto_terminal_title {
  # Doing this with basename and pwd doesn't work due to paths with spaces.
  ${zsh_prompt_python} -c 'import os; print(os.path.basename(os.getcwd()))'
}

function auto_terminal_title {
  ${zsh_prompt_python} -c "
from __future__ import print_function
import os
print(os.path.basename(os.getcwd()))
"
}

case $TERM in
  xterm*)
    precmd () {
      print -Pn "\e]0;$(auto_terminal_title)\a"
    }
    ;;
  screen*)
    # This also works for tmux.
    precmd() {
      print -Pn "\033k$(auto_terminal_title)\033\\"
    }
    ;;
esac

# ==== Aliases ================================================================

# Normal aliases.
if [[ $OPERATING_SYSTEM == 'Darwin' ]] ; then
  alias ls='ls -G'
  alias ll='ls -l -G'
else
  # Linux
  alias ls='ls --color'
  alias ll='ls -l --color'
fi

# Typo aliases.
alias sl=ls
alias gerp=grep

function vf() {
  vim $($HOME/.fzf/bin/fzf)
}

function gvf() {
  gvim $($HOME/.fzf/bin/fzf)
}

# It's hard to kick the habit of typing "gvim" instead of "mvim".
if [[ $OPERATING_SYSTEM == 'Darwin' ]] ; then
  alias gvim='mvim'
fi

# Interactive change directory with FZF. Uses your directory stack to pick the
# directory. For some reason this only works as an alias.
alias sd='cd $(dirs -lp | uniq | $HOME/.fzf/bin/fzf --height=15)'

# Global aliases; these expand anywhere on the command line.

# Handy directory navigation.
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'

# Handy pipe operators; work at the end of a command, e.g. 'foo V'.
alias -g G='| grep'
alias -g H='| head'
alias -g T='| tail'
alias -g L='| less'
alias -g V='| vim -'

# Same as above, but combines stdout and stderr.
alias -g EG='|& grep'
alias -g EH='|& head'
alias -g ET='|& tail'
alias -g EL='|& less'
alias -g EV='|& vim -'

alias -g XG='| xargs grep'
alias -g X='| xargs'

# Git aliases.
alias gs='git status --short'
alias gst='git status --short'
alias gd='git diff'
alias gds='git diff --stat'
alias gdst='git diff --stat'
alias gcam='git commit -a -m'
alias gam='git commit -a --amend'
alias gc='git commit'
alias gcm='git commit -m'
alias gco='git checkout'
alias ga='git add'
alias grim='git rebase -i master'
alias grm='git rebase master'

# Apt aliases.
alias i='sudo apt-get install'
alias s='sudo apt-cache search'

# ==== Keybindings ============================================================

# Ctrl-space - print git status.
bindkey -s '^ ' 'git status --short^M'

# ==== Machine local config ===================================================
# All machine-local settings go in .zshrc-local.
if [[ -a "$HOME/.zshrc-local" ]] ; then
  source $HOME/.zshrc-local
fi

# Configure the Fuzzy File Finder (FZF) if present. Usually installed with
# :PlugInstall in vim first.
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
