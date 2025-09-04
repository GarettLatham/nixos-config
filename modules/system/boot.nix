{ config, pkgs, lib, ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Optional but helpful
  boot.loader.timeout = 3;

  boot.tmp.useTmpfs = true;  # /tmp on tmpfs (addresses FILE-6310)
    #fileSystems."/var/tmp".options = [ "nodev" "nosuid" ]; # safer defaults
    fileSystems."/var/log".options = [ "nodev" "nosuid" ]; # you already have a subvol; add options
    fileSystems."/var/tmp" = {
        device = "tmpfs";
        fsType  = "tmpfs";
        options = [ "mode=1777" "nosuid" "nodev" ];
  };
}
