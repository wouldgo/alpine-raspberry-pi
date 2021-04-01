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
    f) CONFIG=$OPTARG;;
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
    *) echo "Invalid option
Options are:
  - f: file that contains the export of all variables you want to specify;
  - h: hostname;
  - d: device-name;
  - r: root-passowrd;
  - i: internal lan suffix;
  - u: user name;
  - p: user password;
  - l: locale;
  - t: timezone;
  - s: dns server name;
  - v: dns domain name;"; exit 1
  esac
done

if [[ -n "${CONFIG}" ]] && [[ -f "${CONFIG}" ]]; then

  env "$(xargs < "${CONFIG}")"
fi

do_it "$@"
