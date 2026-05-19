#!/bin/bash

# Helper script to build MLTF Gateway container
function get_buildkit_cmd() {
    # Other build-kit compatible CLIs exist, find which
    # one the user has installed
	for X in nerdctl docker; do
        if ${X} ps &>/dev/null; then
            echo "${X}"
            return 0
        fi
    done
    2>&1 echo "ERROR: Buildkit CLI (e.g. docker) not found"
    return 1
}

TAG="mltf-gateway:latest"
MULTIARCH="--platform linux/amd64,linux/arm64"
CLEAN=""
while getopts 'act:h' opt; do
  case "$opt" in
    a)
      MULTIARCH=""
      ;;
    c)
      CLEAN="--pull --no-cache"
      ;;
    t)
      TAG="$OPTARG"
      ;;
    ?|h)
      2>&1 echo "Usage: $(basename $0) [-a] [-t image_tag]"
      2>&1 echo "       -a : Disables building for multiple archs"
      2>&1 echo "       -c : Performs a clean build (no-cache, pull images"
      2>&1 echo "       -t image_tag : Override default image tag"
      exit 1
      ;;
  esac
done
shift "$(($OPTIND -1))"

BUILDKIT_CMD=$(get_buildkit_cmd)

echo "INFO: Will build using ${X}"
echo "INFO: Build root is $ROOT_DIR"

${BUILDKIT_CMD} build . ${MULTIARCH} ${CLEAN} -t ${TAG}
