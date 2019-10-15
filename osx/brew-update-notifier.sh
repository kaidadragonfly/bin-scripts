#!/usr/bin/env bash
#
# Notify of Homebrew updates via Notification Center on Mac OS X
#
# Author: Chris Streeter http://www.chrisstreeter.com
# Requires: terminal-notifier. Install with:
#   gem install terminal-notifier

BREW_EXEC='/usr/local/bin/brew'
TERMINAL_NOTIFIER=$(which terminal-notifier)
NOTIF_ARGS=(-activate com.apple.Terminal)

$BREW_EXEC update >/dev/null 2>/dev/null
outdated=$($BREW_EXEC outdated | tr ' ' '\n')

if [ -n "$outdated" ] ; then
    # We've got an outdated formula or two

    # Nofity via Notification Center
    if [ -e "$TERMINAL_NOTIFIER" ]; then
        lc=$(($(echo "$outdated" | wc -l)))
        outdated=$(echo "$outdated" | tail -$lc)
        message=$(echo "$outdated" | head -5)

        if [ "$outdated" != "$message" ]; then
            message="Some of the outdated formulae are: $message"
        else
            message="The following formulae are outdated: $message"
        fi
        # Send to the Nofication Center
        "$TERMINAL_NOTIFIER" "${NOTIF_ARGS[@]}" \
                             -title "Homebrew Update(s) Available" -message "$message"
    fi
fi
