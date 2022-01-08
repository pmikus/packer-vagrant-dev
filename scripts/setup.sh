#!/bin/bash

echo "> Cleaning up tmp ..."
rm -rf /tmp/*

echo "> Clearing log files ..."
find /var/log -type f -exec truncate --size=0 {} \;

echo "> Clear out swap and disable until reboot ..."
swapuuid=$(blkid -o value -l -s UUID -t TYPE=swap)
case "$?" in
    2|0) ;;
    *) exit 1 ;;
esac
if [ "x$swapuuid" != "x" ]; then
    # Whiteout the swap partition to reduce box size
    # Swap is disabled till reboot
    swappart=$(readlink -f /dev/disk/by-uuid/${swapuuid})
    swapoff $swappart
    dd if=/dev/zero of=$swappart bs=1M || echo "dd exit code $? is suppressed"
    mkswap -U $swapuuid $swappart
fi

echo "> Setting hostname to localhost ..."
cat /dev/null > /etc/hostname
hostnamectl set-hostname localhost

echo "> Cleaning apt-get ..."
apt-get -y autoremove --purge
apt-get clean
find /var/lib/apt -type f -exec rm -rf {} \;
find /var/cache -type f -exec rm -rf {} \;

echo "> Cleaning the machine-id ..."
truncate -s 0 /etc/machine-id
rm /var/lib/dbus/machine-id
ln -s /etc/machine-id /var/lib/dbus/machine-id

echo "> Zero out the free space ..."
dd if=/dev/zero of=/EMPTY bs=1M || echo "dd exit code $? is suppressed"
rm -f /EMPTY
sync
