# Command line prompt: 2-line, shows directory, git branch, and time.
# Example:
#
#   keir@keir-macbookpro2:~/wrk/foo (git master) - - - - - - - - -  [00:19:14]
#   $
#
RESET="\[\033[0m\]"
RED="\[\033[0;31m\]"
GREEN="\[\033[01;32m\]"
BLUE="\[\033[01;34m\]"
YELLOW="\[\033[0;33m\]"
 
PS_LINE=`printf -- '==%.0s' {1..200}`
function parse_git_branch {
  PS_BRANCH=''
  PS_FILL=${PS_LINE:0:$COLUMNS}
  if [ -d .svn ]; then
    PS_BRANCH="(svn r$(svn info|awk '/Revision/{print $2}'))"
    return
  elif [ -f _FOSSIL_ -o -f .fslckout ]; then
    PS_BRANCH="(fossil $(fossil status|awk '/tags/{print $2}')) "
    return
  fi
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  PS_BRANCH="(git ${ref#refs/heads/}) "
}
PROMPT_COMMAND=parse_git_branch
PS_INFO="$GREEN\u@\h$RESET:$BLUE\w"
PS_GIT="$YELLOW\$PS_BRANCH"
PS_TIME="\[\033[\$((COLUMNS-10))G\] $RED[\t]"
export PS1="\${PS_FILL}\[\033[0G\]${PS_INFO} ${PS_GIT}${PS_TIME}\n${RESET}\$ "

# Include FZF extensions for bash; ultra-awesome Ctrl-R backwards search.
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
