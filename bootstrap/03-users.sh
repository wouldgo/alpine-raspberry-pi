#!/usr/bin/env bash

function do_it () {
  set -xe

  local USERNAME
  local PASSWORD

  USERNAME="${5}"
  PASSWORD="${6}"

  apk add --no-cache sudo

  for GRP in spi i2c gpio; do
    addgroup --system $GRP
  done

  adduser -s /bin/bash -D "${USERNAME}"

  for GRP in adm dialout cdrom audio users video games input gpio spi i2c netdev; do
    adduser "${USERNAME}" "${GRP}"
  done

  echo "${USERNAME}:${PASSWORD}" | /usr/sbin/chpasswd
  echo "${USERNAME} ALL=NOPASSWD: ALL" >> /etc/sudoers
}

do_it "$@"
