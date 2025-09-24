{ pkgs, ... }:
{
  programs.nixvim = {
    enable = true;

    # ---------- COLORS / UI ----------
    plugins.catppuccin = {
      enable = true;
      flavour = "mocha";
    };

    plugins.alpha = {
      enable = true;
      theme = "startify";
      setupOptions.section.header.val = [
        "                                                                       "
        "                                                                       "
        "                                                                       "
        "                                                                       "
        "                                                                     "
        "       ████ ██████           █████      ██                     "
        "      ███████████             █████                             "
        "      █████████ ███████████████████ ███   ███████████   "
        "     █████████  ███    █████████████ █████ ██████████████   "
        "    █████████ ██████████ █████████ █████ █████ ████ █████   "
        "  ███████████ ███    ███ █████████ █████ █████ ████ █████  "
        " ██████  █████████████████████ ████ █████ █████ ████ ██████ "
        "                                                                       "
        "                                                                       "
        "                                                                       "
      ];
    };

    # ---------- EDITING / NAV ----------
    plugins.neo-tree = {
      enable = true;
      filesystem.followCurrentFile.enabled = true;
      window = { width = 32; };
    };

    # Extras not exposed as direct nixvim options
    extraPlugins = with pkgs.vimPlugins; [
      oil-nvim
      nvim-web-devicons
      vim-fugitive
      swagger-preview-nvim
      friendly-snippets
      cmp-nvim-lsp
      cmp_luasnip
    ];

    extraConfigLua = ''
      -- Colorscheme (explicit)
      vim.cmd.colorscheme("catppuccin-mocha")

      -- oil.nvim
      require("oil").setup({
        default_file_explorer = true,
        columns = { "icon" },
        view_options = { show_hidden = true },
      })
      vim.keymap.set("n", "-", require("oil").open, { desc = "Open parent dir (oil)" })

      -- gitsigns hotkeys
      vim.keymap.set("n", "<leader>gp", ":Gitsigns preview_hunk<CR>", {})
      vim.keymap.set("n", "<leader>gt", ":Gitsigns toggle_current_line_blame<CR>", {})

      -- vim-test via vimux
      vim.g["test#strategy"] = "vimux"

      -- nvim-tmux-navigation
      pcall(function()
        require("nvim-tmux-navigation").setup({
          disable_when_zoomed = true,
          keybindings = {
            left  = "<C-h>",
            down  = "<C-j>",
            up    = "<C-k>",
            right = "<C-l>",
          },
        })
      end)
    '';

    # Telescope
    plugins.telescope = {
      enable = true;
      extensions.ui-select.enable = true;
      keymaps = {
        "<C-p>" = "git_files";
        "<leader>fg" = "live_grep";
        "<leader><leader>" = "buffers";
        "<leader>ff" = "find_files";
      };
      settings.defaults.mappings.i = { "<C-u>" = false; "<C-d>" = false; };
    };

    # ---------- CMP / SNIPPETS ----------
    plugins.luasnip.enable = true;
    plugins.cmp = {
      enable = true;
      autoEnableSources = false;
      sources = [
        { name = "nvim_lsp"; }
        { name = "luasnip"; }
        { name = "buffer"; }
      ];
      mappingPresets = [ "insert" ];
      settings = {
        window = {
          completion = { border = "single"; };
          documentation = { border = "single"; };
        };
        mapping = {
          "<C-b>" = "cmp.mapping.scroll_docs(-4)";
          "<C-f>" = "cmp.mapping.scroll_docs(4)";
          "<C-Space>" = "cmp.mapping.complete()";
          "<C-e>" = "cmp.mapping.abort()";
          "<CR>" = "cmp.mapping.confirm({ select = true })";
        };
        snippet.expand = ''
          function(args) require("luasnip").lsp_expand(args.body) end
        '';
      };
    };

    # ---------- TREESITTER ----------
    plugins.treesitter = {
      enable = true;
      folding = true;
      indent = true;
      nixGrammars = true;
      ensureInstalled = [
        "bash" "c" "cpp" "css" "diff" "git_config" "gitcommit" "git_rebase" "gitattributes"
        "go" "gomod" "html" "javascript" "json" "lua" "luadoc" "luap" "markdown"
        "markdown_inline" "nix" "python" "query" "regex" "ruby" "rust" "toml" "tsx"
        "typescript" "vim" "vimdoc" "yaml"
      ];
      settings = {
        highlight = { enable = true; additional_vim_regex_highlighting = false; };
        incremental_selection = {
          enable = true;
          keymaps = {
            init_selection = "<CR>";
            node_incremental = "<CR>";
            scope_incremental = "<S-CR>";
            node_decremental = "<BS>";
          };
        };
      };
    };

    # ---------- LSP (Nix provides servers; no Mason needed) ----------
    plugins.lsp = {
      enable = true;
      keymaps.lspBuf = {
        K = "hover";
        gd = "definition";
        gr = "references";
        gi = "implementation";
        "<leader>rn" = "rename";
        "<leader>ca" = "code_action";
      };
      servers = {
        lua_ls.enable = true;
        tsserver.enable = true;
        html.enable = true;
        cssls.enable = true;
        jsonls.enable = true;
        bashls.enable = true;
        yamlls.enable = true;
        nil_ls.enable = true;
        clangd.enable = true;
        rust_analyzer.enable = true;
        # solargraph.enable = true; # enable if you install the gem or package
      };
    };

    # ---------- GIT ----------
    plugins.gitsigns.enable = true;

    # ---------- TESTING ----------
    plugins.vim-test.enable = true;

    # ---------- tmux navigation ----------
    plugins.nvim-tmux-navigation.enable = true;

    # ---------- FORMAT / DIAGNOSTICS (null-ls / none-ls) ----------
    plugins.none-ls = {
      enable = true;
      sources.formatting = {
        stylua.enable = true;
        shfmt.enable = true;
        prettier.enable = true;   # swap to prettierd if preferred
      };
      sources.diagnostics = {
        eslint_d.enable = true;
        # rubocop.enable = true;   # requires gem
        # erb_lint.enable = true;  # requires gem
      };
    };

    # Swagger preview (plugin via extraPlugins)
    extraConfigLuaPost = ''
      pcall(function()
        require("swagger-preview").setup({
          port = 8000,
          host = "127.0.0.1",
        })
      end)
    '';
  };

  # ---------- Packages these plugins/tools need ----------
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    ripgrep fd git unzip
    tmux
    gcc pkg-config
    wl-clipboard xclip

    nodejs
    python3 python311Packages.pynvim

    lua-language-server
    typescript-language-server
    vscode-langservers-extracted
    bash-language-server
    yaml-language-server
    nil
    clang-tools
    rust-analyzer

    stylua
    shfmt
    nodePackages.prettier
    nodePackages.eslint_d

    ruby
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
  ];
}
