#!/bin/bash

function get_buildkit_cmd() {
    # Other build-kit compatible CLIs exist, find which
    # one the user has installed
        for X in nerdctl docker; do
        if ${X} ps &>/dev/null; then
            echo "${X}"
            return 0
        fi
    done
    1>&2 echo "ERROR: Buildkit CLI (e.g. docker) not found"
    return 1
}

CONTAINER_CMD="$(get_buildkit_cmd)"

${CONTAINER_CMD} run -it --rm=true \
                 -v $(pwd)/secret:/secret:ro \
                 -e SSAM_URL=https://ssam.accre.vanderbilt.edu \
                 -e AUTH_TOKEN_PATH=/secret/ssam_token \
                 -e SLURM_TOKEN_PATH=/secret/slurm_token \
                 -e MLTF_IP=0.0.0.0 \
                 -p 8080:8080/tcp \
                 ghcr.io/accre/mltf-gateway:v1
