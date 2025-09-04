Drop-in NixOS hardening snippets (non-flake) that apply safe kernel/sysctl defaults and enable unattended updates.
Includes: kptr/dmesg restrictions and unprivileged BPF disabled, plus daily auto-updates with jitter.
Copy into /etc/nixos, rebuild, and extend as needed.

“What’s included” (reflects your config)

Sysctl hardening:

kernel.kptr_restrict = 2

kernel.dmesg_restrict = 1

kernel.unprivileged_bpf_disabled = 1

Automatic updates: system.autoUpgrade.enable = true with daily cadence and randomized delay

Bootloader: systemd-boot on EFI

