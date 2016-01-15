#!/bin/bash
# Import exports
if [ -f ~/.bash_exports ]; then
    . ~/.bash_exports
fi

# Enable color support of ls and grep.
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
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

# A few custom aliases.  
alias emacs='emacs -nw'
alias open='xdg-open'
alias hgit='git --git-dir=.home.git/ '
alias nh='nohup >/dev/null 2>/dev/null'
alias gitg='gitg &'
alias simonsays='sudo'
alias please='sudo'
alias dc='git diff --color --no-index'
alias dw="git diff --color-words --no-index --word-diff-regex='[A-z0-9_]+|[^[:space:]]'"
alias cdr='cd $(proj-root)'

function cdf() {
    if [ "$1" ]; then
        cd "$(find-dir "$1")"
    else
        echo "usage: cdf dirname ['in' path]"
    fi       
}

alias gf='git-fuzzy'

# Git aliases
# [alias]
#     dw = diff --color-words --word-diff-regex='[A-z0-9_]+|[^[:space:]]'
#     tree = log --all --graph --pretty='format:%h (%an) %s'

