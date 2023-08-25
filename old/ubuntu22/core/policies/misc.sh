#1.7.2
echo "Authorized uses only. All activity may be monitored and reported." > /etc/issue

#1.7.3
echo "Authorized uses only. All activity may be monitored and reported." > /etc/issue.net

#1.7.1, 1.7.4
rm /etc/motd

#Adding a user timeout - this is from old script
touch /etc/profile.d/99-terminal_tmout.sh 
echo "TMOUT=600" | tee /etc/profile.d/99-terminal_tmout.sh

echo "* hard maxlogins 10" >> /etc/security/limits.conf

echo "* soft core 0
* hard core 0" > /etc/security/limits.conf

if command -v nmcli >/dev/null 2>&1 ; then
    nmcli radio all off
else
    if [ -n "$(find /sys/class/net/*/ -type d -name wireless)" ]; then
        mname=$(for driverdir in $(find /sys/class/net/*/ -type d -name wireless | xargs -0 dirname); do basename "$(readlink -f "$driverdir"/device/driver/module)";done | sort -u)
        for dm in $mname; do
            echo "install $dm /bin/true" >> /etc/modprobe.d/disable_wireless.conf
        done
    fi
fi