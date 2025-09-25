{ pkgs, ... }:
{
  home.username = "user1";
  home.homeDirectory = "/home/user1";
  home.stateVersion = "24.05";

  imports = [
    ./modules/editors/nixvim.nix
  ];

  # CLI tools that Telescope / Treesitter expect
  home.packages = with pkgs; [
    ripgrep       # fixes Telescope "rg: not found"
    fd            # optional but nice for Telescope
    gcc           # provides `cc` for nvim-treesitter compiles
    # nodejs_22   # optional; only needed for :TSInstallFromGrammar
    # tree-sitter # optional; only needed for :TSInstallFromGrammar
  ];

  programs.neovim = {
    enable = true;

    # Keep the Python host up-to-date
    extraPython3Packages = ps: [ ps.pynvim ];
    # (Remove this once the wrapped nvim host in Nixpkgs ships pynvim 0.6.0)
  };

  # Optional: per-user shell preference
  programs.zsh.enable = true;
}
