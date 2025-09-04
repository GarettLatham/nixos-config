{ config, pkgs, ... }:

{
  services.usbguard = {
    enable = true;
    implicitPolicyTarget = "block";
    IPCAllowedGroups = [ "usbguard" ];
    # presentDevicePolicy = "apply-policy";
    # ruleFile = "/etc/usbguard/rules.conf";
  };
}
