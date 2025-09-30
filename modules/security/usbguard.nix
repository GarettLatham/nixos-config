# /etc/nixos/usbguard.nix
{ config, lib, pkgs, ... }:
{
  services.usbguard = {
    enable = true;

    # Secure defaults + apply policy to existing/new devices
    implicitPolicyTarget = "block";
    presentDevicePolicy  = "apply-policy";
    insertedDevicePolicy = "apply-policy";

    # Generate a real rules file at build time
    ruleFile = pkgs.writeText "usbguard-rules.conf" ''
      # Root hubs (safe)
      allow id 1d6b:0002 name "Linux Foundation 2.0 root hub"
      allow id 1d6b:0003 name "Linux Foundation 3.0 root hub"

      # Intermediate hub (if present in your path)
      allow id 1d5c:5801 name "USB2.0 Hub"

      # Keychron V6 — you’ve used two controller ports; allow both
      allow id 3434:0361 name "Keychron V6" via-port "1-4" with-interface { 03:01:01 03:00:00 03:00:00 }
      allow id 3434:0361 name "Keychron V6" via-port "3-1" with-interface { 03:01:01 03:00:00 03:00:00 }

      # Keychron V6 anywhere (no port restriction)
      allow id 3434:0361 name "Keychron V6" with-interface { 03:01:01 03:00:00 03:00:00 }

      # (Optional) fingerprint sensor if you need it
      allow id 06cb:009a with-interface ff:00:00

      # Intel Bluetooth controller so BlueZ can see it
      allow id 8087:0a2b

      # Internal Bluetooth controller (Intel)
      #allow id 8087:0a2b with-interface { e0:*:* }

    '';
  };
}
