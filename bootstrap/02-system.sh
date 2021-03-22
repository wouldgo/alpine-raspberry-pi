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
  echo "#!/bin/sh

  ntpd -d -q -n -p pool.ntp.org" >> /etc/periodic/daily/poll-ntp-pool.sh

  chmod u+x /etc/periodic/daily/poll-ntp-pool.sh

  cat <<EOF > /etc/init.d/poll-ntp-pool
#!/sbin/openrc-run

name="poll-ntp-pool"
command="/etc/periodic/daily/poll-ntp-pool.sh"
pidfile="/var/run/poll-ntp-pool.pid"

depend() {
	need net
  need localmount
	use dns
}
EOF

  chmod +x /etc/init.d/poll-ntp-pool
  rc-update add poll-ntp-pool

  # other stuff
  apk add --no-cache curl vim
  sed -i 's/\/bin\/ash/\/bin\/bash/g' /etc/passwd
}

do_it "$@"
