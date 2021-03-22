#!/usr/bin/env bash

function do_it() {
  set -xe

  docker run \
    -it \
    --privileged \
    --rm \
    -v /dev:/dev:ro \
    -v "$PWD":/runner \
    -w /runner \
    -e ALPINE_BRANCH=latest-stable \
    -e ALPINE_MIRROR="http://dl-cdn.alpinelinux.org/alpine" \
    -e ARCH=aarch64 \
    -e TARGET_HOSTNAME="${TARGET_HOSTNAME}" \
    -e DEVICE_NAME="${DEVICE_NAME}" \
    -e ROOT_PASSWORD="${ROOT_PASSWORD}" \
    -e TLD="${TLD}" \
    -e USERNAME="${USERNAME}" \
    -e PASSWORD="${PASSWORD}" \
    runner ./make-image
}

do_it "$@"
