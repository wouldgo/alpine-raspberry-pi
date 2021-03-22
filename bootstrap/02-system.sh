#!/usr/bin/env bash

function do_it () {
  set -xe

  local TARGET_HOSTNAME
  local ROOT_PASSWORD
  local TLD

  TARGET_HOSTNAME="${1}"
  ROOT_PASSWORD="${3}"
  TLD="${4}"

  # base stuff
  apk add --no-cache ca-certificates
  update-ca-certificates
  echo "root:${ROOT_PASSWORD}" | chpasswd
  setup-hostname "${TARGET_HOSTNAME}"
  echo "127.0.0.1    ${TARGET_HOSTNAME} ${TARGET_HOSTNAME}.${TLD}" > /etc/hosts
  setup-keymap us us

  # time
  apk add --no-cache chrony tzdata
  setup-timezone -z UTC
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
