{ pkgs, ... }:

let
  outDir = "/var/log/vulnix";
in {
  environment.systemPackages = [ pkgs.vulnix ];

  systemd.tmpfiles.rules = [
    "d ${outDir} 0750 root root -"
  ];

  # One-shot scan service
  systemd.services.vulnix-scan = {
    description = "Vulnerability scan of installed Nix store paths";
    serviceConfig = {
      Type = "oneshot";
      # Note: --dbdir keeps a local cache; adjust if you want to pin or proxy
      ExecStart = "${pkgs.vulnix}/bin/vulnix --system --json > ${outDir}/last.json";
      # optional text report too:
      ExecStartPost = "${pkgs.vulnix}/bin/vulnix --system > ${outDir}/last.txt";
      # network + certs available in normal boot
      PrivateTmp = true;
    };
  };

  # Weekly timer (runs at 03:30 Sunday)
  systemd.timers.vulnix-scan = {
    description = "Weekly vulnix scan";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "Sun *-*-* 03:30:00";
      Persistent = true;
    };
  };
}
