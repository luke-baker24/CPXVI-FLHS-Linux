#Hardening GNOME
#Settings viewed from https://help.gnome.org/admin/gdm/stable/configuration.html.en
#1.8.4 is the Enable=false

cp /etc/gdm3/custom.conf custom.conf

cat custom.conf | grep -v "WaylandEnable" | grep -v "TimedLoginEnable" | sed 's/\[daemon\]/\[daemon\]\nWaylandEnable=true\nTimedLoginEnable=false\nXorgEnable=false\nPreferredDisplayServer=wayland/' | tee custom.conf
cat custom.conf | grep -v "DisallowTCP" | sed 's/\[security\]/\[security\]\nDisallowTCP=true\nAllowRemoteAutoLogin=false/' | tee custom.conf
cat custom.conf | grep -v "DisplaysPerHost" | sed 's/\[xdmcp\]/\[xdmcp\]\DisplaysPerHost=1\nEnable=false\nMaxPending=0\nMaxSessions=0/' | tee custom.conf

cat custom.conf | grep -v "\[greeter\]" | grep -v "IncludeAll" | tee custom.conf
echo "[greeter]
IncludeAll=false" | tee -a custom.conf

#echo "user-db:user
#system-db:local
#system-db:site
#system-db:distro" > /etc/dconf/profile/user


#gsettings set org.gnome.desktop.session autostart-enabled false
#gsettings set org.gnome.system.proxy mode 'manual'
#gsettings set org.gnome.desktop.privacy encrypt-new true
#gsettings set org.gnome.CrashReporter enable false
#gsettings set org.gnome.desktop.app-armor enabled true

gsettings set com.canonical.unity.desktop.screensaver show-notifications true
gsettings set com.ubuntu.SoftwareProperties ubuntu-pro-banner-visible false
gsettings set com.ubuntu.touch.system activity-timeout 300
gsettings set com.ubuntu.update-notifier end-system-uids 999
gsettings set com.ubuntu.update-notifier end-system-uids 999
gsettings set com.ubuntu.update-notifier no-show-notifications false
gsettings set com.ubuntu.update-notifier regular-auto-launch-interval 1
gsettings set com.ubuntu.update-notifier show-apport-crashes true
gsettings set com.ubuntu.update-notifier show-livepatch-status-icon true
gsettings set org.freedesktop.miner.files low-disk-space-limit 95
gsettings set org.gnome.control-center show-development-warning true
#left off at org/gnome/desktop

gsettings set org.gnome.desktop.screensaver lock-enabled true
gsettings set org.gnome.desktop.screensaver lock-delay 300
gsettings set org.gnome.desktop.screensaver user-password-required true
gsettings set org.gnome.login-screen disable-user-list true



#1.8.2-1.8.3
#echo "[org/gnome/login-screen]" >> /etc/gdm3/greeter.dconf-defaults
#echo "banner-message-enable=true" >> /etc/gdm3/greeter.dconf-defaults
#echo "banner-message-text='Hello World'" >> /etc/gdm3/greeter.dconf-defaults
#echo "disable-user-list=true" >> /etc/gdm3/greeter.dconf-defaults

dpkg-reconfigure gdm3

if [ $(wc -l < custom.conf) -ge 10 ]
then
    cp custom.conf /etc/gdm3/custom.conf
    rm custom.conf

    exit
else
    ./gnome.sh
fi