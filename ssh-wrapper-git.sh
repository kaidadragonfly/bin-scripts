#!/bin/bash

REALPATH=$(python -c "import os; print(os.path.realpath('$PWD'))")

case $REALPATH in
    $HOME/Developer/Socrata*)
        ssh -i ~/.ssh/id_rsa_work "$@"
        ;;
    *)
        ssh -i ~/.ssh/id_rsa_github "$@"
esac
