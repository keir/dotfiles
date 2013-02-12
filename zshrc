# ==== Paths ==================================================================
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games

# On Mac OS X, the git installation I have ended up here.
export PATH=$PATH:/usr/local/git/bin

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

# Pick four colors at random, seeded by the hostname, when the shell is
# launched. Using all these colors in the prompt makes for a more distinct
# pattern for each host than only coloring one part of the prompt differently.
function get_host_color {
  python -c "
import random
import socket
random.seed(socket.gethostname())
for i in range($1): random.randint(0, 255)
print '%03d' % random.randint(0, 255)
"
}
c1="$FG[$(get_host_color 1)]"
c2="$FG[$(get_host_color 2)]"
c3="$FG[$(get_host_color 3)]"
c4="$FG[$(get_host_color 4)]"

PROMPT=""
PROMPT="$PROMPT%{$c1%}==== "
PROMPT="$PROMPT%{$fg_bold[white]%}%T "  # Time
PROMPT="$PROMPT%{$c2%}==== "
PROMPT="$PROMPT%{$fg_bold[white]%}%n"   # Username
PROMPT="$PROMPT%{$fg_bold[magenta]%}@"
PROMPT="$PROMPT%{$fg_bold[white]%}%m "  # Hostname
PROMPT="$PROMPT%{$c3%}==== "
PROMPT="$PROMPT%{$fg_bold[white]%}%d "  # Directory
PROMPT="$PROMPT%{$c4%}==== "
PROMPT="$PROMPT%{$fg_bold[green]%}\$(git_branch)  "
# Yes, the newline is necessary.
PROMPT="$PROMPT
"
# Show # for root, % for normal user.
# Show #/% in green for a successful command, red otherwise.
PROMPT="$PROMPT%(?.%{$fg_bold[green]%}.%{$fg_bold[red]%})%# "
PROMPT="$PROMPT%{$reset_color%}"

# ==== Aliases ================================================================
alias review='arc diff --verbatim --allow-untracked --reviewers'
