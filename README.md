# Alpine Raspberry PI

This is a system install of Alpine linux for Raspberry Pi 3B, 3B+ and 4 image ready to burn to an SD card via [balenaEtcher](https://www.balena.io/etcher/) (there's no need to gunzip image).

The image automatically setup and configures:

* root user [pwd: raspberry]
* pi user [pwd: raspberry]
* ethernet
* wifi (edit `wpa_supplicant.conf` in the boot partition, on first boot it will be copied)
* bluetooth
* avahi
* swap
* openssh server
* root partition auto-expand on first boot

Use:

* run build-image.sh to build a runner docker image. (This is needed only the first time)
* run docker-build.sh to build the image for Rasperbby Pi.

Config docker-build.sh:

* default config
  * hostnane=raspberrypi
  * device-name=sda
  * root-password=raspberry
  * tld=lan
  * username=pi
  * user-password=raspberry
  * locale=us-us
  * timezone=UTC
  * dns-server-name=
  * dns-domain-name=

* no param: using all default values
* specify config file:
  * -f: file that contains the export of all variables you want to specify
  * note: this will override other single parameters
* specify single params:
  * -h hostname
  * -d device-name
  * -r root-passowrd
  * -i internal lan suffix
  * -u user name
  * -p user password
  * -l locale
  * -t timezone
  * -s dns server name
  * -v dns domain name
