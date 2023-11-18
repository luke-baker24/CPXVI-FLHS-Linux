#!/bin/bash

#Verify aide is installed on the system
if [[ $(which aide) ]]; then
    echo "Aide installed"
else
    echo "Aide is not installed."

    apt install aide
fi

function aide_scan()
{
    cp $aide_directory/$1.conf /var/lib/aide/aide.conf

    cp $aide_directory/$1.db /var/lib/aide/aide.db

    echo "report_url=$2/aide.log" >> /var/lib/aide/aide.db

    aide --check --config=/var/lib/aide/aide.conf >> $logs_directory/policy-aide.log
}

aide_directory="$1/../../aide"
logs_directory="$1/../../logs"

#Run aide scan
aide_scan general $logs_directory

#Parse aide results
#???