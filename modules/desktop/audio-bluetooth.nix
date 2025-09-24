{ config, pkgs, ... }:
{
  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.blueman.enable = true;

  # Audio via PipeWire (replaces PulseAudio)
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;   # PulseAudio compatibility server
    jack.enable = false;   # set true only if you need JACK
  };

  # Optional legacy toggle; safe to omit:
  # sound.enable = true;
}
