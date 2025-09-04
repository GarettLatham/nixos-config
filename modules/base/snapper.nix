{ config, lib, pkgs, ... }:

{

  # Snapper + grub-btrfs (automatic timeline snapshots + GRUB menu)
  services.snapper.configs.root = {
    SUBVOLUME           = "/";
    timeline            = true;
    timelineLimitHourly = 10;
    timelineLimitDaily  = 7;
    timelineLimitWeekly = 4;
    timelineLimitMonthly = 3;
    cleanup             = "timeline";
  };
}
