#!/bin/bash

DO_RUN=true
if [[ "$1" == '--batch' ]]; then
    DO_RUN="$(find "${HOME}/.ssh/auth_sock_var" -mmin +5)"
fi

# ssh-agent setup.
if [ "${SSH_AUTH_SOCK}" ] && [ "${DO_RUN}" ]; then
    echo "export SSH_AUTH_SOCK=${SSH_AUTH_SOCK}" > "${HOME}/.ssh/auth_sock_var"

    KEYS=($(find "${HOME}/.ssh" -name 'id_rsa*' | grep -v '[.]pub$' | sort))

    for key in "${KEYS[@]}"; do
        KEY_EXISTS=$(ssh-add -l | grep "$key")
        if [ -z "${KEY_EXISTS}" ]; then
            ssh-add "$key"
        fi
    done
fi
