{ config, pkgs, lib, ... }:
{
  systemd.services.chkrootkit-scan = {
    description = "Daily Rootkit Scan (chkrootkit)";
    unitConfig.OnFailure = [ "chkrootkit-alert@%n.service" ];
    serviceConfig = {
      Type = "oneshot";
      Environment = [
        "PATH=${lib.makeBinPath [
          pkgs.chkrootkit pkgs.coreutils pkgs.gawk pkgs.gnused pkgs.gnugrep
          pkgs.findutils pkgs.util-linux pkgs.kmod pkgs.nettools
          pkgs.procps pkgs.iproute2 pkgs.binutils
        ]}"
      ];
      ExecStart = pkgs.writeShellScript "chkrootkit-scan.sh" ''
        export PATH="${lib.makeBinPath [
          pkgs.gawk pkgs.gnused pkgs.gnugrep pkgs.findutils pkgs.coreutils
          pkgs.util-linux pkgs.kmod pkgs.nettools pkgs.procps pkgs.iproute2 pkgs.binutils
        ]}:$PATH"
        set -euo pipefail
        LOG_DIR="/var/log/chkrootkit"
        LOG_FILE="$LOG_DIR/chkrootkit.log"
        ${pkgs.coreutils}/bin/install -d -m 0750 -o root -g root "$LOG_DIR"
        TMP="$(${pkgs.coreutils}/bin/mktemp)"
        trap '${pkgs.coreutils}/bin/rm -f "$TMP"' EXIT
        ${pkgs.chkrootkit}/sbin/chkrootkit 2>&1 | ${pkgs.coreutils}/bin/tee -a "$TMP"
        {
          echo "===== $(${pkgs.coreutils}/bin/date -Is) ====="
          ${pkgs.coreutils}/bin/cat "$TMP"
          echo
        } >> "$LOG_FILE"
        ${pkgs.gnugrep}/bin/grep -Ev           "^Checking \`(basename|dirname|echo|env)'\.\.\. INFECTED$|^Checking \`date'\.\.\. /bin/sh$"           "$TMP" > "$TMP.filtered" || true
        if ${pkgs.gnugrep}/bin/grep -Eiq '(^| )INFECTED( |$)' "$TMP.filtered"; then
          ${pkgs.util-linux}/bin/logger -p daemon.err -t chkrootkit "Findings detected. See $LOG_FILE"
          ${pkgs.util-linux}/bin/wall "chkrootkit: findings detected. See $LOG_FILE"
          exit 1
        fi
      '';
    };
  };

  systemd.timers.chkrootkit-scan = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
    };
  };

  systemd.services."chkrootkit-alert@" = {
    unitConfig.Description = "Chkrootkit Failure Alert for %I";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "chkrootkit-alert.sh" ''
        logger -p daemon.err -t chkrootkit           "Scan reported suspicious findings (unit: %I). Check /var/log/chkrootkit/chkrootkit.log"
      '';
    };
  };
}
