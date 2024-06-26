#!/bin/bash

# using https://github.com/foundObjects/zram-swap
VERSION="205ea1ec5b169f566e5e98ead794e9daf90cf245"

if [ "$1" = status ]; then

  # check if file /home/admin/download/zram-swap/install.sh exists
  #echo "# https://github.com/foundObjects/zram-swap"
  if [ -f /home/admin/download/zram-swap/install.sh ]; then
    echo "downloaded=1"
  else
    echo "downloaded=0"
  fi

  # check if service zram-swap is loaded/active
  #echo "# sudo systemctl status zram-swap"
  serviceLoaded=$(sudo systemctl status zram-swap 2>/dev/null | grep -c loaded)
  if [ ${serviceLoaded} -gt 0 ]; then
    echo "serviceLoaded=1"
  else
    echo "serviceLoaded=0"
  fi  
  serviceActive=$(sudo systemctl status zram-swap 2>/dev/null | grep -c active)
  if [ ${serviceActive} -gt 0 ]; then
    echo "serviceActive=1"
  else
    echo "serviceActive=0"
  fi

  exit 0
fi

# command info
if [ $# -eq 0 ] || [ "$1" = "-h" ] || [ "$1" = "-help" ]; then
  echo "config script to install ZRAM"
  echo "blitz.zram.sh [on|off|status]"
  echo "using https://github.com/foundObjects/zram-swap"
  exit 1
fi


echo "# mkdir /home/admin/download"
mkdir /home/admin/download 2>/dev/null
cd /home/admin/download || exit 1
if [ ! -d zram-swap ]; then
  echo "# download script"
  sudo -u admin git clone https://github.com/foundObjects/zram-swap.git
  echo "# cd zram-swap"
  cd zram-swap || exit 1
  echo "# check version"
  sudo -u admin git reset --hard $VERSION || exit 1
  echo "# version OK" 
else
  echo "# script available"
  cd zram-swap || exit 1
  echo "# directory OK"
fi

if [ "$1" = on ]; then
  echo "# install zram-swap"
  if [ $(sudo cat /proc/swaps | grep -c zram) -eq 0 ]; then
    # install zram to 1/2 of RAM, activate and prioritize
    sudo /home/admin/download/zram-swap/install.sh

    # make better use of zram
    echo "# RaspiBlitz Edit: blitz.zram.sh" | sudo tee -a /etc/sysctl.conf
    echo "vm.vfs_cache_pressure=500" | sudo tee -a /etc/sysctl.conf
    echo "vm.swappiness=100" | sudo tee -a /etc/sysctl.conf
    echo "vm.dirty_background_ratio=1" | sudo tee -a /etc/sysctl.conf
    echo "vm.dirty_ratio=50" | sudo tee -a /etc/sysctl.conf

    # apply
    sudo sysctl --system
    echo "# ZRAM is installed and activated"
  else
    echo "# ZRAM was already installed and active."
  fi

  echo "Current swap usage:"
  sudo cat /proc/swaps
  exit 0
fi

if [ "$1" = off ]; then
  echo "# deinstall zram-swap"
  sudo /home/admin/download/zram-swap/install.sh --uninstall
  sudo rm /etc/default/zram-swap
  sudo rm -rf /home/admin/download/zram-swap
  echo "ZRAM was removed"
  echo "Current swap usage:"
  sudo cat /proc/swaps
  exit 0
fi

echo "FAIL - Unknown Parameter $1"
exit 1