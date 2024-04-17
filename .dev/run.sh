#!/bin/sh

BUILDER_IMAGE=${BUILDER_IMAGE:-'build-reth:dev'}
TARGET_DIR_VOLUME=${TARGET_DIR_VOLUME:-'build-reth_target_dir'}
DOCKER=${DOCKER:-docker}


THIS_ZSH="$0:A"
THIS_BASH="$BASH_SOURCE"
THIS_DIR=$(cd "$(dirname ${BASH_SOURCE:-"$THIS_ZSH"})"; pwd)
PROJECTS_DIR=$(dirname $(dirname "$THIS_DIR"))

docker build -t "${BUILDER_IMAGE}" "${THIS_DIR}"

cd "${PROJECTS_DIR}/reth"


in-docker \
    --image "${BUILDER_IMAGE}" \
    --name build-reth \
    -v "${THIS_DIR}/cargo-git:/usr/local/cargo/git:rw" \
    -v "${THIS_DIR}/cargo-registry:/usr/local/cargo/registry:rw" \
    -v "${TARGET_DIR_VOLUME}:${PROJECTS_DIR}/reth/target:rw" \
    -v "${PROJECTS_DIR}/alloy:${PROJECTS_DIR}/alloy:ro"
