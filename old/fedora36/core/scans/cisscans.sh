echo "
=====================================================================
Running miscellaneous CIS scans
=====================================================================
" >> $1/flush.log

#Miscellaneous CIS audits - TODO FINISH THESE UP!!!!!!
echo "[SCAN] Ensure no files are returned. Otherwise, find them and fix them by running chmod o-w [filename].
${df --local -P | awk '{if (NR!=1) print $6}' | xargs -I '{}' find '{}' -xdev -type f -perm -0002}" >> $1/flush.log


echo "[SCAN] Ensure no files are returned. Otherwise, find them and fix them by chown-ing them.
" >> $1/flush.log
echo $(df --local -P | awk {'if (NR!=1) print $6'} | xargs -I '{}' find '{}' -xdev -nouser) >> $1/flush.log
echo $(df --local -P | awk '{if (NR!=1) print $6}' | xargs -I '{}' find '{}' -xdev -nogroup) >> $1/flush.log


echo "[SCAN] Look for any suspicious SUID/SGID binaries, and remove them if suspicious.
" >> $1/flush.log
echo $(df --local -P | awk '{if (NR!=1) print $6}' | xargs -I '{}' sudo find '{}' -xdev -type f -perm -4000) >> $1/flush.log
echo $(df --local -P | awk '{if (NR!=1) print $6}' | xargs -I '{}' find '{}' -xdev -type f -perm -2000) >> $1/flush.log
#Check that root is the only one with uid 0

echo "[SCAN] If user returned, lock the account and give them a password." >> $1/flush.log
awk -F: '($2 == "" ) { print $1 " does not have a password "}' /etc/shadow >> $1/flush.log

echo "[SCAN] Run the command in passwords.sh to enforce using shadowed passwords." >> $1/flush.log
awk -F: '($2 != "x" ) { print $1 " is not set to shadowed passwords "}' /etc/passwd >> $1/flush.log

echo "[SCAN] Looking for inconsistenties between /etc/passwd and /etc/group"
for i in $(cut -s -d: -f4 /etc/passwd | sort -u ); do
    grep -q -P "^.*?:[^:]*:$i:" /etc/group
    if [ $? -ne 0 ]; then
        echo "Group $i is referenced by /etc/passwd but does not exist in /etc/group" >> $1/flush.log
    fi
done

echo "[SCAN] Ensure root is the only result returned. Otherwise, a user has UID 0." >> $1/flush.log
awk -F: '($3 == 0) { print $1 }' /etc/passwd >> $1/flush.log

echo "[SCAN] Verify no results are returned, otherwise correct the respective PATH."  >> $1/flush.log
RPCV="$(sudo -Hiu root env | grep '^PATH' | cut -d= -f2)"
echo "$RPCV" | grep -q "::" && echo "root's path contains a empty directory (::)"  >> $1/flush.log
echo "$RPCV" | grep -q ":$" && echo "root's path contains a trailing (:)"  >> $1/flush.log
for x in $(echo "$RPCV" | tr ":" " "); do
    if [ -d "$x" ]; then
        ls -ldH "$x" | awk '$9 == "." {print "PATH contains current working directory (.)"}
        $3 != "root" {print $9, "is not owned by root"}
        substr($1,6,1) != "-" {print $9, "is group writable"}
        substr($1,9,1) != "-" {print $9, "is world writable"}'  >> $1/flush.log
    else
        echo "$x is not a directory" >> $1/flush.log
    fi
done

echo "[SCAN] Ensure there are no results returned, otherwise change user UIDs."  >> $1/flush.log
cut -f3 -d":" /etc/passwd | sort -n | uniq -c | while read x ; do
    [ -z "$x" ] && break
    set - $x
    if [ $1 -gt 1 ]; then
        users=$(awk -F: '($3 == n) { print $1 }' n=$2 /etc/passwd | xargs)
        echo "Duplicate UID ($2): $users"  >> $1/flush.log
    fi
done

echo "[SCAN] Ensure there are no groups returned."  >> $1/flush.log
cut -d: -f3 /etc/group | sort | uniq -d | while read x ; do
    echo "Duplicate GID ($x) in /etc/group"  >> $1/flush.log
done

echo "Ensure there are no names returned."  >> $1/flush.log
cut -d: -f1 /etc/passwd | sort | uniq -d | while read -r x; do
    echo "Duplicate login name $x in /etc/passwd"  >> $1/flush.log
done

echo "Ensure no strange keys are returned - the 2012 and 2018 keys are fine, if there are 3 this is probably a finding."  >> $1/flush.log
apt-key list  >> $1/flush.log