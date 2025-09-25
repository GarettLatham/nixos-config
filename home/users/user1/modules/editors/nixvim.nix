{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;

    # Pick a few core plugins (adjust to taste)
    plugins = with pkgs.vimPlugins; [
      nvim-lspconfig
      nvim-treesitter
      plenary-nvim
      telescope-nvim
      nvim-web-devicons
      # theme:
      catppuccin-nvim
      # completion stack (optional):
      nvim-cmp cmp-nvim-lsp cmp-buffer cmp-path luasnip cmp_luasnip
    ];

    extraLuaConfig = ''
      vim.cmd.colorscheme('catppuccin')
      -- treesitter basics
      require('nvim-treesitter.configs').setup {
        highlight = { enable = true },
        indent = { enable = true }
      }
      -- lsp minimal (NO dockerls here)
      local lsp = require('lspconfig')
      -- Example: enable a couple servers you actually want available
      -- (they won’t start unless the binaries are installed)
      local caps = require('cmp_nvim_lsp').default_capabilities()
      local servers = { 'bashls', 'lua_ls', 'rust_analyzer' }  -- edit list
      for _, s in ipairs(servers) do
        if lsp[s] then lsp[s].setup { capabilities = caps } end
      end

      -- nvim-cmp minimal
      local cmp = require('cmp')
      local luasnip = require('luasnip')
      cmp.setup {
        snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
        mapping = cmp.mapping.preset.insert({
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' }, { name = 'buffer' }, { name = 'path' },
        }),
      }
    '';
  };

  # Install any LSP binaries you actually use (NOT dockerls)
  home.packages = with pkgs; [
    rust-analyzer
    lua-language-server
    nodePackages.bash-language-server
    # add others you use; do NOT add dockerfile-language-server*
  ];
}
