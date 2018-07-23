#!/bin/bash
set -e

# Create dir for mount
sudo mkdir -p /mnt/gitlab

# fstab copy and mount
sudo mv /tmp/fstab /etc/fstab && sudo chmod 644 /etc/fstab
sudo mount -a
