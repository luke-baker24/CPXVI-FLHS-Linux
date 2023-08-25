echo "
=====================================================================
Running updates
=====================================================================
" >> $1/flush.log

cp baselines/sources.list /etc/apt/sources.list >> $1/flush.log 

rm -r /etc/apt/sources.list.d/* >> $1/flush.log

echo "[PROGRESS] sources.list has been overwritten" >> $1/flush.log

for package in $(apt-mark showhold)
do
    apt-mark unhold $package
    echo "[PROGRESS] $package has been unheld" >> $1/flush.log
done

apt update -y
apt dist-upgrade -y

echo "[PROGRESS] Updates have run successfully" >> $1/flush.log