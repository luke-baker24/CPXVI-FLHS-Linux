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

#sudo systemctl list-units --type=service | tr -s ' ' | tail -n +2 | head -n -6

#Unnecessary service scan
for service in $(service --status-all | grep "+")
do
    #service_name=$(echo $service | cut -d "]" -f 2 | tr -d "[:blank:]")
    echo $service

    if [[ $service =~ "^bluetooth.*$" ]] || [[ $service =~ "^cups.*$" ]] || [[ $service =~ "^avahi.*$" ]]; then
        output_log "SVC" "$service is an unnecessary service. Disable it unless absolutely necesary."
    fi
done

for service in $(service --status-all | grep "-")
do
    #service_name=$(echo $service | cut -d "]" -f 2 | tr -d "[:blank:]")
    echo $service

    if [[ $service =~ "^apparmor.*$" ]]; then
        output_log "SVC" "$service should be enabled."
    fi
done

#Clear the temp directory
rm -r temp