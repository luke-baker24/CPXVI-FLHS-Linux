#Files scan
cp $1/../../aide/general.conf /var/lib/aide/aide.conf

cp $1/../../aide/general.db /var/lib/aide/aide.db

aide --check --config=/var/lib/aide/aide.conf >> $1/../../logs/general-aide.log

#Etc scan
cp $1/../../aide/polcheck.conf /var/lib/aide/aide.conf

cp $1/../../aide/polcheck.db /var/lib/aide/aide.db

aide --check --config=/var/lib/aide/aide.conf >> $1/../../logs/policy-aide.log

#Home directories scan