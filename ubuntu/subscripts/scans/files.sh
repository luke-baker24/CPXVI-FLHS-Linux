#!/bin/bash

#Install aide if it's not yet installed
if ! [[ $(which aide) ]]; then
    apt install aide
fi

function aide_scan()
{
    cp $aide_directory/$1.conf /var/lib/aide/aide.conf

    cp $aide_directory/$1.db /var/lib/aide/aide.db

    aide --check --config=/var/lib/aide/aide.conf >> $logs_directory/policy-aide.log
}

aide_directory="$1/../../aide"
logs_directory="$1/../../logs"

#Files scan
aide_scan general

#Etc scan
aide_scan polcheck

#Home directories scan
