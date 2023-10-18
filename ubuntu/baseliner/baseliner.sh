mkdir new-baselines

#Files db
cp ../aide/general.conf /var/lib/aide/aide.conf

aide --init --config=/var/lib/aide/aide.conf

cp /var/lib/aide/aide.db.new ./new-baselines/general.db

#Etc db
cp ../aide/polcheck.conf /var/lib/aide/aide.conf

aide --init --config=/var/lib/aide/aide.conf

cp /var/lib/aide/aide.db.new ./new-baselines/polcheck.db

#Etc copied
cp -r /etc/ ../new-baselines/etc/

#Package baseline
apt list --installed 2>/dev/null | tail -n +2 | cut -d "/" -f 1 > ./new-baselines/package-whitelist

#Snap baseline
if [[ $(which snap ) ]]
then
    snap list | cut -d $'\t' -f 1 | cut -d " " -f 1 | tail +2 > ./new-baselines/snap-whitelist
fi

exit

#Home folders baseline
mkdir ./new-baselines/home_skeleton

for home_file in $(find /home/*/* -type f -maxdepth 1)
do
    cp home_file ./new-baselines/home_skeleton
done

for home_directory in $(find /home/*/* -type d -maxdepth 1)
do
    cp home_directory ./new-baselines/home_skeleton
done

