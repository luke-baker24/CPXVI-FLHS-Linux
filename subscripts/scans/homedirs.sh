#!/bin/bash
source ./subscripts/source/output_log.sh

#Remember to purge user's home directories if they were deleted before running this

UID_MIN=$(awk '/^UID_MIN/ {print $2}' /etc/login.defs)
UID_MAX=$(awk '/^UID_MAX/ {print $2}' /etc/login.defs)

real_users=$(awk -F':' -v "min=$UID_MIN" -v "max=$UID_MAX" '{ if ( $3 >= min && $3 <= max ) print $0}' /etc/passwd | cut -d ":" -f 1)

old_dir=$(pwd)

for real_user in $real_users
do
    passwd_entry=$(getent passwd $real_user)

    #The sixth parameter is the home path of the user, if they have one
    user_home_path=$(echo $passwd_entry | cut -d ":" -f 6)

    #Perform home path checks
    if [[ $user_home_path ]]; then 
        cd $user_home_path

        for prohib_file in $(find . -maxdepth 2 -type f | grep -v '^./.profile$' \
            | grep -v '^./.bashrc$'  | grep -v '^./.config/user-dirs.dirs$' | grep -v '^./.config/user-dirs.locale$' \
            | grep -v '^./.face$' | grep -v '^./.bash_logout$' | tr " " "_"); do
            output_log "FIL" "$user_home_path/$prohib_file  is a found abnormal file"
        done

        for prohib_file in $(find . -maxdepth 2 -type l | grep -v "^./.bash_history$" | tr " " "_"); do
            output_log "LNK" "$user_home_path/$prohib_file is a found abnormal symlink"
        done

        for prohib_file in $(find . -maxdepth 2 -type d | grep -v "^.$" | grep -v "^./.config$" | grep -v "^./Documents$" | grep -v "^./Music$" | grep -v "^./Public$" | grep -v "^./snap$" \
            | grep -v "^./Videos$" | grep -v "^./Desktop$" | grep -v "^./Downloads$" | grep -v "^./Pictures$" | grep -v "^./Templates$" | tr " " "_"); do
            output_log "DIR" "$user_home_path/$prohib_file is a found abnormal directory - consider investigating individually"
        done
    fi
done

cd $old_dir

