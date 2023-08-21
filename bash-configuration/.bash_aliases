#!/bin/bash
# Import exports
if [ -f ~/.bash_exports ]; then
    . ~/.bash_exports
fi

# Enable color support of ls and grep.
if [ -x /usr/bin/dircolors ]; then
    (test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)")\
        || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias l.='ls --directory .*'

alias emacs='emacs -nw'
alias hgit='git --git-dir=.home.git/ '
alias nh='nohup >/dev/null 2>/dev/null'
alias gitg='gitg &'
alias simonsays='sudo'
alias please='sudo'
alias cdiff='git diff --color --no-index'
alias dc='git diff --color --no-index'
alias rg="rg --smart-case"
alias python='python3'

function cdf() {
    if [ "$1" ]; then
        cd "$(find-dir "$1")" || exit 1
    else
        echo "usage: cdf dirname ['in' path]"
    fi
}

function cdr() {
    cd "$(proj-root "$1")" || exit 1
}

alias gf='git-fuzzy'
# alias 2fa='oathtool --base32 --totp'
alias utcnow='date -u -Iseconds '
alias open='xdg-open'

# These are functions so that they work from within "loop"
function rake() {
    bundle-wrapper rake "$@"
}

function rails() {
    bundle-wrapper rails "$@"
}

function guard() {
    bundle-wrapper guard "$@"
}

# Git aliases
# [alias]
#     dw = diff --color-words --word-diff-regex='[A-z0-9_]+|[^[:space:]]'
#     tree = log --all --graph --pretty='format:%h (%an) %s'

# alias fanficfare='calibre-debug --run-plugin FanFicFare --'

alias run='gio launch '

function xremap() {
    sleep 1 && nohup "${HOME}/.cargo/bin/xremap" "${HOME}/.xremap-config.yml" >/tmp/xremap.log &
    disown
}

