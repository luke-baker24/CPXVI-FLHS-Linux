#Remember to purge user's home directories if they were deleted before running this

UID_MIN=$(awk '/^UID_MIN/ {print $2}' /etc/login.defs)
UID_MAX=$(awk '/^UID_MAX/ {print $2}' /etc/login.defs)

real_users=$(awk -F':' -v "min=$UID_MIN" -v "max=$UID_MAX" '{ if ( $3 >= min && $3 <= max ) print $0}' /etc/passwd | cut -d ":" -f 1)

for real_user in $real_users
do
    passwd_entry=$(getent passwd $real_user)

    #The sixth parameter is the home path of the user, if they have one
    user_home_path=$(echo $passwd_entry | cut -d ":" -f 6)

    #Perform home path checks
    if [[ $user_home_path ]]; then
        meld $user_home_path $1/home/
    fi
done