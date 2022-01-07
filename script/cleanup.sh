#!/bin/bash -eu

echo "==> Cleaning up tmp"
rm -rf /tmp/*

echo "==> Clearing log files"
find /var/log -type f -exec truncate --size=0 {} \;

echo "==> Clear out swap and disable until reboot"
set +e
swapuuid=$(blkid -o value -l -s UUID -t TYPE=swap)
case "$?" in
    2|0) ;;
    *) exit 1 ;;
esac
set -e
if [ "x$swapuuid" != "x" ]; then
    # Whiteout the swap partition to reduce box size
    # Swap is disabled till reboot
    swappart=$(readlink -f /dev/disk/by-uuid/${swapuuid})
    swapoff $swappart
    dd if=/dev/zero of=$swappart bs=1M || echo "dd exit code $? is suppressed"
    mkswap -U $swapuuid $swappart
fi

echo "==>  Zero out the free space"
dd if=/dev/zero of=/EMPTY bs=1M || echo "dd exit code $? is suppressed"
rm -f /EMPTY
sync
