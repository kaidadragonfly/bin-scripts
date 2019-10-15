#!/usr/bin/env bash

KEY_PATTERN='id_rsa*'

DO_RUN=true
if [[ "$1" == '--batch' ]]; then
    if [ -f "${HOME}/.ssh/auth_sock_var" ]; then
	DO_RUN="$(find "${HOME}/.ssh/auth_sock_var" -mmin +5)"
    else
	DO_RUN=true
    fi
fi

# ssh-agent setup.
if [ "${SSH_AUTH_SOCK}" ] && [ "${DO_RUN}" ]; then
    echo "export SSH_AUTH_SOCK=${SSH_AUTH_SOCK}" > "${HOME}/.ssh/auth_sock_var"

    KEYS="$(find "${HOME}/.ssh" -name "${KEY_PATTERN}" | grep -v '[.]pub$' | sort)"

    for key in ${KEYS}; do
        KEY_EXISTS=$(ssh-add -l | grep "$key")
        PRINT="$(ssh-keygen -lf "$key")"
        KEY_EXISTS="${KEY_EXISTS}$(ssh-add -l | grep "$PRINT")"

        if [ -z "${KEY_EXISTS}" ]; then
            if [[ "$(uname)" == 'Darwin' ]]; then
               ssh-add -K "$key"
            else
               ssh-add "$key"
            fi
        fi
    done
fi
