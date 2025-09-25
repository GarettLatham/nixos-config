{ pkgs, ... }:
{
  programs.nixvim = {
    enable = true;

    # ---------- UI / Colors ----------
    colorschemes.catppuccin = {
      enable = true;
      settings.flavour = "mocha";
    };

    plugins.alpha = {
      enable = true;
      theme = "startify";
    };

    # ---------- Treesitter ----------
    plugins.treesitter = {
      enable = true;
      settings = {
        highlight.enable = true;
        indent.enable = true;
        ensure_installed = [ "lua" "vim" "vimdoc" "markdown" "markdown_inline" "c" ];
      };
    };

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

    # ---------- Completion / Snippets ----------
    plugins.cmp = {
      enable = true;
      autoEnableSources = true;
      sources = [
        { name = "nvim_lsp"; }
        { name = "path"; }
        { name = "buffer"; }
        { name = "luasnip"; }
      ];
      mapping = {
        "<CR>" = "cmp.mapping.confirm({ select = true })";
        "<C-Space>" = "cmp.mapping.complete()";
        "<C-e>" = "cmp.mapping.abort()";
        "<Tab>" = ''
          function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end
        '';
        "<S-Tab>" = ''
          function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end
        '';
      };
    };

    plugins.luasnip = {
      enable = true;
      fromVscode = [ ]; # add vscode-style snippet packs if you want
    };

    # ---------- LSP (no dockerls) ----------
    plugins.lsp = {
      enable = true;
      # You can add language servers here later (e.g., lua_ls, pyright, etc.).
    };

    # ---------- Quality of life ----------
    globals.mapleader = " ";
    opts = {
      number = true;
      relativenumber = true;
      termguicolors = true;
      clipboard = "unnamedplus";
    };
    keymaps = [
      # Quick file tree / placeholder (replace with your favorite)
      { mode = "n"; key = "<leader>w"; action = ":w<CR>"; options.desc = "Save"; }
      { mode = "n"; key = "<leader>q"; action = ":q<CR>"; options.desc = "Quit"; }
    ];
  };
}
