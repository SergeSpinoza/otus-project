#!/bin/bash

sudo fdisk /dev/sdb <<EOF
n
p
1


w
EOF

sudo mkfs.xfs /dev/sdb1
