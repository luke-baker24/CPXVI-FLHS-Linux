#!/bin/bash

mkdir new-baselines

#Verify aide is installed on the system
if [[ $(which aide) ]]; then
    echo "Aide installed"
else
    echo "Aide is not installed."

    apt install aide
fi

#Files db
cp ../baselines/focal/general.conf /var/lib/aide/aide.conf

aide --init --config=/var/lib/aide/aide.conf

cp /var/lib/aide/aide.db.new ./new-baselines/general.db

#Etc copied
cp -r /etc/ ./new-baselines/etc/

cp -r /etc/login.defs ./new-baselines/login.defs
cp -r /etc/pam.d/ ./new-baselines/pam.d/
cp -r /etc/gdm3/ ./new-baselines/gdm3/
cp -r /etc/grub.d/ ./new-baselines/grub.d/
cp -r /etc/security ./new-baselines/security
cp -r /etc/polkit-1 ./new-baselines/polkit-1
cp -r /etc/apt ./new-baselines/apt
cp -r /etc/sudoers ./new-baselines/sudoers
cp -r /etc/sysctl.conf ./new-baselines/sysctl.conf
cp -r /etc/ufw ./new-baselines/ufw

#Package baseline
apt list --installed 2>/dev/null | tail -n +2 | cut -d "/" -f 1 > ./new-baselines/packages.txt

#Snap baseline
if [[ $(which snap ) ]]
then
    snap list | cut -d $'\t' -f 1 | cut -d " " -f 1 | tail +2 > ./new-baselines/snaps.txt
fi