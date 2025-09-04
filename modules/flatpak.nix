{ config, pkgs, ... }:
{
  services.flatpak.enable = true;
  services.packagekit.enable = true;
    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
      extraPortals = [ pkgs.kdePackages.xdg-desktop-portal-kde ];
  };
}
