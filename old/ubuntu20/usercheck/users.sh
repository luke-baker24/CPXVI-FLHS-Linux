#!/bin/bash

olddir=$(pwd)
desktop=$olddir/../../../Desktop

touch $desktop/userscan.txt
echo "" > $desktop/userscan.txt

userlist=$(getent passwd | grep home |  cut -d: -f1 | grep -v cups-pk | grep -v syslog)
adminslist=$(getent group | grep sudo)

while read user
do
    if grep -q -wi "$user" authorizedusers.txt; then
        echo ""
    else
        echo "Found unauthorized user $user" >> $desktop/userscan.txt
    fi
done < <(echo $userlist)

while read user
do
    if echo $userlist | grep -q -wi "$user"; then
        echo ""
    else
        echo "Missing user $user" >> $desktop/userscan.txt
    fi
done < <(cat authorizedusers.txt)

while read user
do
    if grep -q -wi "$user" authorizedadmins.txt; then
        echo ""
    else
        echo "Found unauthorized admin $user" >> $desktop/userscan.txt
    fi
done < <(echo $adminlist)

while read user
do
    if echo $adminlist | grep -q -wi "$user"; then
        echo ""
    else
        echo "Missing admin $user" >> $desktop/userscan.txt
    fi
done < <(cat authorizedadmins.txt)