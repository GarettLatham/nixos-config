{ config, lib, pkgs, ... }:

{
  networking.hostName = "nixos";

  networking.networkmanager.enable = true;
  # networking.wireless.enable = true; # only if you really want wpa_supplicant fallback

  networking.firewall = {
    enable = true;
    allowPing = false;
    # allowedTCPPorts = [ ];
    # allowedUDPPorts = [ ];
  };
}
