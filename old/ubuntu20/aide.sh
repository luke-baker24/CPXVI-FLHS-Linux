#1.3.1 - AIDE scan
apt install aide -y

cp aide.db /var/lib/aide/aide.db

aideinit

#echo "0 5 * * * root /usr/bin/aide.wrapper --config /etc/aide/aide.conf --check" >> /etc/crontab

aide -c aide.conf --check > $desktop/aide.txt

#Need to configure aide
aideinit
mv /var/lib/aide/aide.db.new /var/lib/aide/aide.db