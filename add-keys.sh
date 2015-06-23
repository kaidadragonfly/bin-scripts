#!/bin/bash

DO_RUN=true
if [[ "$1" == '--batch' ]]; then
    DO_RUN="$(find "${HOME}/.ssh/auth_sock_var" -mmin +5)"
fi

# ssh-agent setup.
if [ "${SSH_AUTH_SOCK}" ] && [ "${DO_RUN}" ]; then
    echo "export SSH_AUTH_SOCK=${SSH_AUTH_SOCK}" > "${HOME}/.ssh/auth_sock_var"

    KEY_EXISTS=$(ssh-add -l | grep "${HOME}/[.]ssh/id_rsa")
    if [ -z "${KEY_EXISTS}" ]; then
        ssh-add ~/.ssh/id_rsa
    fi

    KEY_EXISTS=$(ssh-add -l | grep "${HOME}/[.]ssh/id_rsa_personal")
    if [ -z "${KEY_EXISTS}" ] && [ -f "${HOME}/.ssh/id_rsa_personal" ]; then
        echo
        ssh-add "${HOME}/.ssh/id_rsa_personal"
    fi
fi

