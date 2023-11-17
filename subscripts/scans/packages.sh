#!/bin/bash
source ./subscripts/source/output_log.sh

rm -rf temp

mkdir temp

apt list --installed 2>/dev/null | tail -n +2 | cut -d "/" -f 1 > temp/installedpackages.txt

for new_package in $(grep -xvf $directory/packages.txt temp/installedpackages.txt)
do
    if ! [[ $(dpkg -s $new_package | grep "^Source") ]]
    then
        output_log "PKG" "$new_package is an unauthorized parent package"
    fi
done


#Snap scan
snap list | cut -d $'\t' -f 1 | cut -d " " -f 1 | tail +2 > temp/snaplist.txt

for new_package in $(grep -xvf $directory/snaps.txt temp/snaplist.txt)
do
    output_log "SNP" "$new_package is an unauthorized snap"
done

#Unnecessary service scan
for service in $(service --status-all)
do
    service_name=$(echo $service | cut -d "]" -f 2 | tr -d "[:blank:]")

    if [ $service_name == "bluetooth*" ] || [ $service_name == "cups*" ] || [ $service_name == "avahi*" ]; then
        output_log "SVC" "$service_name is an unnecessary service. Disable it unless absolutely necesary."
    fi
done

#Clear the temp directory
rm -r temp