{ pkgs, ... }:
{
  home.username = "user1";
  home.homeDirectory = "/home/user1";
  home.stateVersion = "24.05";

  imports = [
    ./modules/editors/nixvim.nix
  ];

  #nixpkgs.overlays = [
  #  (import ../../overlays/dockerls.nix)
  #];

  # Optional: per-user shell preference
  programs.zsh.enable = true;
}
