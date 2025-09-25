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

    # Install LSP servers and other executables Neovim uses
    extraPackages = with pkgs; [
      # LSP servers (NO dockerls here)
      lua-language-server
      rust-analyzer
      bash-language-server
      marksman                # markdown LSP
      yaml-language-server
      pyright                 # Python (needs node, provided above)
      # Add more if you want:
      # clang-tools           # C/C++ (clangd)
      # gopls                 # Go
      # typescript-language-server # TS/JS (needs node)
    ];

    # Plugins
    plugins = [
      v.nvim-web-devicons
      v.catppuccin-nvim
      v.lualine-nvim
      v.gitsigns-nvim
      v.comment-nvim
      v.nvim-tree-lua
      v.nvim-ts-autotag
      v.nvim-autopairs
      v.nvim-surround

      # Telescope
      v.plenary-nvim
      v.telescope-nvim

      # Treesitter
      #v.nvim-treesitter.withAllGrammars
      v.nvim-treesitter.withAllGrammars-textobjects
      v.nvim-treesitter.withAllGrammars-context
      v.nvim-treesitter.withAllGrammars.withAllGrammars
      # Which-key
      v.which-key-nvim

      # Snippets & completion
      v.luasnip
      v.friendly-snippets
      v.nvim-cmp
      v.cmp-nvim-lsp
      v.cmp-buffer
      v.cmp-path
      v.cmp_luasnip

      # LSP setup
      v.nvim-lspconfig
    ];

    # Minimal, boring-good defaults in Lua
    extraLuaConfig = ''
      -- UI/theme
      vim.o.termguicolors = true
      vim.cmd.colorscheme("catppuccin")

      -- Telescope
      local telescope = require("telescope")
      telescope.setup({})
      vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>")
      vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<cr>")

      -- Treesitter
      require("nvim-treesitter.withAllGrammars.configs").setup({
        auto_install = false,
        sync_install = false,
        -- do NOT set ensure_installed = "all" or a list you don't ship;
        -- either omit it or keep it empty (Nix provides the parsers):
        ensure_installed = {},
        highlight = { enable = true },
        indent = { enable = true },
        incremental_selection = { enable = true },
        textobjects = { enable = true },
        ensure_installed = { "lua", "vim", "vimdoc", "markdown", "markdown_inline", "c" },
      })

      -- (optional) also make sure the installer never tries Git
      require("nvim-treesitter.withAllGrammars.install").prefer_git = false

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
        lspconfig[s].setup({ capabilities = capabilities })
      end

      -- Make Lua language server not complain about vim globals
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
