#Creating blank lists for approved users
RED='\033[0;31m' #Red color code
NC='\033[0m' #No color code

output_log () {
    classification="$1"
    message="$2"
    
    echo -e "[ ${RED}$classification${NC} ] $message"
    echo "[ $classification ] $message" >> $directory/../../logs/output.log
}

APPROVED_USERS=""
APPROVED_SUDOS=""

UID_MIN=$(awk '/^UID_MIN/ {print $2}' /etc/login.defs)
UID_MAX=$(awk '/^UID_MAX/ {print $2}' /etc/login.defs)

################################################################################################
# Getting lists of users                                                                       #
################################################################################################

echo "Input users manually? (y/n)" 
read yninput

#User will manually allowed users
if [ $yninput == "y" ]; then
    #Let user input all allowed users
    while true
    do
        #User inputs a new user
        echo "Enter approved users (not admins) (EXIT to break): "
        read okuser

        #Exit case
        if [ $okuser == "EXIT" ]; then
            break
        
        #Append the approved user to the list of good users
        else
            APPROVED_USERS="$APPROVED_USERS,$okuser"
        fi
    done

    #Let user input all allowed admins
    while true
    do
        #User inputs a new user
        echo "Enter approved admins (EXIT to break): "
        read okadmin

        #Exit case
        if [ $okadmin == "EXIT" ]; then
            break
    
        #Append the approved admin to the list of good users AND admins
        else
            APPROVED_SUDOS="$APPROVED_SUDOS,$okadmin"
            APPROVED_USERS="$APPROVED_USERS,$okadmin"
        fi
    done

else
    rm -rf temp
    mkdir temp

    readme_path="/home/$(getent passwd $SUDO_USER | cut -d ":" -f 1)/Desktop/README.desktop"

    wget -q -P temp/readme $(cat $readme_path | grep "^Exec" | cut -d " " -f 2 | sed 's/"//g') 

    admins_raw=$(cat temp/readme/*.* | sed -n '/^<h2>Authorized Administrators and Users<\/h2>.*$/,/^<\/pre>.*$/p' | sed -n '/^<pre>.*$/,/^<\/pre>.*$/p' | sed -n '/^Authorized Administrators:.*$/,/^<b>Authorized Users:<\/b>.*$/p' | sed '1d;$d' | grep -v "password: " | cut -d " " -f 1 | grep -v "^[[:space:]]*$" | sed 's/[[:space:]]*//g' | paste -s -d, -)
    users_raw=$(cat temp/readme/*.* | sed -n '/^<h2>Authorized Administrators and Users<\/h2>.*$/,/^<\/pre>.*$/p' | sed -n '/^<pre>.*$/,/^<\/pre>.*$/p' | sed -n '/^<b>Authorized Users:<\/b>.*$/,/^<\/pre>.*$/p' | sed '1d;$d' | sed 's/[[:space:]]*//g' | paste -s -d, -)

    APPROVED_USERS="$admins_raw,$users_raw"
    APPROVED_SUDOS=$admins_raw
fi

################################################################################################
# User presence/roles scans                                                                    #
################################################################################################

#Scan for unauthorized users
for real_user in $(awk -F':' -v "min=$UID_MIN" -v "max=$UID_MAX" '{ if ( $3 >= min && $3 <= max ) print $0}' /etc/passwd | cut -d ":" -f 1)
do
    #Check if the user is authorized
    if [[ ",$APPROVED_USERS," = *",$real_user,"* ]]
    then
        echo "Cool" > /dev/null
    else
        output_log "USR" "User $real_user is not in the approved users list"
    fi
done

#Scan for unauthorized administrators
real_admins=$(getent group sudo | cut -d ":" -f 4)

for real_admin in ${real_admins//,/ }
do
    #Check if the admin is authorized
    if [[ ",$APPROVED_SUDOS," = *",$real_admin,"* ]]
    then
        echo "Cool" > /dev/null
    else
        output_log "USR" "User $real_admin is not in the approved sudoers list"
    fi
done

#Scan for missing administrators
for approved_admin in ${APPROVED_SUDOS//,/ }
do
    #Check if the user is already an admin
    if [[ ",$real_admins," = *",$approved_admin,"* ]]
    then
        echo "Cool" > /dev/null
    else
        output_log "USR" "User $approved_admin is in the approved sudoers list but is not in the sudoers list"
    fi
done

################################################################################################
# User setting scans                                                                           #
################################################################################################

real_users=$(awk -F':' -v "min=$UID_MIN" -v "max=$UID_MAX" '{ if ( $3 >= min && $3 <= max ) print $0}' /etc/passwd | cut -d ":" -f 1 | paste -s -d, -)

for passwd_entry in $(getent passwd)
do
    #The first parameter is the username
    real_user=$(echo $passwd_entry | cut -d ":" -f 1)


    #The third parameter is the user id of the user
    user_id=$(echo $passwd_entry | cut -d ":" -f 3)
    
    #Perform UID checks
    if [ "$user_id" == "0" ] && [ "$real_user" != "root" ]
    then
        output_log "USR" "User $real_user has UID 0. $real_user may be an unauthorized user if it was not already flagged."
    fi


    #The fourth parameter is the group id of the user
    group_id=$(echo $passwd_entry | cut -d ":" -f 4)

    #Perform GID checks
    if [ "$group_id" == "0" ] && [ "$real_user" != "root" ]
    then
        output_log "USR" "User $real_user has GID 0"
    fi


    #The sixth parameter is the home path of the user, if they have one
    user_home_path=$(echo $passwd_entry | cut -d ":" -f 6)

    #Perform home path checks
    if [[ "$user_home_path" =~ "^/home/" ]] && [ "$real_user" != "root" ]
    then
        output_log "USR" "User $real_user home path is not located in /home"
    fi


    #The seventh parameter is the shell of the user
    user_shell=$(echo $passwd_entry | cut -d ":" -f 7 | sed 's/[[:space:]]*//g')
    
    #Perform shell checks
    if [ "$user_shell" != "/bin/bash" ] && [[ ",$real_users," = *",$real_user,"* ]]
    then
    	output_log "USR" "$real_user shell is not bash"
    fi
done

#Perform shadow checks
real_users="$real_users,root"

for real_user in ${real_users//,/ }
do
    users_password=$(getent shadow $real_user | cut -d ":" -f 2)

    if [ ${#users_password} -le "1" ]
    then
        output_log "USR" "$real_user does not have a password"
    fi
done

#Perform password complexity checks
admin_passwords_raw=$(cat temp/readme/*.* | sed -n '/^<h2>Authorized Administrators and Users<\/h2>.*$/,/^<\/pre>.*$/p' | sed -n '/^<pre>.*$/,/^<\/pre>.*$/p' | sed -n '/^Authorized Administrators:.*$/,/^<b>Authorized Users:<\/b>.*$/p' | grep "password:" | sed 's/[[:space:]]*//g' | sed 's/password://g' | paste -s -d, -)

index=1

for admin in ${APPROVED_SUDOS//,/ }
do
    admins_password=$(echo $admin_passwords_raw | cut -d "," -f $index)
    
    if [ ${#admins_password} -lt 10 ]; then
        output_log "USR" "$admin's password failed complexity checks"
    elif [[ $admins_password != *[A-Z]* ]]; then
        output_log "USR" "$admin's password failed complexity checks"
    elif [[ $admins_password != *[a-z]* ]]; then
        output_log "USR" "$admin's password failed complexity checks"
    elif [[ $admins_password != *[0-9]* ]]; then
        output_log "USR" "$admin's password failed complexity checks"
    fi

    ((index+=1))
done