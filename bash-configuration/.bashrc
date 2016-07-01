# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything except add /usr/local/bin
if [ -z "$PS1" ]; then
    export PATH="/usr/local/bin:$PATH"
    return
fi

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace:erasedups

# Share history between terminals.
export PROMPT_COMMAND="history -a"
# append to the history file, don't overwrite it
shopt -s histappend

# Add ssh-keys.
if ([ -z "${SSH_CLIENT}" ] || [ -e "${HOME}/.treat-local" ]) \
       && [ -x "${HOME}/bin/add-keys.sh" ]; then
    export PROMPT_COMMAND="add-keys.sh --batch; ${PROMPT_COMMAND}"
fi

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

export TERM="xterm-256color"

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
    xterm-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

# shellcheck disable=SC2154
if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

function branch () {
    if [[ -x "$(which git-status-info)" ]]; then
        git-status-info
    fi
}

function c () {
    if [ "$(git branch 2> /dev/null)" ]; then
        echo -n ":"
    fi
}

function show_user () {
    # if ! [ -e "${HOME}/.oncall" ]; then
    whoami
    # fi
}

function show_host () {
    if [ -z "$(git branch 2> /dev/null)" ] \
           && ! [ -e "${HOME}/.oncall" ]; then
        echo -n "@$(hostname -s)"
    fi
}

if [ "$color_prompt" = yes ]; then
    if [ -n "${SSH_CLIENT}" ] && ! [ -e "${HOME}/.treat-local" ]; then
        usr_c="\033[0;33m"
    fi
    dir_c="\033[1;34m"
    git_c="\033[1;30m"
    no_c="\033[00m"
fi

# Configure prompt.
# Reboot needed?
# PS1=$PS1'\['${reboot_c}'\]$(show_reboot)\['${no_c}'\]'

PS1=''                                               # start
PS1=$PS1'['                                          # open-bracket
PS1=$PS1'\['${usr_c}'\]$(show_user)\['${no_c}'\]'    # user
PS1=$PS1'$(show_host)'                               # host
PS1=$PS1' \['${dir_c}'\]\W\['${no_c}'\]'             # directory
PS1=$PS1'$(c)\['${git_c}'\]$(branch)\['${no_c}'\]'   # version control
PS1=$PS1']'                                          # close-bracket
PS1=$PS1'\$ '                                        # dollar
unset color_prompt force_color_prompt


# If this is an xterm set the title to user@host:dir
case "$TERM" in
    xterm*|rxvt*)
        if [ ! "$INSIDE_EMACS" ]; then
            PS1="\[\e]0;\u@\h: \w\a\]$PS1"
        fi
        ;;
    *)
        ;;
esac

# Alias definitions.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# OSX specific definitions
if [ -f ~/.bash_osx ]; then
    . ~/.bash_osx
fi

# Machine local definitions.
if [ -f ~/.bash_local ]; then
    . ~/.bash_local
fi

# Enable bash completion.
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# Special `pushd` that emulates `cd`s behavior, but uses the directory stack.
cpushd () {
    if [ "$1" ]; then
        if [[ "$1" == "-" ]]
        then
            builtin popd > /dev/null
        else
            builtin pushd "$@" > /dev/null
        fi
    else
        builtin pushd ~ > /dev/null
    fi
}
#alias cd so it uses the directory stack
alias cd='cpushd'

# Don't expand ~username type directory specifications
# (expansion is the default.)
unset _expand

# Perform all other expansion.
_expand () {
    [ "$cur" != "${cur%\\}" ] && cur="$cur\\"

    # shellcheck disable=SC2031
    if [[ "$cur" == \~*/* ]]; then
        ( cd ~ || exit;
          eval dur="(${cur:2})";
          # shellcheck disable=SC2030,SC2154
          cur="${dur[*]/#/xxx}" );
    elif [[ "$cur" == \~* ]]; then
        cur=${cur#\~}
        COMPREPLY=( $( compgen -P '~' -u "$cur" ) )
        return ${#COMPREPLY[@]}
    fi
} # _expand()

unset __expand_tilde_by_ref

# Expands ~ in cd.
__expand_tilde_by_ref () {
    false # Do nothing.
} # __expand_tilde_by_ref()

# Allow C-s to search forward if you go too far with C-r.
stty -ixon

# Record every shell command.
if [ -z "${RECORDING}" ] && [ -e "${HOME}/.oncall" ]; then
    export RECORDING=true
    NOW="$(date '+%Y-%m-%d_%H.%m.%S.%3N')"
    ttyrec ".logs/${NOW}.log"
    exit
fi

if [ -x "$(which gpg-agent)" ] \
       && ! pgrep gpg-agent >/dev/null 2>/dev/null; then
    gpg-agent --daemon --default-cache-ttl 36000 --max-cache-ttl 36000
fi

GPG_TTY=$(tty)
export GPG_TTY

if [ -e "$HOME/.ssh-agent.env" ] && ! [ "$SSH_AUTH_SOCK" ]; then
    source "$HOME/.ssh-agent.env" >/dev/null
fi

if [ "${SSH_AGENT_PID}" ] \
       && [ -x "$(which ssh-agent)" ] \
       && ! ps "${SSH_AGENT_PID}" >/dev/null 2>/dev/null; then
    ssh-agent >"$HOME/.ssh-agent.env"
    source "$HOME/.ssh-agent.env" >/dev/null
fi
