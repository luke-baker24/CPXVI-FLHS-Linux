#3.5.1.1
apt install ufw

#3.5.1.7
ufw default deny incoming
ufw default allow outgoing #should be deny according to CIS but that literally denies everything
ufw default deny routed

#note: configure more ports, also 3.5.1.7 may make backdoors harder to find
ufw allow git
ufw allow in http
ufw allow in https
ufw allow out 53
ufw logging on

ufw enable