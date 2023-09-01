#Creating blank lists for approved users
APPROVED_USERS=""
APPROVED_SUDOS=""

#Let user input all allowed users
while true
do
    #User inputs a new user
    echo "Enter approved users (not admins) (EXIT to break): "
    read okuser

    #Exit case
    if [ $VERSION == "EXIT" ]; then
        break
    
    #Append the approved user to the list of good users
    else
        APPROVED_USERS="$(APPROVED_USERS),$(okuser)"
    fi
done

#Let user input all allowed users
while true
do
    #User inputs a new user
    echo "Enter approved users (not admins) (EXIT to break): "
    read okuser

    #Exit case
    if [ $VERSION == "EXIT" ]; then
        break
    
    #Append the approved user to the list of good users
    else
        APPROVED_USERS="$(APPROVED_USERS),$(okuser)"
    fi
done

#Let user input all allowed admins
while true
do
    #User inputs a new user
    echo "Enter approved admins (EXIT to break): "
    read okadmin

    #Exit case
    if [ $VERSION == "EXIT" ]; then
        break
    
    #Append the approved admin to the list of good users AND admins
    else
        APPROVED_SUDOS="$(APPROVED_SUDOS),$(okadmin)"
        APPROVED_USERS="$(APPROVED_USERS),$(okadmin)"
    fi
done


for approved_user in $(echo $APPROVED_USERS | cut -d "," -f 1)
do
    passwd_entry=$(cat /etc/passwd | grep -E "^$approved_user")

    #The second parameter is whether or not the user is in /etc/shadow
    user_has_shadow=$(echo $passwd_entry | cut -d " " -f 2)

    #Perform shadow checks?

    #The third parameter is the user id of the user
    user_id=$(echo $passwd_entry | cut -d " " -f 3)
    
    #Perform UID checks

    #The fourth parameter is the group id of the user
    group_id=$(echo $passwd_entry | cut -d " " -f 4)

    #Perform GID checks?

    #The fifth parameter is GECOS - as far as I know, this is just comments
    user_gecos=$(echo $passwd_entry | cut -d " " -f 5)

    #The sixth parameter is the home path of the user, if they have one
    user_home_path=$(echo $passwd_entry | cut -d " " -f 6)

    #Perform home path checks
    
    #The seventh parameter is the shell of the user - most probably /sbin/nologin
    user_shell=$(echo $passwd_entry | cut -d " " -f 7)

    #Perform shell checks
done