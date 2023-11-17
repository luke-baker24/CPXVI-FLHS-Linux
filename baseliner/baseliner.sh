#!/bin/bash

mkdir new-baselines

#Files db
cp ../aide/general.conf /var/lib/aide/aide.conf

aide --init --config=/var/lib/aide/aide.conf

cp /var/lib/aide/aide.db.new ./new-baselines/general.db

#Etc db
cp ../aide/polcheck.conf /var/lib/aide/aide.conf

aide --init --config=/var/lib/aide/aide.conf

cp /var/lib/aide/aide.db.new ./new-baselines/polcheck.db

#Etc copied
cp -r /etc/ ./new-baselines/etc/

#Package baseline
apt list --installed 2>/dev/null | tail -n +2 | cut -d "/" -f 1 > ./new-baselines/package-whitelist

#Snap baseline
if [[ $(which snap ) ]]
then
    snap list | cut -d $'\t' -f 1 | cut -d " " -f 1 | tail +2 > ./new-baselines/snap-whitelist
fi