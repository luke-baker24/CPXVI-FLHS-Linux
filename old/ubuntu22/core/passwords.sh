echo "
=====================================================================
Changing user passwords
=====================================================================
" >> $1/flush.log

getent passwd | egrep ":[0-9][0-9][0-9][0-9]:" | while IFS=: read -r name password uid gid gecos home shell; do
    printf "Th1s1sS3cur34Sur3!\nTh1s1sS3cur34Sur3!" | passwd "$name"  
    chage -m 7 -M 90 -W 14 "$name"
done