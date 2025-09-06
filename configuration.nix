{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ./modules/base/nixpkgs.nix
    ./modules/base/locale.nix
    ./modules/base/users.nix
    ./modules/base/packages.nix
    ./modules/base/logging.nix
    ./modules/base/tmpfiles.nix
    ./modules/base/snapper.nix

    ./modules/system/boot.nix
    ./modules/system/networking.nix
    ./modules/system/openssh.nix

    ./modules/desktop/kde.nix
    ./modules/desktop/audio-bluetooth.nix
    ./modules/desktop/flatpak.nix

    ./modules/security/auditd.nix
    ./modules/security/aide.nix
    ./modules/security/chkrootkit.nix
    ./modules/security/usbguard.nix
    ./modules/security/hardening.nix
    # …
    ./modules/security/rngd.nix
    ./modules/security/psacct.nix
    ./modules/security/pam.nix
    ./modules/security/vulnix.nix

  ];

  # lock in state to avoid surprising migrations
  system.stateVersion = "25.05";
}
