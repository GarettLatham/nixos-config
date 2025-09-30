{ lib, config, pkgs, ... }:

{
  home.username = "user1";
  home.homeDirectory = "/home/user1";
  home.stateVersion = "25.05";

  programs.home-manager.enable = true;
  xdg.enable = true;

  # CLI tools Telescope expects
  home.packages = with pkgs; [
    ripgrep
    fd
    git
    tmux  # remove if you don’t want vimux/vim-test later
  ];

  # ---------- Neovim via nixvim (no lazy.nvim needed) ----------
  programs.nixvim = {
    enable = true;
    extraPackages = with pkgs; [
      dockerfile-language-server-nodejs # This might be available within the neovim-specific scope
    ];

    globals.mapleader = " ";

    opts = {
      number = true;
      relativenumber = true;
      termguicolors = true;
      updatetime = 300;
    };

    colorschemes.catppuccin.enable = true;

    plugins = {
      treesitter = {
        enable = true;
        indent = true;
        folding = true;
        ensureInstalled = [ "lua" "bash" "vim" "markdown" "markdown_inline" "python" ];
      };

      lualine.enable = true;
      which-key.enable = true;
      gitsigns.enable = true;
      comment.enable = true;
      "nvim-autopairs".enable = true;
      "neo-tree".enable = true;
      alpha.enable = true;

      alpha = {
        #enable = true;
        theme = "dashboard"; # or "startify"
      };

      # Completion
      cmp = {
        enable = false;
        autoEnableSources = false;
        #sources = [
        #  { name = "nvim_lsp"; }
        #  { name = "path"; }
        #  { name = "buffer"; }
        #  { name = "luasnip"; }
        #];
      };
      luasnip.enable = true;
      # Completion sources (enable the plugins, not a `sources =` list)
      cmp-nvim-lsp.enable = false;
      cmp-buffer.enable = true;
      cmp-path.enable = true;
      cmp_luasnip.enable = true;

      # LSP
      lsp = {
        enable = true;
        #servers.dockerls.enable = lib.mkForce false;
        servers = {
          dockerls.enable = false;
          lua_ls.enable = false;
          bashls.enable = false;
          pyright.enable = false;
          # ts_ls.enable = true;
          # rust_analyzer.enable = true;
        };
      };

      # Telescope + project picker
      telescope = {
        enable = true;
        extensions = {
          "ui-select".enable = true;
          project = {
            enable = true;
            settings = {
              base_dirs = [ "~" "~/.config" "~/code" "~/projects" ];
              hidden_files = true;
              order_by = "recent";
              search_by = "title";
              on_project_selected = "find_project_files";
            };
          };
        };
        keymaps = {
          "<leader>ff" = { action = "find_files"; desc = "Find files"; };
          "<leader>fg" = { action = "live_grep";  desc = "Live grep";  };
          "<leader>fb" = { action = "buffers";    desc = "Buffers";    };
          "<leader>pp" = {
            action = "<cmd>Telescope project project<CR>";
            desc = "Projects";
          };
        };
      };
    };
  };



  # Providers (optional warning cleanups)
  programs.neovim = {
    enable = false; # nixvim provides neovim configuration
  };

  # If you still have a legacy ~/.config/nvim, this prevents HM conflicts.
  xdg.configFile."nvim".source = null;
}
