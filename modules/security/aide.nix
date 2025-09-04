{ config, pkgs, ... }:
{

  # AIDE config
  environment.etc."aide.conf".text = ''
    database_in=file:/var/lib/aide/aide.db
    database_out=file:/var/lib/aide/aide.db.new
    gzip_dbout=yes
    report_url=file:/var/log/aide/aide.log
    NORMAL = p+i+n+u+g+s+m+c+acl+xattrs+sha512
    /boot NORMAL
    /etc  NORMAL
    /home NORMAL
    !/var/log(/.*)?$
    !/tmp(/.*)?$
    !/run(/.*)?$
    !/proc(/.*)?$
    !/sys(/.*)?$
    !/dev(/.*)?$
    !/nix(/.*)?$
  '';

   # One-time DB initialization; run once after enabling
  systemd.services.aide-init = {
    description = "Initialize AIDE database";
    wantedBy = [ "multi-user.target" ];
    after = [ "local-fs.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.aide}/bin/aide --init -c /etc/aide.conf";
    };
  };

  # Daily check (writes to /var/log/aide/aide.log)
  systemd.services.aide-check = {
    description = "AIDE integrity check";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.aide}/bin/aide --check -c /etc/aide.conf";
    };
  };

  systemd.timers.aide-check = {
    description = "Daily AIDE integrity check";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
    };
  };
}
