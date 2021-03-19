#!/usr/bin/env bash

function do_it() {
  set -xe

  docker run \
    --privileged \
    --rm \
    -v /dev:/dev:ro \
    -v "$PWD":/runner \
    -w /runner \
    -e ALPINE_BRANCH=latest-stable \
    -e ALPINE_MIRROR="http://dl-cdn.alpinelinux.org/alpine" \
    -e ARCH=aarch64 \
    runner ./make-image
}

do_it "$@"
