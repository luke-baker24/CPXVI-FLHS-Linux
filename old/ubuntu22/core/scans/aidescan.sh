#1.3.1 - AIDE scan
cp aide/aide.conf /var/lib/aide/aide.conf

cp aide/aide.db /var/lib/aide/aide.db

echo "
=====================================================================
Running an aide scan
=====================================================================
" >> $1/flush.log

sudo aide --check --config=/var/lib/aide/aide.conf >> $1/flush.log