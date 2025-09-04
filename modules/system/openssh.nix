{ config, pkgs, lib, ... }:

{
  services.openssh = {
    enable = true;
    settings = {
      AllowTcpForwarding    = "no";
      AllowAgentForwarding  = "no";
      TCPKeepAlive          = "no";
      ClientAliveInterval   = 300;
      ClientAliveCountMax   = 2;
      LogLevel              = "VERBOSE";
      MaxAuthTries          = 3;
      MaxSessions           = 2;
      PermitRootLogin        = "no";
      PasswordAuthentication = true;
    };
    banner                 = "/etc/issue";
  };


  # [BANN-7126] Legal login banner for console and SSH
  # Console/TTY banner
  environment.etc."issue".text = ''
    **********************************************************************
    * WARNING: Restricted System                                          *
    **********************************************************************
    By accessing this machine, you acknowledge and accept the following:

    - This system is only available for authorized users. Unauthorized or
      prohibited use is strictly forbidden.

    - This system is audited by means of automatic and manual monitoring.
      All activity is monitored and logged for security and compliance.

    - No privacy is guaranteed. By proceeding, you accept that your actions
      are subject to monitoring, auditing, and enforcement of policies.

    - Unauthorized access will be reported to law enforcement agencies,
      and we will take legal measures as necessary.

    - By proceeding, you accept the terms of this banner and consent to
      monitoring, auditing, and enforcement as described.

    **********************************************************************
    * NOTICE: If you are not an authorized user, disconnect immediately. *
    **********************************************************************
  '';
}
