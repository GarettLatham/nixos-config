{ config, pkgs, ... }:

{
  # Home info
  home.username = "user1";
  home.homeDirectory = "/home/user1";

  # Pull in our Neovim module
  imports = [
    ./modules/editors/nixvim.nix
  ];

  # XDG base dirs (helps keep $HOME tidy)
  xdg.enable = true;

  # Shell
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    #autosuggestions.enable = true;
    #syntaxHighlighting.enable = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
  };

  # Git (edit name/email if you want them set here)
  programs.git.enable = true;

  # External tools & language hosts that `:checkhealth` referenced
  home.packages = with pkgs; [
    # General CLI
    ripgrep
    fd
    git
    gcc            # provides cc for treesitter compiles

    # Node provider
    nodejs_20
    nodePackages.neovim  # node host for Neovim

    # Python provider
    (python3.withPackages (ps: [ ps.pip ps.pynvim ]))

    # Ruby provider
    ruby
    #rubyPackages.neovim

    # Perl (provider is optional; this gives you `perl`)
    perl
  ];

  # Let HM manage itself
  programs.home-manager.enable = true;

  # State version (keep at first HM version you used)
  home.stateVersion = "25.05";
}
