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
      pyright                 # Python (needs node, provided above)
      # Provide the Node.js Neovim host from nixpkgs to satisfy :checkhealth
      nodePackages.neovim
      # Telescope deps
      ripgrep
      fd
      typescript-language-server # TS/JS (needs node)
      clang-tools
      gopls
    ];

    # Provide the Python Neovim host module via nixpkgs
    extraPython3Packages = ps: with ps; [ pynvim ];

    plugins = [
      # UI & quality of life
      v.nvim-web-devicons
      v.catppuccin-nvim
      v.lualine-nvim
      v.gitsigns-nvim
      v.comment-nvim
      v.nvim-tree-lua
      v.nvim-ts-autotag
      v.nvim-autopairs
      v.nvim-surround
      v.which-key-nvim

      # Telescope
      v.plenary-nvim
      v.telescope-nvim

      # Treesitter: core parsers from Nix + companion plugins
      (v.nvim-treesitter.withAllGrammars)
      v.nvim-treesitter-textobjects
      v.nvim-treesitter-context

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

      #Diagnostics - A unified list for LSP errors, quickfix, todo comments, etc.
      v.trouble-nvim
    ];

    extraLuaConfig = ''
      -- UI/theme
      vim.o.termguicolors = true
      vim.cmd.colorscheme("catppuccin")

      -- Telescope
      local telescope = require("telescope")
      telescope.setup({})
      vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>")
      vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<cr>")

      -- Treesitter (parsers are provided by Nix, so don't auto-install)
      require("nvim-treesitter.configs").setup({
        auto_install = false,
        sync_install = false,
        ensure_installed = {}, -- keep empty; Nix provides parsers
        highlight = { enable = true },
        indent    = { enable = true },
        incremental_selection = { enable = true },
        textobjects = {
          select = { enable = true },
          move   = { enable = true },
        },
      })
      -- Never try to fetch via git at runtime
      require("nvim-treesitter.install").prefer_git = false

      -- Treesitter context
      require("treesitter-context").setup({})

      -- Lualine
      require("lualine").setup({ options = { theme = "auto" } })

      -- Gitsigns
      require("gitsigns").setup()

      -- Comment
      require("Comment").setup()

      -- Autopairs
      require("nvim-autopairs").setup({})

      -- Which-key
      require("which-key").setup()

      -- Trouble
      require("trouble").setup({})
      vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>")

      -- Snippets
      local luasnip = require("luasnip")
      require("luasnip.loaders.from_vscode").lazy_load()

      -- nvim-cmp
      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          expand = function(args) luasnip.lsp_expand(args.body) end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<Tab>"] = function(fallback)
            if cmp.visible() then cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
            else fallback() end
          end,
          ["<S-Tab>"] = function(fallback)
            if cmp.visible() then cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then luasnip.jump(-1)
            else fallback() end
          end,
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
        }, {
          { name = "buffer" },
          { name = "path" },
        }),
      })

      -- Basic LSP bootstrap (NO dockerls)
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      local servers = {
        "lua_ls",
        "rust_analyzer",
        "bashls",
        "marksman",
        "yamlls",
        "pyright",
        -- add more if you enable them in extraPackages:
        -- "clangd", "gopls", "tsserver",
      }

      for _, s in ipairs(servers) do
        if lspconfig[s] then
          lspconfig[s].setup({ capabilities = capabilities })
        end
      end

      -- Lua LS: don't warn about global `vim`
      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            workspace = { checkThirdParty = false },
          },
        },
      })
    '';
  };
}
