#!/bin/bash

function aide_scan()
{
    cp $aide_directory/$1.conf /var/lib/aide/aide.conf

    cp $aide_directory/$1.db /var/lib/aide/aide.db

    aide --check --config=/var/lib/aide/aide.conf >> $logs_directory/policy-aide.log
}

#Install aide if it's not yet installed
if ! [[ $(which aide) ]]; then
    apt install aide
fi

aide_directory="$1/../../aide"
logs_directory="$1/../../logs"

#Files scan
aide_scan general

#/etc/ scan
meld /etc/ $1/etc/