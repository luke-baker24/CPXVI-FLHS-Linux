#Hardening GNOME
#Settings viewed from https://help.gnome.org/admin/gdm/stable/configuration.html.en
#1.8.4 is the Enable=false
cat /etc/gdm3/custom.conf | grep -v "WaylandEnable" | grep -v "TimedLoginEnable" | sed 's/\[daemon\]/\[daemon\]\nWaylandEnable=false\nTimedLoginEnable=false/' | tee /etc/gdm3/custom.conf
cat /etc/gdm3/custom.conf | grep -v "DisallowTCP" | sed 's/\[security\]/\[security\]\nDisallowTCP=true/' | tee /etc/gdm3/custom.conf
cat /etc/gdm3/custom.conf | grep -v "DisplaysPerHost" | sed 's/\[xdmcp\]/\[xdmcp\]\DisplaysPerHost=1\nEnable=false\nMaxPending=0\nMaxSessions=0/'

#Configure xdmcp Willing
#/apps/gdm/simple-greeter/disable_user_list should be false

echo "[greeter]
IncludeAll=false" >> /etc/gdm3/custom.conf

#1.8.2-1.8.3
#echo "[org/gnome/login-screen]" >> /etc/gdm3/greeter.dconf-defaults
#echo "banner-message-enable=true" >> /etc/gdm3/greeter.dconf-defaults
#echo "banner-message-text='Hello World'" >> /etc/gdm3/greeter.dconf-defaults
#echo "disable-user-list=true" >> /etc/gdm3/greeter.dconf-defaults

dpkg-reconfigure gdm3