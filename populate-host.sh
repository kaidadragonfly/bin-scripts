#!/usr/bin/env bash

set -o verbose
ssh-copy-id "$1"
scp ~/.bashrc ~/.bash_aliases ~/.bash_exports ~/.bash_logout ~/.profile "$1":
