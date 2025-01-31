#!/usr/bin/env bash

function do_it () {
  set -xe

  local TARGET_HOSTNAME

  TARGET_HOSTNAME="${1}"

  apk add --no-cache wpa_supplicant wireless-tools wireless-regdb iw
  sed -i 's/wpa_supplicant_args=\"/wpa_supplicant_args=\" -u -Dwext,nl80211/' /etc/conf.d/wpa_supplicant

  echo -e 'brcmfmac' >> /etc/modules

  cat <<EOF > /boot/wpa_supplicant.conf
network={
 ssid="SSID"
 psk="PASSWORD"
}
EOF

  ln -s /boot/wpa_supplicant.conf /etc/wpa_supplicant/wpa_supplicant.conf

  cat <<EOF > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet dhcp

auto wlan0
iface wlan0 inet dhcp
  up iwconfig wlan0 power off

hostname ${TARGET_HOSTNAME}
EOF

  # avahi
  apk add --no-cache dbus avahi

  # bluetooth
  apk add --no-cache bluez bluez-deprecated
  sed -i '/bcm43xx/s/^#//' /etc/mdev.conf
}

do_it "$@"
