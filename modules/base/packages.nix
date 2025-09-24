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
        wget 
	unzip 
	gum 
	rsync 
	git 
	figlet 
	xdg-user-dirs 
	hyprland 
	hyprpaper 
	hyprlock 
	hypridle 
	hyprpicker 
	noto-fonts 
	noto-fonts-emoji 
	noto-fonts-cjk-sans 
	noto-fonts-extra 
	xdg-desktop-portal-gtk 
	xdg-desktop-portal-hyprland 
	libnotify 
	kitty 
	libsForQt5.qtwayland 
	qt6.qtwayland 
	fastfetch 
	eza 
	#python-pip
	python3Packages.pip 
	#python-gobject
	python3Packages.pygobject3 
	#python-screeninfo
	python3Packages.screeninfo 
	xfce.tumbler 
	brightnessctl 
	#nm-connection-editor 
	networkmanagerapplet 
	imagemagick 
	jq 
	xclip 
	neovim 
	htop 
	blueman 
	grim 
	slurp 
	cliphist 
	nwg-look 
	qt6ct 
	waybar 
	rofi-wayland 
	#polkit-gnome
	polkit_gnome 
	zsh 
	zsh-completions 
	fzf 
	pavucontrol 
	papirus-icon-theme 
	#breeze
	kdePackages.breeze-icons 
	flatpak 
	#swaync
	swaynotificationcenter 
	gvfs 
	wlogout 
	waypaper 
	#grimblast-git
	python3Packages.screeninfo 
	bibata-cursors 
	#pacseek 
	#otf-font-awesome
	font-awesome 
	#ttf-fira-sans 
	#ttf-fira-code 
	#ttf-firacode-nerd
	fira
	fira-code 
	#ttf-dejavu
	dejavu_fonts
	noto-fonts noto-fonts-emoji noto-fonts-cjk-sans noto-fonts-extra 
	nwg-dock-hyprland 
	power-profiles-daemon 
	#python-pywalfox
	pywalfox-native 
	vlc
  ];

  #fonts.packages = with pkgs; [ noto-fonts noto-fonts-emoji dejavu_fonts ];
}
