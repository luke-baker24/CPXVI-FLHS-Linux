#Changing user passwords to be more secure
if (whiptail --title "" --yesno "Want to change user passwords?" 8 78); then
    getent passwd | grep home |  cut -d: -f1 | grep -v cups-pk | grep -v syslog | while IFS=: read -r name password uid gid gecos home shell; do
        printf "Th1s1sS3cur34Sur3!\nTh1s1sS3cur34Sur3!" | passwd "$name"  
        #chage -m 7 -M 90 -W 14 "$name"
    done
else
    echo "Continuing..."
fi