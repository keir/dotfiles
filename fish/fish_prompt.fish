set -g __fish_git_prompt_show_informative_status 1
set -g __fish_git_prompt_showcolorhints 1

function fish_prompt --description 'Write out the prompt'
    set -l last_status $status

    function _kprompt_maincolor
      set_color --bold fff
    end

    function _kprompt_separator
      set_color -b 936
      printf '   '
      set_color normal
    end

    _kprompt_separator

    # Prompt element: hostname.
    _kprompt_maincolor
    printf ' %s' (whoami)
    printf '@'
    printf '%s ' (hostname|cut -d . -f 1)

    _kprompt_separator

    # Prompt element: directory.
    _kprompt_maincolor

    # If current dir is not writable display it in red
    if not [ -w (pwd) ]
        set_color red
    end
    printf ' %s' (pwd)

    # Prompt element: git status.
    _kprompt_maincolor

    printf '%s ' (__fish_git_prompt)

    _kprompt_separator

    # Second line

    # Prompt element: > marker and return code
    echo
    if not test $last_status -eq 0
        set_color $fish_color_error
        printf '[%d] ' $last_status
    else 
        set_color green
    end

    printf '> '
    set_color normal
end
