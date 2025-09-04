{ config, pkgs, lib, ... }:

{
  systemd.tmpfiles.rules = [
    "d /var/log/chkrootkit 0750 root root -"
    "d /var/lib/aide 0750 root root -"
    "d /var/log/aide 0750 root root -"
    "f /var/log/pacct 0600 root root -"
    "d /etc/wpa_supplicant 0750 root root -"
    "d /var/log/audit 0750 root root -"
    "d /usr/lib/security 0755 root root -"
    "d /lib/security 0755 root root -"
    "d /lib64/security 0755 root root -"
    "L /usr/lib/security/pam_passwdqc.so - - - - ${pkgs.passwdqc}/lib/security/pam_passwdqc.so"
    "L /lib/security/pam_passwdqc.so - - - - ${pkgs.passwdqc}/lib/security/pam_passwdqc.so"
    "L /lib64/security/pam_passwdqc.so - - - - ${pkgs.passwdqc}/lib/security/pam_passwdqc.so"
  ];
}
