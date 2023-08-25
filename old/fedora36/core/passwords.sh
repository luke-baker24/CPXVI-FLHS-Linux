echo "
=====================================================================
Changing user passwords
=====================================================================
" >> $1/fluff.log

getent passwd | egrep ":[0-9][0-9][0-9][0-9]:" | while IFS=: read -r name password uid gid gecos home shell; do
    printf "Th1s1sS3cur34Sur3!\nTh1s1sS3cur34Sur3!" | passwd "$name"  
    chage -m 7 -M 90 -W 14 "$name"
done

#1.4.4
printf "Th1s1sS3cur34Sur3!\nTh1s1sS3cur34Sur3!" | passwd root

passwd -l root

#Forces accounts to use shadowed passwords
sed -e 's/^\([a-zA-Z0-9_]*\):[^:]*:/\1:x:/' -i /etc/passwd
