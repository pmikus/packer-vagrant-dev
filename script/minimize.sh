#!/bin/bash -eu

echo "==> Removing APT cache"
apt-get -y autoremove --purge
apt-get clean

echo "==> Removing APT files"
find /var/lib/apt -type f -exec rm -rf {} \;

echo "==> Removing caches"
find /var/cache -type f -exec rm -rf {} \;
