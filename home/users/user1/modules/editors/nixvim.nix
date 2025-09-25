{ pkgs, ... }:
{
  programs.nixvim = {
    enable = true;

    # ---------- COLORS / UI ----------
    colorschemes.catppuccin = {
      enable = true;
      settings.flavour = "mocha";
    };

    plugins.alpha = {
      enable = true;
      theme = "startify";
    };

    # ---------- EDITING / NAV ----------
    plugins."neo-tree" = {
      enable = true;
      filesystem.followCurrentFile.enabled = true;
      window = { width = 32; };
    };

    # Explicit devicons (nvim-web-devicons)
    plugins.web-devicons.enable = true;

    # Extra plugins not directly exposed as nixvim options
    extraPlugins = with pkgs.vimPlugins; [
      oil-nvim
      nvim-web-devicons
      vim-fugitive
      friendly-snippets
      cmp-nvim-lsp
      cmp_luasnip
      vim-tmux-navigator
    ];

    # ---------- Telescope ----------
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
    plugins.cmp.enable = true;

    # ---------- Treesitter (25.05 schema) ----------
    plugins.treesitter = {
      enable = true;
      folding = true;
      nixGrammars = true;
      settings = {
        indent.enable = true;
        ensure_installed = [
          "bash" "c" "cpp" "css" "diff"
          "git_config" "gitcommit" "git_rebase" "gitattributes"
          "go" "gomod"
          "html" "javascript" "json"
          "lua" "luadoc" "luap"
          "markdown" "markdown_inline"
          "nix" "python" "query" "regex"
          "ruby" "rust" "toml" "tsx" "typescript"
          "vim" "vimdoc" "yaml"
        ];
        highlight.enable = true;
        highlight.additional_vim_regex_highlighting = false;
        incremental_selection.enable = true;
        incremental_selection.keymaps = {
          init_selection = "<CR>";
          node_incremental = "<CR>";
          scope_incremental = "<S-CR>";
          node_decremental = "<BS>";
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
        ts_ls.enable = true;     # (tsserver -> ts_ls)
        html.enable = true;
        cssls.enable = true;
        jsonls.enable = true;

        # Disable Dockerfile LSP for now (can re-enable later when pkg attr is stable).
        dockerls.enable = false;

        bashls.enable = true;
        yamlls.enable = true;
        nil_ls.enable = true;
        clangd.enable = true;
        rust_analyzer = {
          enable = true;
          installCargo = false;  # we install via home.packages
          installRustc  = false; # we install via home.packages
        };
        # solargraph.enable = true; # enable if you install the gem or package
      };
    };

    # ---------- GIT ----------
    plugins.gitsigns.enable = true;

    # ---------- TESTING ----------
    plugins."vim-test".enable = true;

    # ---------- FORMAT / DIAGNOSTICS ----------
    plugins."none-ls".enable = true;

    # ---------- Lua config ----------
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
    '';

    extraConfigLuaPost = ''
      -- alpha.nvim: set custom header and apply startify theme
      do
        local alpha = require("alpha")
        local startify = require("alpha.themes.startify")
        startify.section.header.val = {
          "                                                                       ",
          "                                                                       ",
          "                                                                       ",
          "                                                                       ",
          "                                                                     ",
          "       ████ ██████           █████      ██                     ",
          "      ███████████             █████                             ",
          "      █████████ ███████████████████ ███   ███████████   ",
          "     █████████  ███    █████████████ █████ ██████████████   ",
          "    █████████ ██████████ █████████ █████ █████ ████ █████   ",
          "  ███████████ ███    ███ █████████ █████ █████ ████ █████  ",
          " ██████  █████████████████████ ████ █████ █████ ████ ██████ ",
          "                                                                       ",
          "                                                                       ",
          "                                                                       ",
        }
        alpha.setup(startify.config)
      end

      -- nvim-cmp configuration (Lua is schema-stable)
      do
        local ok, cmp = pcall(require, "cmp")
        if ok then
          cmp.setup({
            window = {
              completion = cmp.config.window.bordered(),
              documentation = cmp.config.window.bordered(),
            },
            mapping = cmp.mapping.preset.insert({
              ["<C-b>"] = cmp.mapping.scroll_docs(-4),
              ["<C-f>"] = cmp.mapping.scroll_docs(4),
              ["<C-Space>"] = cmp.mapping.complete(),
              ["<C-e>"] = cmp.mapping.abort(),
              ["<CR>"] = cmp.mapping.confirm({ select = true }),
            }),
            snippet = {
              expand = function(args) require("luasnip").lsp_expand(args.body) end,
            },
            sources = cmp.config.sources({
              { name = "nvim_lsp" },
              { name = "luasnip" },
            }, {
              { name = "buffer" },
            }),
          })
        end
      end

      -- none-ls / null-ls: formatters & diagnostics
      do
        local ok, null_ls = pcall(require, "null-ls")  -- module name is still 'null-ls'
        if ok then
          local has = function(bin) return vim.fn.executable(bin) == 1 end
          local fmt = null_ls.builtins.formatting
          local diag = null_ls.builtins.diagnostics
          local actions = null_ls.builtins.code_actions

          local sources = {}

          -- formatters
          if has("stylua")  then table.insert(sources, fmt.stylua) end
          if has("shfmt")   then table.insert(sources, fmt.shfmt) end
          if has("prettierd") then
            table.insert(sources, fmt.prettierd)
          elseif has("prettier") then
            table.insert(sources, fmt.prettier)
          end

          -- linters / diagnostics
          if has("eslint_d") then
            table.insert(sources, diag.eslint_d)
            table.insert(sources, actions.eslint_d)
          end
          -- Ruby (optional):
          -- if has("rubocop")  then table.insert(sources, diag.rubocop); table.insert(sources, fmt.rubocop) end
          -- if has("erb_lint") then table.insert(sources, diag.erb_lint) end

          null_ls.setup({ sources = sources })
        end
      end
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
    nodePackages.dockerfile-language-server-nodejs
    bash-language-server
    yaml-language-server
    nil
    clang-tools
    rust-analyzer
    rustc cargo

    stylua
    shfmt
    nodePackages.prettier
    nodePackages.eslint_d

    ruby
    nerd-fonts.fira-code
  ];
}
