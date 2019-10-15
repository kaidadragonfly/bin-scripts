#!/usr/bin/env bash

function prompt_command {
    (( prompt_x=COLUMNS-5 ))
}

PROMPT_COMMAND=prompt_command

function clock {
    local       BLUE="\[\033[0;34m\]"
    local  LIGHT_RED="\[\033[1;31m\]"
    local      WHITE="\[\033[1;37m\]"
    local  NO_COLOUR="\[\033[0m\]"
    case $TERM in
        xterm*)
            TITLEBAR='\[\033]0;\u@\h:\w\007\]'
            ;;
        *)
            TITLEBAR=""
            ;;
    esac

    PS1="${TITLEBAR}\
\[\033[s\033[1;\$(echo -n \${prompt_x})H\]\
$BLUE\[$LIGHT_RED\$(date +%H%M)$BLUE]\[\033[u\033[1A\]
$BLUE\[$LIGHT_RED\u@\h:\w$BLUE]\
$WHITE\$$NO_COLOUR "
    PS2='> '
    PS4='+ '
}
