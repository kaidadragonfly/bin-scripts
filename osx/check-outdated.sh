#!/usr/bin/env bash

if [ -x /opt/homebrew/bin/brew ]; then
    BREW=/opt/homebrew/bin/brew
fi

if [ -x /usr/local/bin/brew ]; then
    BREW=/usr/local/bin/brew
fi

$BREW outdated > "$HOME"/.brew_outdated
