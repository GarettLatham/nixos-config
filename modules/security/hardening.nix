{ ... }:

{
    #   /* === NETW-3200: Disable uncommon network protocols ===
    #      Rationale: Minimize kernel attack surface for unused stacks.
    #      Verify: `lsmod | egrep "dccp|sctp|rds|tipc"` -> no results.
    #   */
    boot.blacklistedKernelModules = [ "dccp" "sctp" "rds" "tipc" ];

    boot.kernel.sysctl = {
        "kernel.dmesg_restrict" = 1;
        "kernel.kptr_restrict" = 2;
        "kernel.unprivileged_bpf_disabled" = 1;
        "kernel.yama.ptrace_scope" = 1;

        "fs.protected_hardlinks" = 1;
        "fs.protected_symlinks" = 1;
        "fs.protected_fifos" = 2;
        "fs.protected_regular" = 2;
        "fs.suid_dumpable" = 0;
        # IPv4
        "net.ipv4.conf.all.accept_redirects" = 0;
        "net.ipv4.conf.default.accept_redirects" = 0;
        "net.ipv4.conf.all.send_redirects" = 0;
        "net.ipv4.conf.all.log_martians" = 1;
        "net.ipv4.conf.default.log_martians" = 1;
        "net.ipv4.conf.all.rp_filter" = 1;
        "net.ipv4.icmp_ignore_bogus_error_responses" = 1;
        "net.ipv4.icmp_echo_ignore_broadcasts" = 1;
        # IPv6
        "net.ipv6.conf.all.accept_redirects" = 0;
        "net.ipv6.conf.default.accept_redirects" = 0;
        "net.ipv6.conf.all.accept_source_route" = 0;
        "net.ipv6.conf.default.accept_source_route" = 0;
        # Optional: lock module loading post-boot (can break DKMS/external modules)
        # "kernel.modules_disabled" = 1;
        "dev.tty.ldisc_autoload" = 0;
        "net.core.bpf_jit_harden" = 2;
        "kernel.sysrq" = 0;
    };

    # Optional login banner you were using before
    environment.etc."issue".text =
        "Authorized access only. Disconnect now if you are not authorized.\n";
}
