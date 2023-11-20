#!/bin/bash
source ./subscripts/source/output_log.sh

#Verify aide is installed on the system
if [[ $(which aide) ]]; then
    echo "Aide installed"
else
    echo "Aide is not installed."

    apt install aide
fi

aide_directory="$1/../../aide"
logs_directory="$1/../../logs"

function aide_scan()
{
    cp $aide_directory/$1.conf /var/lib/aide/aide.conf

    cp $aide_directory/$1.db /var/lib/aide/aide.db

    echo "report_url=$2/aide.log" >> /var/lib/aide/aide.db

    aide --check --config=/var/lib/aide/aide.conf >> "$logs_directory/policy-aide.log"
}

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
#cat policy-aide.log | grep -E "^.{18}\: .*$" | grep -E "^d" | awk 'BEGIN { FS = ": " } ; {print $2}'



#Get added files
#first command img in discord

added_directories=$(cat $logs_directory/policy-aide.log | grep -E "^d[\+]{17}" | awk 'BEGIN { FS = ": " } ; {print $2}')

for directory in $added_directories; do
    added_directories="$(echo $added_directories | grep -vE "^$directory.+$")"
done

#$(cat $logs_directory/policy-aide.log | grep -E "^[^d].{17}\: .*$" | awk 'BEGIN { FS = ": " } ; {print $2}' | uniq)

for added_file in $(cat $logs_directory/policy-aide.log | grep -E "^[^d][\+]{17}\: .*$" | grep -vE $(echo "$added_directories" | tr '\n' '|')); do
    output_log "FIL" "$added_file has been added"
done

#Get permissions modified
for changed_file in $(cat $logs_directory/policy-aide.log | grep -E "^.{4}p.{13}\: " | awk 'BEGIN { FS = ": " } ; {print $2}' | uniq); do
    perms_line=$(cat $logs_directory/policy-aide.log | grep -E "^.*: $changed_file$" -A 10 | grep 'Perm' | uniq)

    old_perms=$(echo $perms_line | cut -d ':' -f 2 | cut -d ' ' -f 2 | head -1)
    new_perms=$(echo $perms_line | cut -d '|' -f 2 | cut -d ' ' -f 2 | head -1)

    output_log "PRM" "$changed_file has changed file permissions from $old_perms to $new_perms"
done

for changed_file in $(cat $logs_directory/policy-aide.log | grep -E "^.{5}u.{12}\: " | awk 'BEGIN { FS = ": " } ; {print $2}' | uniq); do
    uid_line=$(cat $logs_directory/policy-aide.log | grep -E "^.*: $changed_file$" -A 10 | grep 'Uid' | uniq)

    old_uid=$(echo $uid_line | cut -d ':' -f 2 | cut -d ' ' -f 2 | head -1)
    new_uid=$(echo $uid_line | cut -d '|' -f 2 | cut -d ' ' -f 2 | head -1)

    old_user=$(id -nu $old_uid 2> /dev/null) 
    new_user=$(id -nu $new_uid 2> /dev/null)

    output_log "PRM" "$changed_file has changed user ownership from $old_uid $old_user to $new_uid $new_user"
done

for changed_file in $(cat $logs_directory/policy-aide.log | grep -E "^.{6}g.{11}\: " | awk 'BEGIN { FS = ": " } ; {print $2}' | uniq); do
    uid_line=$(cat $logs_directory/policy-aide.log | grep -E "^.*: $changed_file$" -A 10 | grep 'Gid' | uniq)

    old_uid=$(echo $uid_line | cut -d ':' -f 2 | cut -d ' ' -f 2 | head -1)
    new_uid=$(echo $uid_line | cut -d '|' -f 2 | cut -d ' ' -f 2 | head -1)

    old_user=$(getent group $old_uid | cut -d: -f1 2> /dev/null) 
    new_user=$(getent group $new_uid | cut -d: -f1 2> /dev/null)

    output_log "PRM" "$changed_file has changed group ownership from $old_uid $old_user to $new_uid $new_user"
done