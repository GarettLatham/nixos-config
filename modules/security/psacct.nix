{ pkgs, ... }:
{
  # Enable BSD process accounting (accton). Requires the acct package.
  # Create the accounting file with safe perms via tmpfiles.d (no clashes with rules arrays)
  #systemd.tmpfiles.settings."psacct" = {
  #  "/var/log/pacct".f = {
  #    mode = "0600";
  #    user = "root";
  #    group = "root";
  #  };
  #};

  systemd.services.psacct-enable = {
    description = "Enable process accounting (accton)";
    wantedBy    = [ "multi-user.target" ];
    after       = [ "local-fs.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.acct}/sbin/accton /var/log/pacct";
    };
  };

  # If you DON'T already create /var/log/pacct in tmpfiles.nix, add this:
  # systemd.tmpfiles.rules = [ "f /var/log/pacct 0600 root root -" ];
}
