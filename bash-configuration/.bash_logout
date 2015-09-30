# ~/.bash_logout: executed by bash(1) when login shell exits.

# when leaving the console clear the screen to increase privacy

if [[ "${TERM_PROGRAM}" == 'Apple_Terminal' ]]; then
    killall 'cmd-key-happy'
fi

if [ "$SHLVL" = 1 ]; then
    [ -x /usr/bin/clear_console ] && /usr/bin/clear_console -q
fi

