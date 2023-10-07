#Files scan
cp $directory/../../aide/general.conf /var/lib/aide/aide.conf

cp $directory/../../aide/general.db /var/lib/aide/aide.db

aide --check --config=/var/lib/aide/aide.conf >> $directory/../../logs/general-aide.log

#Etc scan
cp $directory/../../aide/polcheck.conf /var/lib/aide/aide.conf

cp $directory/../../aide/polcheck.db /var/lib/aide/aide.db

aide --check --config=/var/lib/aide/aide.conf >> $directory/../../logs/policy-aide.log

#Home directories scan