#!/usr/bin/env bash

function do_it () {
  set -xe

  apk add --no-cache openssh openssl rng-tools eudev iptables


  for service in devfs dmesg mdev; do
    rc-update add $service sysinit
  done

  for service in rngd modules sysctl hostname bootmisc swclock syslog swap; do
    rc-update add $service boot
  done

  for service in iptables dbus sshd chronyd local networking avahi-daemon bluetooth wpa_supplicant wpa_cli crond; do
    rc-update add $service default
  done

  setup-udev -n

  for service in mount-ro killprocs savecache; do
    rc-update add $service shutdown
  done
}

do_it "$@"
