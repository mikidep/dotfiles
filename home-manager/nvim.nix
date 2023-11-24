{pkgs, ...}: {
  programs.nixvim = {
    enable = true;
    options = {
      clipboard = "unnamedplus"; 
      smartindent = true;
      splitbelow = true;
      splitright = true;
      undofile = true;
      updatetime = 300;
      cursorline = true;
      number = true;
      signcolumn = "yes";
      shiftwidth = 2;
      completeopt = ["menuone" "noselect"];
    };
    plugins = {
      nvim-cmp.enable = true;
      cmp-nvim-lsp.enable = true;
      neo-tree.enable = true;
    };
    extraPlugins = with pkgs.vimPlugins; [
      vim-sleuth
      nvim-lspconfig
      gruvbox
    ];
    keymaps = [
     # { key = "<space>e"; action = "vim.diagnostic.open_float"; lua = true; }
     { key = "[d";       action = "vim.diagnostic.goto_prev";  lua = true; }
     { key = "]d";       action = "vim.diagnostic.goto_next";  lua = true; }
     { key = "<space>q"; action = "vim.diagnostic.setloclist"; lua = true; }
     { key = "<space>e"; action = "<Cmd>Neotree toggle=true<CR>"; }
    ];
    colorscheme = "gruvbox";
    extraConfigLua = ''
      -- Setup language servers.
      local lspconfig = require('lspconfig')
      lspconfig.pyright.setup {}
      lspconfig.tsserver.setup {}
      lspconfig.rust_analyzer.setup {
        -- Server-specific settings. See `:help lspconfig-setup`
        settings = {
          ['rust-analyzer'] = {},
        },
      }
    '';
  };
}
