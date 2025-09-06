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
        #htop
        neofetch
        tor-browser
        vscodium
        #KDE packages
        kdePackages.dolphin kdePackages.konsole kdePackages.kate kdePackages.discover #kdePackages.qtwayland

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

        #MLFW
        #wget unzip gum rsync git figlet xdg-user-dirs hyprland hyprpaper hyprlock hypridle hyprpicker noto-fonts noto-fonts-emoji noto-fonts-cjk-sans noto-fonts-extra xdg-desktop-portal-gtk xdg-desktop-portal-hyprland libnotify kitty libsForQt5.qtwayland qt6Packages.qt6.qtwayland fastfetch eza python-pip python-gobject python-screeninfo tumbler brightnessctl nm-connection-editor network-manager-applet imagemagick jq xclip kitty neovim htop blueman grim slurp cliphist nwg-look qt6ct waybar rofi-wayland polkit-gnome zsh zsh-completions fzf pavucontrol papirus-icon-theme breeze flatpak swaync gvfs wlogout waypaper grimblast-git bibata-cursor-theme pacseek otf-font-awesome ttf-fira-sans ttf-fira-code ttf-firacode-nerd ttf-dejavu nwg-dock-hyprland power-profiles-daemon python-pywalfox vlc
  ];

  fonts.packages = with pkgs; [ noto-fonts noto-fonts-emoji dejavu_fonts ];
}
