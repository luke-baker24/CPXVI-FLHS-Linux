#/etc/sysctl.d/zzz-mysysctl.conf

echo "dev.tty.ldisc_autoload=0" >> /etc/sysctl.conf

echo "fs.protected_fifos=2" >> /etc/sysctl.conf
echo "fs.protected_hardlinks=1" >> /etc/sysctl.conf
echo "fs.protected_symlinks=1" >> /etc/sysctl.conf
echo "fs.suid_dumpable=0" >> /etc/sysctl.conf  #1.5.4

echo "kernel.core_uses_pid=1" >> /etc/sysctl.conf  
echo "kernel.ctrl-alt-del=0" >> /etc/sysctl.conf  
echo "kernel.dmesg_restrict=1" >> /etc/sysctl.conf  
echo "kernel.kptr_restrict=2" >> /etc/sysctl.conf  
echo "kernel.randomize_va_space=2" >> /etc/sysctl.conf #1.5.2
echo "kernel.sysrq=0" >> /etc/sysctl.conf  
echo "kernel.yama.ptrace_scope=1" >> /etc/sysctl.conf
echo "kernel.modules_disabled=1" >> /etc/sysctl.conf
echo "kernel.perf_event_paranoid=3" >> /etc/sysctl.conf 
echo "kernel.unprivileged_bpf_disabled=1" >> /etc/sysctl.conf

echo "net.core.bpf_jit_harden=2" >> /etc/sysctl.conf

echo "net.ipv4.conf.all.accept_redirects=0" >> /etc/sysctl.conf #3.3.2
echo "net.ipv4.conf.all.accept_source_route=0" >> /etc/sysctl.conf #3.3.1
echo "net.ipv4.conf.all.bootp_relay=0" >> /etc/sysctl.conf 
echo "net.ipv4.conf.all.forwarding=0" >> /etc/sysctl.conf 
echo "net.ipv4.conf.all.log_martians=1" >> /etc/sysctl.conf #3.3.4
echo "net.ipv4.conf.all.mc_forwarding=0" >> /etc/sysctl.conf 
echo "net.ipv4.conf.all.proxy_arp=0" >> /etc/sysctl.conf 
echo "net.ipv4.conf.all.rp_filter=1" >> /etc/sysctl.conf  #3.3.7
echo "net.ipv4.conf.all.send_redirects=0" >> /etc/sysctl.conf   #3.2.1
echo "net.ipv4.conf.default.accept_redirects=0" >> /etc/sysctl.conf  #3.3.2
echo "net.ipv4.conf.default.accept_source_route=0" >> /etc/sysctl.conf  #3.3.1
echo "net.ipv4.conf.default.log_martians=1" >> /etc/sysctl.conf  #3.3.4
echo "net.ipv4.icmp_echo_ignore_broadcasts=1" >> /etc/sysctl.conf  #3.3.5
echo "net.ipv4.icmp_ignore_bogus_error_responses=1" >> /etc/sysctl.conf  #3.3.6
echo "net.ipv4.tcp_syncookies=1" >> /etc/sysctl.conf  #3.3.8
echo "net.ipv4.tcp_timestamps=0" >> /etc/sysctl.conf   
echo "net.ipv4.conf.all.secure_redirects=0" >> /etc/sysctl.conf  #3.3.3
echo "net.ipv4.conf.default.secure_redirects=0" >> /etc/sysctl.conf  #3.3.3
echo "net.ipv4.conf.default.rp_filter=1" >> /etc/sysctl.conf  #3.3.7
echo "net.ipv4.conf.default.send_redirects=0" >> /etc/sysctl.conf   #3.2.1
echo "net.ipv4.route.flush=1" >> /etc/sysctl.conf   #3.2.1, 3.3.1, 3.3.2, 3.3.3, 3.3.4, 3.3.5, 3.3.6, 3.3.7, 3.3.8

echo "net.ipv6.conf.all.accept_redirects=0" >> /etc/sysctl.conf  #3.3.2
echo "net.ipv6.conf.all.accept_source_route=0" >> /etc/sysctl.conf  #3.3.1
echo "net.ipv6.conf.default.accept_redirects=0" >> /etc/sysctl.conf  #3.3.2
echo "net.ipv6.conf.default.accept_source_route=0" >> /etc/sysctl.conf  #3.3.1
echo "net.ipv6.conf.all.accept_ra=0" >> /etc/sysctl.conf  #3.3.9
echo "net.ipv6.conf.default.accept_ra=0" >> /etc/sysctl.conf  #3.3.9
echo "net.ipv6.conf.all.disable_ipv6=1" >> /etc/sysctl.conf  #3.1.1
echo "net.ipv6.conf.default.disable_ipv6=1" >> /etc/sysctl.conf  #3.1.1
echo "net.ipv6.route.flush=1" >> /etc/sysctl.conf  #3.1.1, 3.3.1, 3.3.2, 3.3.9

echo "net.ipv4.tcp_max_syn_backlog=4096" >> /etc/sysctl.conf


#Pulled from old ubuntu script
grep -Els "^\s*net\.ipv4\.ip_forward\s*=\s*1" /etc/sysctl.conf /etc/sysctl.d/*.conf /usr/lib/sysctl.d/*.conf /run/sysctl.d/*.conf | while read filename; do sed -ri "s/^\s*(net\.ipv4\.ip_forward\s*)(=)(\s*\S+\b).*$/#*REMOVED* \1/" $filename; done; sysctl -w net.ipv4.ip_forward=0; sysctl -w net.ipv4.route.flush=1

sysctl -p

#1.5.4
echo "Storage=none" >> /etc/systemd/coredump.conf
echo "ProcessSizeMax=0" >> /etc/systemd/coredump.conf

touch /etc/modprobe.d/blacklist.conf
echo "blacklist usb-storage" >> /etc/modprobe.d/blacklist.conf
