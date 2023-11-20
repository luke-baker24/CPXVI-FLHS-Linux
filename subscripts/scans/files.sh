#!/bin/bash
source ./subscripts/source/output_log.sh

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

    aide --check --config=/var/lib/aide/aide.conf >> "$logs_directory/$1-aide.log"
}

aide_directory="$1/../../aide"
logs_directory="$1/../../logs"

#Run aide scan
aide_scan general $logs_directory

#Parse aide results
#???

#YlZbpugamcinHAXSEC
#X___xxx__________x

#if it's X+++++++ ... that means the file is added
#if it's X------ ... that means the file is removed -> no one cares
#if hash is the only thing changed .... probably doesn't matter


#exact format:
#YlZbpugamcinHAXSEC: /path/to/the/file


#Get added directories
cat policy-aide.log | grep -E "^.{18}\: .*$" | grep -E "^d" | awk 'BEGIN { FS = ": " } ; {print $2}'



#Get added files
#first command img in discord
for added_file in $(cat policy-aide.log | grep -E "^.{18}\: .*$" | grep -E "^[^d]+++++++++++++++++" | awk 'BEGIN { FS = ": " } ; {print $2}' | grep -E $(cat policy-aide.log | grep -E "^.{18}\: .*$" | grep -E "^d" | awk 'BEGIN { FS = ": " } ; {print $2}' | tr '\n' '|')); do
    output_log "FIL" "$added_file has been added"
done

#Get permissions modified
for changed_file in $(cat policy-aide.log | grep -E "^.{4}p.{13}\: " | awk 'BEGIN { FS = ": " } ; {print $2}'); do
    output_log "PRM" "$changed_file has changed file permissions to $(cat policy-aide.log | grep -E "^.*: $changed_file$" -A 10 | grep 'Perm' | cut -d ':' -f 2 | cut -d ' ' -f 2 | head -1)"
done

for changed_file in $(cat policy-aide.log | grep -E "^.{5}u.{12}\: " | awk 'BEGIN { FS = ": " } ; {print $2}'); do
    output_log "PRM" "$changed_file has changed user ownership to $(cat policy-aide.log | grep -E "^.*: $changed_file$" -A 10 | grep 'User' | cut -d ':' -f 2 | cut -d ' ' -f 2 | head -1)"
done

for changed_file in $(cat policy-aide.log | grep -E "^.{6}g.{11}\: " | awk 'BEGIN { FS = ": " } ; {print $2}'); do
    output_log "PRM" "$changed_file has changed group ownership to $(cat policy-aide.log | grep -E "^.*: $changed_file$" -A 10 | grep 'Group' | cut -d ':' -f 2 | cut -d ' ' -f 2 | head -1)"
done