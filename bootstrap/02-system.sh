#!/usr/bin/env bash

function do_it () {
  set -xe

  local TARGET_HOSTNAME
  local ROOT_PASSWORD
  local TLD
  local DEVICE_NAME
  local LOCALE
  local LAYOUT
  local LAYOUT_SPEC
  local TIMEZONE
  local DNS_DOMAIN
  local DNS_SERVER

  TARGET_HOSTNAME="${1}"
  ROOT_PASSWORD="${2}"
  TLD="${3}"
  DEVICE_NAME="${4}"
  LOCALE="${5}"
  TIMEZONE="${6}"
  DNS_SERVER="${7}"
  DNS_DOMAIN="${8}"
  LAYOUT="$( cut -d '-' -f 1 <<< "$LOCALE" )";
  LAYOUT_SPEC="$( cut -d '-' -f 2 <<< "$LOCALE" )";

  # base stuff
  apk add --no-cache ca-certificates
  update-ca-certificates
  echo "root:${ROOT_PASSWORD}" | chpasswd
  setup-hostname "${TARGET_HOSTNAME}"
  echo "127.0.0.1    ${TARGET_HOSTNAME} ${TARGET_HOSTNAME}.${TLD}" > /etc/hosts

  setup-keymap "${LAYOUT}" "${LAYOUT_SPEC}"

  if [[ -n "${DNS_DOMAIN}" ]] && [[ -n "${DNS_SERVER}" ]]; then
    setup-dns -d "${DNS_DOMAIN}" -n "${DNS_SERVER}"
  fi

  setup-apkrepos -f
  setup-apkcache "/media/${DEVICE_NAME}/cache"

  # time
  apk add --no-cache chrony tzdata
  setup-timezone -z "${TIMEZONE}"
  cat <<EOF > /etc/periodic/daily/poll-ntp-pool.sh
#!/bin/sh

until nslookup pool.ntp.org; do
  echo \"waiting for network\";
  sleep 1;
done

ntpd -d -q -n -p pool.ntp.org
EOF

  chmod u+x /etc/periodic/daily/poll-ntp-pool.sh

  echo "@reboot                                 /etc/periodic/daily/poll-ntp-pool.sh > /var/log/pool-ntp-pool.log 2>&1" | \
    tee -a /var/spool/cron/crontabs/root

  # other stuff
  apk add --no-cache curl vim
  sed -i 's/\/bin\/ash/\/bin\/bash/g' /etc/passwd
}

do_it "$@"
