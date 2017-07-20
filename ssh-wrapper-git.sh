#!/bin/bash

REALPATH=$(python -c "import os; print(os.path.realpath('$PWD'))")

# shellcheck disable=SC2029

case $REALPATH in
    $HOME/Developer/Socrata*)
        ssh -i "$GIT_SSH_WORK" "$@"
        ;;
    *)
        ssh -i "$GIT_SSH_PERSONAL" "$@"
esac
