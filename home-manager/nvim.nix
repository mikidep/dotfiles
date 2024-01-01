{pkgs, ...}: {
  programs.nixvim = {
    enable = true;
    colorschemes.tokyonight.enable = true;
    clipboard.providers.wl-copy.enable = true;
    plugins = {
      noice.enable = true;
      neo-tree = {
        enable = true;
        openFilesInLastWindow = false;
        window.width = 30;
        eventHandlers.file_opened = ''
          function(file_path)
            --auto close
            require("neo-tree").close_all()
          end
        '';
      };
      treesitter.enable = true;
      telescope.enable = true;
      which-key.enable = true;
    };
    extraPlugins = with pkgs.vimPlugins; [
      nvim-lspconfig
    ];
    globals.mapleader = " ";
    options = {
      expandtab = true;
      shiftwidth = 2;
      tabstop = 2;
      number = true;
      relativenumber = true;
      wrap = false;
    };
    extraFiles = let
      nvfs = pkgs.fetchFromGitHub {
        owner = "LunarVim";
        repo = "Neovim-from-scratch";
        rev = "96fca52";
        hash = "sha256-D9d+nlwe4qZn8cXqA1WaaRu8/q2yoYATrx1Nj6Gokak=";
      };
    in {
      "lua/nvfs-keymaps.lua" = builtins.readFile "${nvfs}/lua/user/keymaps.lua";
    };
    extraConfigLua = with builtins;
      replaceStrings
      [
        "@alejandra@"
        "@nil@"
        "@lua-language-server@"
      ]
      [
        "${pkgs.alejandra}/bin/alejandra"
        "${pkgs.nil}/bin/nil"
        "${pkgs.lua-language-server}/bin/lua-language-server"
      ]
      (readFile ./nvim-extraconfig.lua);
    keymaps = let
      leaderkm =
        map (km: km // {key = "<leader>" + km.key;})
        [
          {
            key = "nt";
            action = "<cmd>Neotree focus toggle=true<CR>";
          }
          {
            key = "cf";
            action = ''
              function()
                vim.lsp.buf.format { async = true }
              end
            '';
            lua = true;
          }
          {
            key = "ca";
            action = ''vim.lsp.buf.code_action'';
            lua = true;
          }
        ];
    in
      leaderkm;
  };
}
