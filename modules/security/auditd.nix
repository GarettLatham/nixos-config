{ config, pkgs, ... }:

{
  # 2) Linux audit framework (logs sensitive events)
  #   /* === ACCT-9632: auditd config discoverability ===
  #      Rationale: Ensure audit daemon and rule set clearly defined.
  #      Verify: `auditctl -l` and `grep -R . /etc/audit`.
  #   */
  security.audit.enable  = true;

  # Enable audit daemon + rules (Lynis [ACCT-9632])
  security.auditd.enable = true; # the userspace logger



  # Provide the daemon config file directly
  # Override the auditd config directly
  environment.etc."audit/auditd.conf".text = ''
    log_file = /var/log/audit/audit.log
    log_format = RAW
    flush = INCREMENTAL
    freq = 50

    space_left = 512
    admin_space_left = 128
    space_left_action = SYSLOG
    admin_space_left_action = SUSPEND

    max_log_file = 50
    max_log_file_action = ROTATE
    disk_full_action = SUSPEND
    disk_error_action = SUSPEND
  '';

  security.audit.rules = [
    "-w /etc/passwd -p wa -k identity"
    "-w /etc/group -p wa -k identity"
    "-w /etc/shadow -p wa -k identity"
    "-w /etc/sudoers -p wa -k scope"
    "-w /etc/sudoers.d/ -p wa -k scope"
    "-w /var/log/ -p wa -k logs"
    "-a always,exit -F arch=b64 -S adjtimex -S settimeofday -S clock_settime -k time-change"
    "-w /etc/localtime -p wa -k time-change"
    "-w /etc/ssh/sshd_config -p wa -k sshd"
    "-w /etc/sysctl.conf -p wa -k sysctl"
    "-w /etc/sysctl.d/ -p wa -k sysctl"
    "-a always,exit -F arch=b64 -S execve -S execveat -F uid>=1000 -F auid!=-1 -k exec"
  ];
}
