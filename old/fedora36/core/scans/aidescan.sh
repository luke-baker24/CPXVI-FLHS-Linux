#1.3.1 - AIDE scan
cp aide/aide.conf /var/lib/aide/aide.conf

cp aide/aide.db /etc/aide.db

echo "
=====================================================================
Running an aide scan
=====================================================================
" >> $1/fluff.log

sudo aide --check --config=/var/lib/aide/aide.conf >> $1/fluff.log
