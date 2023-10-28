sysctl dev.tty.ldisc_autoload=0

sysctl fs.protected_fifos=2
sysctl fs.protected_hardlinks=1
sysctl fs.protected_symlinks=1
sysctl fs.suid_dumpable=0  #1.5.4
 
sysctl kernel.core_uses_pid=1  
sysctl kernel.ctrl-alt-del=0  
sysctl kernel.dmesg_restrict=1  
sysctl kernel.kptr_restrict=2  
sysctl kernel.randomize_va_space=2 #1.5.2
sysctl kernel.sysrq=0  
sysctl kernel.yama.ptrace_scope=1
sysctl kernel.modules_disabled=1
sysctl kernel.perf_event_paranoid=3 
sysctl kernel.unprivileged_bpf_disabled=1
 
sysctl net.core.bpf_jit_harden=2
 
sysctl net.ipv4.conf.all.accept_redirects=0 #3.3.2
sysctl net.ipv4.conf.all.accept_source_route=0 #3.3.1
sysctl net.ipv4.conf.all.bootp_relay=0 
sysctl net.ipv4.conf.all.forwarding=0 
sysctl net.ipv4.conf.all.log_martians=1 #3.3.4
sysctl net.ipv4.conf.all.mc_forwarding=0 
sysctl net.ipv4.conf.all.proxy_arp=0 
sysctl net.ipv4.conf.all.rp_filter=1  #3.3.7
sysctl net.ipv4.conf.all.send_redirects=0   #3.2.1
sysctl net.ipv4.conf.default.accept_redirects=0  #3.3.2
sysctl net.ipv4.conf.default.accept_source_route=0  #3.3.1
sysctl net.ipv4.conf.default.log_martians=1  #3.3.4
sysctl net.ipv4.icmp_echo_ignore_broadcasts=1  #3.3.5
sysctl net.ipv4.icmp_ignore_bogus_error_responses=1  #3.3.6
sysctl net.ipv4.tcp_syncookies=1  #3.3.8
sysctl net.ipv4.tcp_timestamps=0   
sysctl net.ipv4.conf.all.secure_redirects=0  #3.3.3
sysctl net.ipv4.conf.default.secure_redirects=0  #3.3.3
sysctl net.ipv4.conf.default.rp_filter=1  #3.3.7
sysctl net.ipv4.conf.default.send_redirects=0   #3.2.1
sysctl net.ipv4.route.flush=1   #3.2.1, 3.3.1, 3.3.2, 3.3.3, 3.3.4, 3.3.5, 3.3.6, 3.3.7, 3.3.8
 
sysctl net.ipv6.conf.all.accept_redirects=0  #3.3.2
sysctl net.ipv6.conf.all.accept_source_route=0  #3.3.1
sysctl net.ipv6.conf.default.accept_redirects=0  #3.3.2
sysctl net.ipv6.conf.default.accept_source_route=0  #3.3.1
sysctl net.ipv6.conf.all.accept_ra=0  #3.3.9
sysctl net.ipv6.conf.default.accept_ra=0  #3.3.9
sysctl net.ipv6.conf.all.disable_ipv6=1  #3.1.1
sysctl net.ipv6.conf.default.disable_ipv6=1  #3.1.1
sysctl net.ipv6.route.flush=1  #3.1.1, 3.3.1, 3.3.2, 3.3.9
 
sysctl net.ipv4.tcp_max_syn_backlog=4096