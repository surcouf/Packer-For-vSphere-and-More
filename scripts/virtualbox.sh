#!/bin/bash

set -e
set -x

if [ "$PACKER_BUILDER_TYPE" != "virtualbox-iso" ]; then
  exit 0
fi

os=$(lsb_release -si)
osname="$(lsb_release -sc)"
osversion="$(lsb_release -sr)"

case "${os}" in
  Ubuntu)
    sudo apt-get install -y virtualbox-guest-dkms
  ;;
  Debian)
    case "${osversion}" in
      7.*)
        curl -fSs https://www.virtualbox.org/download/oracle_vbox.asc | sudo apt-key add -
      ;;
      9.*|8.*)
        curl -fSs https://www.virtualbox.org/download/oracle_vbox_2016.asc | sudo apt-key add -
	sudo apt-add-repository "deb http://download.virtualbox.org/virtualbox/debian ${osname} contrib"
	sudo apt update
        sudo apt install virtualbox-5.2
      ;;
      *)
        sudo apt-get install -y build-essential linux-headers-`uname -r`
        sudo mkdir -p /mnt/virtualbox
        sudo mount -o loop /home/packer/VBoxGuestAdditions.iso /mnt/virtualbox
        sudo sh /mnt/virtualbox/VBoxLinuxAdditions.run
        sudo umount /mnt/virtualbox
        sudo rm -rf /home/packer/VBoxGuestAdditions.iso
      ;;
    esac
  ;;
  CentOS|RedHat)
    sudo curl -fSs -o VirtualBox-5.2-5.2.10_122088_el6-1.x86_64.rpm http://download.virtualbox.org/virtualbox/rpm/rhel/6/x86_64/VirtualBox-5.2-5.2.10_122088_el6-1.x86_64.rpm
    sudo yum localinstall -y VirtualBox-5.2-5.2.10_122088_el6-1.x86_64.rpm
  ;;
esac

