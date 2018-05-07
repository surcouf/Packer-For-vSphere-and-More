#!/bin/bash

set -e
set -x

if [ "$PACKER_BUILDER_TYPE" != "virtualbox-iso" ]; then
  exit 0
fi

# Debian/Ubuntu
if [ -f /etc/debian_version ]; then
  os="$(lsb_release -si)"
  if [[ $os == "Ubuntu" ]]; then
    sudo apt-get install -y virtualbox-guest-dkms
  elif [[ $os == "Debian" ]]; then
    sudo apt-get install -y build-essential linux-headers-`uname -r`
    sudo mkdir -p /mnt/virtualbox
    sudo mount -o loop /home/packer/VBoxGuestAdditions.iso /mnt/virtualbox
    sudo sh /mnt/virtualbox/VBoxLinuxAdditions.run
    sudo umount /mnt/virtualbox
    sudo rm -rf /home/packer/VBoxGuestAdditions.iso
  fi
fi

# RHEL
if [ -f /etc/redhat-release ]; then
  sudo yum -y install gcc kernel-devel kernel-headers dkms make bzip2 perl && \
  sudo yum -y groupinstall "Development Tools"
  sudo mkdir -p /mnt/virtualbox
  sudo mount -o loop /home/packer/VBoxGuestAdditions.iso /mnt/virtualbox
  sudo sh /mnt/virtualbox/VBoxLinuxAdditions.run
  sudo umount /mnt/virtualbox
  sudo rm -rf /home/packer/VBoxGuestAdditions.iso
fi
