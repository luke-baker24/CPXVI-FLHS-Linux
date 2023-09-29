#Aide scan
cp aide/aide.conf /var/lib/aide/aide.conf

cp aide/aide.db /var/lib/aide/aide.db

aide --check --config=/var/lib/aide/aide.conf >> $directory/../../logs/aide.log

#Home directories scan