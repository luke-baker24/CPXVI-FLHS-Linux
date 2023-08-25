olddir=$(pwd)
desktop=$olddir/../../../Desktop

#Packages scan
touch $desktop/packagescan.txt
echo "" > $desktop/packagescan.txt
while read app
do
    if grep -q -wi "$app" packagebaseline.txt; then
        echo "O $app"
    else
        echo "X $app" >> $desktop/packagescan.txt
    fi
done < <(apt list --installed | cut -f 1 -d "/" | tail -n +2)

#Services scan
touch $desktop/servicescan.txt
echo "" > $desktop/servicescan.txt
while read service
do
    if grep -q -wi "$service" servicebaseline.txt; then
        echo "O $service"
    else
        echo "X $service" >> $desktop/servicescan.txt
    fi
done < <(systemctl list-units --type=service | grep ".service" | sed 's/  */ /g' | sed 's/ //')

#Lynis scan
wget https://downloads.cisofy.com/lynis/lynis-3.0.8.tar.gz
tar xfvz lynis-3.0.8.tar.gz > /dev/null 2>&1 
cd $olddir/lynis/
./lynis audit system --no-colors > $desktop/lynis.txt

#Netstat scan
apt install net-tools -y

netstat -alpn | grep LISTEN > $desktop/netstat.txt

#Rkhunter scan
apt install rkhunter -y

rkhunter --check > /home/rkhunter.txt

#Clamscan
apt install clamav -y

clamscan -r /

#Miscellaneous CIS scans
echo "INSTRUCTIONS: Ensure no files are returned. Otherwise, find them and fix them by running chmod o-w [filename].

${df --local -P | awk '{if (NR!=1) print $6}' | xargs -I '{}' find '{}' -xdev -type f -perm -0002}" > $desktop/wwfiles.txt

echo "INSTRUCTIONS: Ensure no files are returned. Otherwise, find them and fix them by chown-ing them.
" > $desktop/noownfiles.txt
echo $(df --local -P | awk {'if (NR!=1) print $6'} | xargs -I '{}' find '{}' -xdev -nouser) >> $desktop/noownfiles.txt
echo $(df --local -P | awk '{if (NR!=1) print $6}' | xargs -I '{}' find '{}' -xdev -nogroup) >> $desktop/noownfiles.txt

echo "INSTRUCTIONS: Look for any suspicious SUID binaries, and remove them if suspicious.
" > $desktop/suids.txt
echo $(sudo df --local -P | awk '{if (NR!=1) print $6}' | xargs -I '{}' sudo find '{}' -xdev -type f -perm -4000) >> $desktop/suids.txt
