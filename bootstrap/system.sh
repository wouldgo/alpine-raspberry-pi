#!/bin/sh

set -xe

TARGET_HOSTNAME="raspberrypi"

# base stuff
apk add --no-cache ca-certificates
update-ca-certificates
echo "root:raspberry" | chpasswd
setup-hostname $TARGET_HOSTNAME
echo "127.0.0.1    $TARGET_HOSTNAME $TARGET_HOSTNAME.lan" > /etc/hosts
setup-keymap us us

# time
apk add --no-cache chrony tzdata
setup-timezone -z UTC
echo "#!/bin/sh

ntpd -d -q -n -p pool.ntp.org" >> /etc/periodic/daily/poll-ntp-pool.sh

chmod u+x /etc/periodic/daily/poll-ntp-pool.sh

# other stuff
apk add --no-cache curl vim bash
sed -i 's/\/bin\/ash/\/bin\/bash/g' /etc/passwd
