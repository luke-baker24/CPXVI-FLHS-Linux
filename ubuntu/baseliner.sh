#Files db
cp $directory/../../aide/general.conf /var/lib/aide/aide.conf

aide --init --config=/var/lib/aide/aide.conf

cp /var/lib/aide/aide.db.new $directory/../../new-baselines/general.db

#Etc db
cp $directory/../../aide/polcheck.conf /var/lib/aide/aide.conf

aide --init --config=/var/lib/aide/aide.config

cp /var/lib/aide/aide.db.new $directory/../../new-baselines/polcheck.db

#Etc copied
cp -r /etc/ $directory/../../new-baselines/etc/

#Package baseline
apt list --installed 2>/dev/null | tail -n +2 | cut -d "/" -f 1 > $directory/../../new-baselines/package-whitelist

#Snap baseline
if [[ $(which snap ) ]]
then
    snap list | cut -d $'\t' -f 1 | cut -d " " -f 1 | tail +2 > $directory/../../new-baselines/snap-whitelist
fi

#Home folders baseline
mkdir $directory/../../new-baselines/home_skeleton

for home_file in $(find /home/*/* -type f -maxdepth 1)
do
    cp home_file $directory/../../new-baselines/home_skeleton
done

for home_directory in $(find /home/*/* -type d -maxdepth 1)
do
    cp home_directory $directory/../../new-baselines/home_skeleton
done