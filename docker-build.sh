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
    -e LOCALE="${LOCALE}" \
    -e TIMEZONE="${TIMEZONE}" \
    -e DNS_SERVER="${DNS_SERVER}" \
    -e DNS_DOMAIN="${DNS_DOMAIN}" \
    runner ./make-image
}

while getopts ":f:h:d:r:i:u:p:l:t:s:v:" arg; do
  case $arg in
    f) COMNFIG=$OPTARG;;
    h) TARGET_HOSTNAME=$OPTARG;;
    d) DEVICE_NAME=$OPTARG;;
    r) ROOT_PASSWORD=$OPTARG;;
    i) TLD=$OPTARG;;
    u) USERNAME=$OPTARG;;
    p) PASSWORD=$OPTARG;;
    l) LOCALE=$OPTARG;;
    t) TIMEZONE=$OPTARG;;
    s) DNS_SERVER=$OPTARG;;
    v) DNS_DOMAIN=$OPTARG;;
  esac
done

if [[ ! -z "${CONFIG}" ]] && [[ -f ${CONFIG} ]]; then
  source $CONFIG
fi

do_it "$@"
