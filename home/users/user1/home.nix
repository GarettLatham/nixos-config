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
    gcc
  ];

  # ---------- Neovim via nixvim (no lazy.nvim needed) ----------
  programs.nixvim = {
    enable = true;
    #extraPackages = with pkgs; [
    #  dockerfile-language-server-nodejs # This might be available within the neovim-specific scope
    #];

    globals.mapleader = " ";

    opts = {
      number = true;
      relativenumber = true;
      termguicolors = true;
      updatetime = 300;
    };

    colorschemes.catppuccin.enable = true;
    keymaps = [
      # ── File / buffer ────────────────────────────────────────────────────────────
      { mode = "n"; key = "<leader>w"; action = ":w<CR>";                    options.desc = "Save"; }
      { mode = "n"; key = "<leader>q"; action = ":q<CR>";                    options.desc = "Quit"; }
      { mode = "n"; key = "<leader>Q"; action = ":qa!<CR>";                  options.desc = "Quit all!"; }
      { mode = "n"; key = "<leader>bd"; action = ":bd<CR>";                  options.desc = "Buffer delete"; }
      { mode = "n"; key = "<leader>bn"; action = ":bnext<CR>";               options.desc = "Buffer next"; }
      { mode = "n"; key = "<leader>bp"; action = ":bprevious<CR>";           options.desc = "Buffer prev"; }

      # ── Windows ────────────────────────────────────────────────────────────────
      { mode = "n"; key = "<C-h>"; action = "<C-w>h";                        options.desc = "Win left"; }
      { mode = "n"; key = "<C-j>"; action = "<C-w>j";                        options.desc = "Win down"; }
      { mode = "n"; key = "<C-k>"; action = "<C-w>k";                        options.desc = "Win up"; }
      { mode = "n"; key = "<C-l>"; action = "<C-w>l";                        options.desc = "Win right"; }

      # ── Telescope (incl. projects) ─────────────────────────────────────────────
      { mode = "n"; key = "<leader>ff"; action = "<cmd>Telescope find_files<CR>";   options.desc = "Find files"; }
      { mode = "n"; key = "<leader>fg"; action = "<cmd>Telescope live_grep<CR>";    options.desc = "Live grep"; }
      { mode = "n"; key = "<leader>fb"; action = "<cmd>Telescope buffers<CR>";      options.desc = "Buffers"; }
      { mode = "n"; key = "<leader>fh"; action = "<cmd>Telescope help_tags<CR>";    options.desc = "Help tags"; }
      { mode = "n"; key = "<leader>fd"; action = "<cmd>Telescope diagnostics<CR>";  options.desc = "Diagnostics"; }
      { mode = "n"; key = "<leader>pp"; action = "<cmd>Telescope project<CR>";      options.desc = "Projects"; }

      # ── File explorer (neo-tree) ───────────────────────────────────────────────
      { mode = "n"; key = "<leader>e"; action = "<cmd>Neotree toggle<CR>";   options.desc = "Explorer toggle"; }

      # ── LSP (works even if only some servers are enabled) ──────────────────────
      { mode = "n"; key = "K";          action = "<cmd>lua vim.lsp.buf.hover()<CR>";           options.desc = "LSP Hover"; }
      { mode = "n"; key = "gd";         action = "<cmd>lua vim.lsp.buf.definition()<CR>";      options.desc = "Goto def"; }
      { mode = "n"; key = "gr";         action = "<cmd>lua vim.lsp.buf.references()<CR>";      options.desc = "References"; }
      { mode = "n"; key = "<leader>rn"; action = "<cmd>lua vim.lsp.buf.rename()<CR>";          options.desc = "Rename"; }
      { mode = "n"; key = "<leader>ca"; action = "<cmd>lua vim.lsp.buf.code_action()<CR>";     options.desc = "Code action"; }
      { mode = "n"; key = "[d";         action = "<cmd>lua vim.diagnostic.goto_prev()<CR>";    options.desc = "Prev diagnostic"; }
      { mode = "n"; key = "]d";         action = "<cmd>lua vim.diagnostic.goto_next()<CR>";    options.desc = "Next diagnostic"; }
      { mode = "n"; key = "<leader>ld"; action = "<cmd>lua vim.diagnostic.open_float()<CR>";   options.desc = "Line diagnostics"; }

      # ── Clipboard (system) ─────────────────────────────────────────────────────
      { mode = "v"; key = "<leader>y"; action = ''"+y'';                       options.desc = "Yank to system"; }
      { mode = "n"; key = "<leader>y"; action = ''"+yy'';                      options.desc = "Yank line to system"; }
      { mode = "n"; key = "<leader>p"; action = ''"+p'';                       options.desc = "Paste from system"; }
      { mode = "v"; key = "<leader>p"; action = ''"+p'';                       options.desc = "Paste from system"; }

      # ── Quality of life ────────────────────────────────────────────────────────
      { mode = "i"; key = "jk"; action = "<Esc>";                            options.desc = "Esc in insert"; }
    ];


    plugins = {
      #treesitter = {
      #  enable = true;
      #  indent = true;
      #  folding = true;
      #  ensureInstalled = [ "lua" "bash" "vim" "markdown" "markdown_inline" "python" ];
      #};
      web-devicons.enable = true;
      treesitter = {
        enable = true;
        settings = {
          highlight.enable = true;
          indent.enable = true;
          # pick what you want installed:
          ensure_installed = [ "lua" "vim" "bash" "markdown" "markdown_inline" ];
          # Or: ensure_installed = "all";
        };
      };

      lualine.enable = true;
      which-key.enable = true;
      gitsigns.enable = true;
      comment.enable = true;
      "nvim-autopairs".enable = true;
      "neo-tree".enable = true;
      #alpha.enable = true;

      alpha = {
        enable = true;
        theme = "theta";
      };

      # Completion
      cmp = {
        enable = true;
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
      cmp-nvim-lsp.enable = true;
      cmp-buffer.enable = true;
      cmp-path.enable = true;
      cmp_luasnip.enable = true;

      # LSP
      lsp = {
        enable = true;
        #servers.dockerls.enable = lib.mkForce false;
        servers = {
          dockerls.enable = true;
          lua_ls.enable = true;
          bashls.enable = true;
          pyright.enable = true;
          ts_ls.enable = true;
          rust_analyzer.enable = true;
        };
      };

      # Telescope + project picker
      telescope = {
        enable = true;

        # turn the extension on
        extensions.project.enable = true;

        # optional extension settings
        settings = {
          extensions = {
            project = {
              enable = true;
              hidden_files = true;
              # NOTE: no ~ expansion in Nix; use absolute paths
              base_dirs = [
                { path = "/home/user1"; }
                { path = "/home/user1/.config"; }
                { path = "/home/user1/code"; }
                { path = "/home/user1/projects"; }
              ];
            };
          };
        };
      };

    };
    extraConfigLua = ''
      -- Open a terminal in a new tab and run a command
      local function run_in_term(cmd)
        vim.cmd('tabnew')               -- new tab
        vim.fn.termopen({'bash','-lc', cmd})
        vim.cmd('startinsert')          -- focus the terminal
      end

      -- :NixUpdate -> updates flake inputs
        vim.api.nvim_create_user_command('NixUpdate', function()
        run_in_term([[cd ~/nixos-config && nix flake update ; \
          printf '\n✅ Flake updated. Next: run :NixRebuild to switch.\n\n' ; exec bash]])
      end, {})

      -- :NixRebuild -> rebuilds and switches
      vim.api.nvim_create_user_command('NixRebuild', function()
        run_in_term([[cd ~/nixos-config && sudo nixos-rebuild switch --flake .#nixos ; \
          printf '\n✅ Rebuild done. You can close this tab.\n\n' ; exec bash]])
      end, {})
    '';

  };



  # Providers (optional warning cleanups)
  programs.neovim = {
    enable = false; # nixvim provides neovim configuration
  };

  # If you still have a legacy ~/.config/nvim, this prevents HM conflicts.
  #xdg.configFile."nvim".source = null;
}
