{pkgs, ...}: {
  home.packages = with pkgs; [
    ripgrep
  ];
  programs.nixvim = {
    enable = true;
    colorschemes.tokyonight.enable = true;
    clipboard.providers.wl-copy.enable = true;
    plugins = {
      auto-session.enable = true;
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
      treesitter = {
        enable = true;
        indent = true;
        incrementalSelection.enable = true;
      };
      telescope.enable = true;
      which-key.enable = true;
      nvim-cmp = {
        enable = true;
        mappingPresets = ["insert"];
      };
      cmp-vim-lsp.enable = true;
      lsp-format = {
        enable = true;
        lspServersToEnable = "all";
      };
      lsp = {
        enable = true;
        servers = {
          nil_ls = {
            enable = true;
            cmd = ["${pkgs.nil}/bin/nil"];
            settings.formatting.command = ["${pkgs.alejandra}/bin/alejandra"];
          };
          lua-ls = {
            enable = true;
            cmd = ["${pkgs.lua-language-server}/bin/lua-language-server"];
          };
        };
      };
    };
    extraPlugins = with pkgs.vimPlugins; [
      hydra-nvim
      playground # treesitter playground
    ];
    globals.mapleader = " ";
    options = {
      expandtab = true;
      shiftwidth = 2;
      tabstop = 2;
      smartindent = true;
      number = true;
      relativenumber = true;
      wrap = false;
      timeoutlen = 50;
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
          {
            key = " ";
            action = ''<cmd>Telescope find_files<CR>'';
          }
          {
            key = ",";
            action = ''<cmd>Telescope buffers<CR>'';
          }
          {
            key = "f";
            action = ''<cmd>Telescope live_grep<CR>'';
          }
          {
            key = ":";
            action = ''<cmd>Telescope commands<CR>'';
          }
          {
            key = "qq";
            action = ''<cmd>qa<CR>'';
          }
        ];
    in
      leaderkm;
  };
}
