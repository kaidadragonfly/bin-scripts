#!/usr/bin/env bash
# Adds your key before doing a git ssh operation.

add-keys.sh
ssh "$@"
