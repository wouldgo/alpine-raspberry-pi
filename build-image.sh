#!/usr/bin/env bash

function do_it() {
  set -xe
  local CURRENT_DIR

  CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

  docker build "${CURRENT_DIR}/runner" -t runner
}

do_it "$@"
