-- ─────────────────────────────────────────────────────────────────────────────
--  Neovim config (managed by Home-Manager via xdg.configFile)
--  Path in repo: /etc/nixos/home/users/user1/nvim/init.lua
--  This file replaces extraLuaConfig and will be symlinked to ~/.config/nvim/init.lua
-- ─────────────────────────────────────────────────────────────────────────────

-- Small helper to require modules safely
local function safe_require(mod, cb)
local ok, m = pcall(require, mod)
if ok and m then
    if cb then cb(m) end
        return m
        end
        return nil
        end

        -- Temporary compatibility shim for plugins using deprecated APIs (Nvim ≤ 0.11)
        if vim.lsp and vim.lsp.get_clients and not vim.lsp.buf_get_clients then
            ---@diagnostic disable-next-line: duplicate-set-field
            vim.lsp.buf_get_clients = function(buf)
            if type(buf) ~= "number" then buf = 0 end
                local bnr = (buf == 0) and vim.api.nvim_get_current_buf() or buf
                local list = {}
                for _, c in pairs(vim.lsp.get_clients({ bufnr = bnr })) do
                    list[c.id] = c
                    end
                    return list
                    end
                    end

                    -- Theme/UI
                    vim.o.termguicolors = true
                    safe_require("catppuccin", function() vim.cmd.colorscheme("catppuccin") end)

                    -- Which-key
                    safe_require("which-key", function(wk) wk.setup() end)

                    -- Lualine
                    safe_require("lualine", function(l) l.setup({ options = { theme = "auto" } }) end)

                    -- Comment
                    safe_require("Comment", function(C) C.setup() end)

                    -- Autopairs
                    safe_require("nvim-autopairs", function(A) A.setup({}) end)

                    -- Gitsigns + Diffview
                    safe_require("gitsigns", function(gs) gs.setup() end)
                    vim.keymap.set("n", "<leader>gd", "<cmd>DiffviewOpen<cr>",  { desc = "Diffview: open" })
                    vim.keymap.set("n", "<leader>gq", "<cmd>DiffviewClose<cr>", { desc = "Diffview: close" })

                    -- Trouble (diagnostics)
                    safe_require("trouble", function(T)
                    T.setup({})
                    vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Trouble diagnostics" })
                    end)

                    -- Neo-tree
                    safe_require("neo-tree", function(neotree)
                    neotree.setup({})
                    vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle<cr>", { desc = "Explorer: toggle" })
                    end)

                    -- Telescope base
                    safe_require("telescope", function(telescope)
                    telescope.setup({})
                    vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
                    vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<cr>",  { desc = "Live grep" })
                    vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>",    { desc = "Buffers" })
                    vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>",  { desc = "Help tags" })
                    end)

                    -- Projects (ahmedkhalf/project.nvim) + Telescope integration
                    safe_require("project_nvim", function(p)
                    p.setup({
                        detection_methods = { "lsp", "pattern" },
                        patterns = { ".git", "package.json", "pyproject.toml", "flake.nix", "Cargo.toml", ".hg" },
                        exclude_dirs = { "~/.local/*", "/nix/store/*" },
                        show_hidden = true,
                        silent_chdir = true,
                    })
                    end)
                    safe_require("telescope", function(t)
                    pcall(t.load_extension, "projects")
                    vim.keymap.set("n", "<leader>pp", function()
                    -- Set display_type to avoid nil error from plugin validation
                    t.extensions.projects.projects({
                        display_type = "full",
                        hidden_files = true,
                    })
                    end, { desc = "Project picker" })
                    end)

                    -- Sessions (rmagatti/auto-session)
                    safe_require("auto-session", function(as)
                    as.setup({
                        auto_restore_enabled = true,
                        auto_save_enabled = true,
                        suppressed_dirs = { "~/" },
                        log_level = "error",
                    })
                    vim.keymap.set("n", "<leader>ss", "<cmd>SessionSave<cr>",    { desc = "Session save" })
                    vim.keymap.set("n", "<leader>sr", "<cmd>SessionRestore<cr>", { desc = "Session restore" })
                    vim.keymap.set("n", "<leader>sd", "<cmd>SessionDelete<cr>",  { desc = "Session delete" })
                    end)

                    -- Alpha (dashboard) with retro NVIM header + quick actions
                    safe_require("alpha", function(alpha)
                    local dashboard = safe_require("alpha.themes.dashboard")
                    if not dashboard then return end

                        dashboard.section.header.val = {
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

                        dashboard.section.buttons.val = {
                            dashboard.button("f", "  Find file",       ":Telescope find_files<CR>"),
                                 dashboard.button("r", "  Recent files",    ":Telescope oldfiles<CR>"),
                                 dashboard.button("g", "  Live grep",       ":Telescope live_grep<CR>"),
                                 dashboard.button("p", "  Projects",        ":Telescope projects<CR>"),
                                 dashboard.button("s", "󰆓  Restore session", ":SessionRestore<CR>"),
                                 dashboard.button("e", "  File explorer",   ":Neotree toggle<CR>"),
                                 dashboard.button("q", "󰗼  Quit",            ":qa<CR>"),
                        }

                        dashboard.section.footer.val = "Happy hacking ✨"
                        alpha.setup(dashboard.opts)
                        end)

                    -- Treesitter (parsers are provided by Nix, so don't auto-install)
                    safe_require("nvim-treesitter.configs", function(ts)
                    ts.setup({
                        auto_install = false,
                        sync_install = false,
                        ensure_installed = {}, -- Nix provides parsers
                        highlight = { enable = true },
                        indent    = { enable = true },
                        incremental_selection = { enable = true },
                        textobjects = {
                            select = { enable = true },
                            move   = { enable = true },
                        },
                    })
                    end)

                    -- nvim-cmp + luasnip
                    local cmp_ok, cmp = pcall(require, "cmp")
                    if cmp_ok then
                        local luasnip = safe_require("luasnip")
                        if luasnip then
                            safe_require("luasnip.loaders.from_vscode", function(l) l.lazy_load() end)
                            end

                            cmp.setup({
                                snippet = {
                                    expand = function(args)
                                    if luasnip then luasnip.lsp_expand(args.body) end
                                        end,
                                },
                                mapping = cmp.mapping.preset.insert({
                                    ["<CR>"]      = cmp.mapping.confirm({ select = true }),
                                                                    ["<C-Space>"] = cmp.mapping.complete(),
                                                                    ["<Tab>"]     = function(fallback)
                                                                    if cmp.visible() then
                                                                        cmp.select_next_item()
                                                                        elseif luasnip and luasnip.expand_or_jumpable() then
                                                                            luasnip.expand_or_jump()
                                                                            else
                                                                                fallback()
                                                                                end
                                                                                end,
                                                                                ["<S-Tab>"]   = function(fallback)
                                                                                if cmp.visible() then
                                                                                    cmp.select_prev_item()
                                                                                    elseif luasnip and luasnip.jumpable(-1) then
                                                                                        luasnip.jump(-1)
                                                                                        else
                                                                                            fallback()
                                                                                            end
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
                            end

                            -- LSP
                            local lspconfig_ok, lspconfig = pcall(require, "lspconfig")
                            if lspconfig_ok then
                                local capabilities = require("cmp_nvim_lsp").default_capabilities()

                                -- Ruby (solargraph provided by nixpkgs)
                                lspconfig.solargraph.setup({
                                    cmd = { "solargraph", "stdio" },
                                    capabilities = capabilities,
                                    settings = {
                                        solargraph = {
                                            diagnostics = true,
                                            formatting = true,
                                        }
                                    }
                                })

                                -- General servers (enable corresponding servers in extraPackages in Nix)
                                local servers = {
                                    "lua_ls",
                                    "rust_analyzer",
                                    "bashls",
                                    "marksman",
                                    "yamlls",
                                    "pyright",
                                    -- Add more if enabled: "clangd", "gopls", "tsserver",
                                }

                                for _, s in ipairs(servers) do
                                    if lspconfig[s] then
                                        lspconfig[s].setup({ capabilities = capabilities })
                                        end
                                        end

                                        -- Lua LS: don't warn about global `vim`
                                        if lspconfig.lua_ls then
                                            lspconfig.lua_ls.setup({
                                                capabilities = capabilities,
                                                settings = {
                                                    Lua = {
                                                        diagnostics = { globals = { "vim" } },
                                                        workspace = { checkThirdParty = false },
                                                    },
                                                },
                                            })
                                            end
                                            end
