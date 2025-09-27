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
      v.diffview-nvim
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
      v.nvim-treesitter.withAllGrammars
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

      v.neo-tree-nvim
      v.nui-nvim

      v.project-nvim
      v.auto-session
      v.session-lens
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
      -- Projects (ahmedkhalf/project.nvim)
      require("project_nvim").setup({
        detection_methods = { "lsp", "pattern" },
        patterns = { ".git", "package.json", "pyproject.toml", "flake.nix", "Cargo.toml", ".hg" },
        exclude_dirs = { "~/.local/*", "/nix/store/*" },
        show_hidden = true,
        silent_chdir = true,
      })
      -- Telescope integration for projects
      require("telescope").load_extension("projects")
      vim.keymap.set("n", "<leader>pp", function() require("telescope").extensions.projects.projects{} end,
        { desc = "Project picker" })

      -- Sessions (rmagatti/auto-session)
      require("auto-session").setup({
        auto_restore_enabled = true,   -- restore session when entering a project dir
        auto_save_enabled = true,      -- save on leave
        suppressed_dirs = { "~/" },    -- don’t create sessions in $HOME root
        log_level = "error",
      })
      -- Handy session mappings
      vim.keymap.set("n", "<leader>ss", "<cmd>SessionSave<cr>",     { desc = "Session save" })
      vim.keymap.set("n", "<leader>sr", "<cmd>SessionRestore<cr>",  { desc = "Session restore" })
      vim.keymap.set("n", "<leader>sd", "<cmd>SessionDelete<cr>",   { desc = "Session delete" })

      -- Session picker (rmagatti/session-lens) integrates with auto-session
      require("session-lens").setup({
        -- nice default; keeps paths readable
        path_display = { "shorten" },
      })
      require("telescope").load_extension("session_lens")

      -- Pick/search sessions with Telescope
      vim.keymap.set(
        "n",
        "<leader>ps",
        function() require("telescope").extensions.session_lens.search_session() end,
        { desc = "Session picker (Telescope)" }
      )

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
      vim.keymap.set("n", "<leader>gd", "<cmd>DiffviewOpen<cr>")
      vim.keymap.set("n", "<leader>gq", "<cmd>DiffviewClose<cr>")

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

      -- File explorer
      require("neo-tree").setup({})
      vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle<cr>")

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
