#!/bin/bash

if [ -e /srv/src ]; then
    #
    # The user passed in a source dir, install as editable package
    #
    /srv/venv/bin/pip install -e /srv/src
fi
source /srv/venv/bin/activate
MLTF_PORT=${PORT:-8080}
MLTF_IP=${MLTF_IP:localhost}
for ((;;)); do
    mltf server --port ${MLTF_PORT} --host ${MLTF_IP}
    echo "Server died, restarting"
    sleep 5
done
