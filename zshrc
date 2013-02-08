# ==== Prompt =================================================================

# Gives the $fg_bold[color] variables for use in the prompt.
autoload -U colors && colors

# Expand the prompt with normal ZSH variable expansion before prompt-ifying.
setopt prompt_subst

# Print the current branch, or nothing if not on a branch.
git_branch() {
 if [ -d .git ] ; then
   git symbolic-ref HEAD | cut -d'/' -f3
 fi
}

PROMPT=""
PROMPT="$PROMPT%{$fg_bold[cyan]%}===="
PROMPT="$PROMPT%{$fg_bold[cyan]%}=== "
PROMPT="$PROMPT%{$fg_bold[white]%}%T "  # Time
PROMPT="$PROMPT%{$fg_bold[cyan]%}=== "
PROMPT="$PROMPT%{$fg_bold[white]%}%n"   # Username
PROMPT="$PROMPT%{$fg_bold[magenta]%}@"
PROMPT="$PROMPT%{$fg_bold[white]%}%m "  # Hostname
PROMPT="$PROMPT%{$fg_bold[cyan]%}=== "
PROMPT="$PROMPT%{$fg_bold[white]%}%d "  # Directory
PROMPT="$PROMPT%{$fg_bold[green]%}\$(git_branch)  "
# Yes, the newline is necessary.
PROMPT="$PROMPT
"
# Show # for root, % for normal user.
# Show #/% in green for a successful command, red otherwise.
PROMPT="$PROMPT%(?.%{$fg_bold[green]%}.%{$fg_bold[red]%})%# "
PROMPT="$PROMPT%{$reset_color%}"

# ==== Paths ==================================================================
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games

# ==== Aliases ================================================================
alias review='arc diff --verbatim --allow-untracked --reviewers'
