{ pkgs, ... }:
{
    environment.systemPackages = with pkgs; [
        snapper
        vim
        neovim
        git
        firefox
        chromium
        btrfs-progs
        htop
        neofetch
        tor-browser
        vscodium
        #KDE packages
        kdePackages.dolphin kdePackages.konsole kdePackages.kate kdePackages.discover

        #USB Firewall
        usbguard

        #rkhunter
        chkrootkit
        aide
        lynis

        libpwquality
        passwdqc
        acct

        vulnix #Package audit tool (PKGS-7398)
        ansible #TOOL-5002
  ];

  fonts.packages = with pkgs; [ noto-fonts noto-fonts-emoji dejavu_fonts ];
}
