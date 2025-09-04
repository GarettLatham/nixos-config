{ config, pkgs, ... }:

{
  services.journald = {
    storage = "persistent";
    extraConfig = ''
      SystemMaxUse=1G
      SystemMaxFileSize=100M
    '';
  };

  #   /* === LOGG-2146: Log rotation present ===
  #      Rationale: Ensure logs rotate to avoid disk fill.
  #      Verify: `systemctl status logrotate.timer` and `journalctl --disk-usage`.
  #   */
  services.logrotate.enable = true;
  services.logrotate.settings = {
    header = { dateext = true; };
    "/var/log/*.log" = {
      frequency    = "weekly";
      rotate       = 12;
      weekly       = true;
      compress     = true;
      missingok    = true;
      notifempty   = true;
      copytruncate = true;
      create       = "0640 root root";
    };
  };
}
