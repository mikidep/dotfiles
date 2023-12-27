{pkgs, ...}: {
  home.packages = with pkgs; [
    nil
  ];
  programs.nixvim = {
    enable = true;
    colorschemes.tokyonight.enable = true;
    clipboard.providers.wl-copy.enable = true;
    plugins = {
      noice.enable = true;
      neo-tree.enable = true;
      treesitter.enable = true;
      telescope.enable = true;
      which-key.enable = true;
    };
    extraPlugins = with pkgs.vimPlugins; [
      nvim-lspconfig
    ];
    globals.mapleader = "<space>";
    keymaps = [
      {
        mode = "n";
        key = "<leader>cf";
        lua = true;
        action = ''
          (function()
                   vim.lsp.buf.format { async = true }
                 end)
        '';
      }
    ];
    extraConfigLua = ''
      local lspconfig = require("lspconfig")

      lspconfig.nil_ls.setup {
        autostart = true,
        cmd = { "nil" },
        settings = {
          ['nil'] = {
            formatting = {
              command = { "${pkgs.alejandra}/bin/alejandra" },
            },
          },
        },
      }
    '';
  };
}
