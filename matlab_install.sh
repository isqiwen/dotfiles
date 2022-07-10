#!/usr/bin/env zsh

MOUNT_POINT=/mnt/matlab
mkdir -p $MOUNT_POINT # create the mount point directory
unrar e -v -o- -pwww.ShareAppsCrack.com "*Matlab*part1*" # unzip the matlab .zip folder
mount *Matlab*.iso $MOUNT_POINT # mount the file
/mnt/matlab/install # run matlab installing
umount $MOUNT_POINT # unmount
rm -rf $MOUNT_POINT # delete mount point directory
