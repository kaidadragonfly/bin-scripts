# If running bash:
if [ -n "$BASH_VERSION" ]; then
     # include .bashrc if it exists.
    if [ -f "$HOME/.bashrc" ]; then
        # shellcheck source=/dev/null
        . "$HOME/.bashrc"
    fi
fi
