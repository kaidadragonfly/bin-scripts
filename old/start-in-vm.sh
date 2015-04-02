#!/bin/bash

if [ -z "$1" ]; then
    echo "Elastic Search Address Required!"
    exit 1
fi

DOCKER_VM_HOST='harbor'

PROJ_NAME='spandex-http'
SUB_PROJECT=${PROJ_NAME}
PORT=8042

ENVFILE="/tmp/${PROJ_NAME}-env"     # This is the boot2docker vm path.
PROJ_ROOT="$(git rev-parse --show-toplevel 2>/dev/null)/${SUB_PROJECT}"

cp ${PROJ_ROOT}/target/scala*/${PROJ_NAME}-assembly*.jar \
   ${PROJ_ROOT}/docker/${PROJ_NAME}-assembly.jar \
    || { echo "Failed to copy assembly jar"; exit; }

# VBoxManage sharedfolder add 'harbor' \
#            --name "${PROJ_NAME}-docker" \
#            --hostpath "$PROJ_ROOT/docker" \
#            --automount 2>/dev/null

ssh ${DOCKER_VM_HOST} <<EOF
    docker stop $(docker ps --quiet)
    mkdir -p ${PROJ_NAME}-docker
    sudo mount -t vboxsf -o uid=1000,gid=50 ${PROJ_NAME}-docker ${PROJ_NAME}-docker || { echo "failed to mount!"; exit 1; }
    cd ${PROJ_NAME}-docker
    docker build --no-cache --rm -t ${PROJ_NAME} .
    echo "SPANDEX_SECONDARY_ES_HOST=$1" > ${ENVFILE}
    sed -i 's/\[/["/' ${ENVFILE}
    sed -i 's/, /", "/g' ${ENVFILE}
    sed -i 's/]/"]/' ${ENVFILE}
    echo starting ${PROJ_NAME}
    docker run --env-file=${ENVFILE} -p ${PORT}:${PORT} -d ${PROJ_NAME}
EOF

echo "Forwarding localhost:${PORT} to harbor (Ctrl+C to exit)"
echo "ssh harbor -L ${PORT}:localhost:${PORT} -N"
ssh harbor -L ${PORT}:localhost:${PORT} -N
