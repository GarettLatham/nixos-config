{ config, pkgs, ... }:

{
  services.pipewire = {
    enable       = true;
    alsa.enable  = true;
    pulse.enable = true;
    jack.enable  = true;
  };

  services.pulseaudio.enable = false;

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  services.libinput.enable = true;
}
