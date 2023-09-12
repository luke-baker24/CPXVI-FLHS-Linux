#Apt package scan

whitelist=""

while read package; do
    if [[ $(apt list --installed | grep $package) ]]; then
        whitelist="$whitelist:$(apt-cache depends --no-suggests --no-breaks --no-conflicts --no-replaces --recurse $package | grep -v '<' | rev | cut -d ' ' -f -1 | rev | cut -d ':' -f 1 | sort -u | sed 's/\$/\|/')"
    fi
done < metapackages.txt

echo $whitelist | tr " " "\n" > whitelist.txt

apt list --installed | cut -d "/" -f 1 > installedpackages.txt

grep -v -f whitelist.txt installedpackages.txt


#File directories

#/bin: stores important command binaries (no subdirectories)
    #Most files initialized with major upgrades or installs
    #Installedpplications will get command files in bin
#/sbin: contains important admin commands, should only be modified by root
    #Shouldn't really be anything super recent in there.


#/lib: very important dynamic libraries & kernel modules
    #RESEARCH HEAVILY

#/boot: files needed to start the system
    #RESEARCH HEAVILY



#/etc: system-global configuration files
    #Holy cow so much here
    #RESEARCH
    #RESEARCH
    #RESEARCH

#/home: user home directories
    #Scan, but should be easier to scan - look for any files not in the standard home dir
#/root: root's home directory


#/media: mount point for external devices
    #Just see if anything's there that shouldn't be - should be essentially empty
#/mnt: temporary mount points, like network filesystems
    #Just see if anything's there that shouldn't be - should be entirely empty
#/dev: device files for hardware devices
    #RESEARCH MORE



#/srv: contains directories for services
    #Just see if anything's there that shouldn't be - should be entirely empty
    #Unless a crit service uses it
#/opt: additional software for the system

#/sys: virtual filesystem for the kernel's view
#/proc: running processes


#/usr: contains user utilities and applications, and replicates the root directory structure


#/tmp: temporary files used by applications
#/run: temporary filesystem for booting


#/var: contains variable data, like logs, databases, websites, and spool files that PERSIST













