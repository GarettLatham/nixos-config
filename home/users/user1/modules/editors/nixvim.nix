{ config, pkgs, lib, ... }:

let
  v = pkgs.vimPlugins;
in
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    # Enable built-in language hosts
    withNodeJs = true;
    withPython3 = true;
    withRuby = true;

    # Tools/LSP servers & CLI deps Neovim uses
    extraPackages = with pkgs; [
      # LSP servers (NO dockerls here)
      lua-language-server
      rust-analyzer
      bash-language-server
      marksman                # Markdown LSP
      yaml-language-server
      pyright                 # Python
      typescript-language-server
      clang-tools
      gopls

      # Provide Neovim hosts (to satisfy :checkhealth)
      nodePackages.neovim
      ruby
      rubyPackages.solargraph

      # Telescope deps
      ripgrep
      fd
    ];

    # Provide the Python Neovim host module via nixpkgs
    extraPython3Packages = ps: with ps; [ pynvim ];

    plugins = [
      # UI & quality of life
      v.nvim-web-devicons
      v.catppuccin-nvim
      v.lualine-nvim
      v.gitsigns-nvim
      v.diffview-nvim
      v.comment-nvim
      v.nvim-tree-lua
      v.nvim-ts-autotag
      v.nvim-autopairs
      v.nvim-surround
      v.which-key-nvim

      # Dashboard
      v.alpha-nvim

      # Telescope
      v.plenary-nvim
      v.telescope-nvim

      # Treesitter: core parsers from Nix + companion plugins
      v.nvim-treesitter.withAllGrammars
      v.nvim-treesitter-textobjects

      # Snippets & completion
      v.luasnip
      v.friendly-snippets
      v.nvim-cmp
      v.cmp-nvim-lsp
      v.cmp-buffer
      v.cmp-path
      v.cmp_luasnip

      # LSP setup helpers
      v.nvim-lspconfig

      # Diagnostics
      v.trouble-nvim

      # File explorer
      v.neo-tree-nvim
      v.nui-nvim

      # Projects & sessions
      v.project-nvim
      v.auto-session
    ];
  };

  # >>> Use a real init.lua from the repo instead of extraLuaConfig <<<
  xdg.configFile."nvim/init.lua".source = ../../nvim/init.lua;
}
