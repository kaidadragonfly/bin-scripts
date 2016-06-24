# ~/.bash_logout: executed by bash(1) when login shell exits.

if [ "$(uname)" == 'Linux' ]; then
    # Kill ssh-agent if this is the last session.
    NUM_TTYS=$(ps axno user,tty | awk '$1 >= 1000 && $1 < 65530 && $2 != "?"' | sort -u | sed 's/^ *//' | cut -d' ' -f1 | grep -c "^${UID}\$")

    if [ "$NUM_TTYS" -eq 1 ]; then
        touch killed-all-agents
        killall ssh-agent
    fi
fi
