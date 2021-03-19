#!/bin/sh

set -xe

echo "modules=loop,squashfs,sd-mod,usb-storage root=/dev/sda2 rootfstype=ext4 elevator=deadline fsck.repair=yes console=tty1 rootwait quiet cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory" > /boot/cmdline.txt

cat <<EOF > /boot/config.txt
[pi3]
kernel=vmlinuz-rpi
initramfs initramfs-rpi
[pi3+]
kernel=vmlinuz-rpi
initramfs initramfs-rpi
[pi4]
enable_gic=1
kernel=vmlinuz-rpi4
initramfs initramfs-rpi4
[all]
arm_64bit=1

dtoverlay=disable-wifi
dtoverlay=disable-bt

include usercfg.txt
EOF

cat <<EOF > /boot/usercfg.txt
EOF

# fstab
cat <<EOF > /etc/fstab
/dev/sda1  /boot           vfat    defaults          0       2
/dev/sda2  /               ext4    defaults,noatime  0       1
EOF

apk add --no-cache linux-rpi linux-rpi4 raspberrypi-bootloader
cd /boot/dtbs-rpi || cd /boot/overlays && find -type f \( -name "*.dtb" -o -name "*.dtbo" \) | cpio -pudm /boot
