{pkgs, ...}: {
  home.packages = with pkgs; [
    ripgrep
  ];
  programs.nixvim = {
    enable = true;
    colorschemes.tokyonight.enable = true;
    plugins = {
      auto-session.enable = true;
      lualine.enable = true;
      luasnip.enable = true;
      nvim-cmp = {
        enable = true;
        autoEnableSources = true;
        sources = [
          {name = "nvim_lsp";}
          {name = "path";}
          {name = "buffer";}
          {name = "luasnip";}
        ];
        snippet.expand = "luasnip";

        mapping = {
          "<CR>" = "cmp.mapping.confirm({ select = true })";
          "<Tab>" = {
            action = ''
              function(fallback)
                local luasnip = require("luasnip")

                if cmp.visible() then
                  cmp.select_next_item()
                elseif luasnip.expandable() then
                  luasnip.expand()
                elseif luasnip.expand_or_jumpable() then
                  luasnip.expand_or_jump()
                -- elseif check_backspace() then
                --   fallback()
                else
                  fallback()
                end
              end
            '';
            modes = ["i" "s"];
          };
        };
      };
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
      cmp-vim-lsp.enable = false;
      lsp-format = {
        enable = true;
        lspServersToEnable = "all";
      };
      lsp = {
        enable = true;
        servers = {
          nil_ls = {
            enable = true;
            settings.formatting.command = ["${pkgs.alejandra}/bin/alejandra"];
          };
          lua-ls.enable = true;
          pyright.enable = true;
          rust-analyzer = {
            enable = true;
            installCargo = true;
            installRustc = true;
          };
        };
      };
    };
    extraPlugins = with pkgs.vimPlugins; [
      hydra-nvim
      # playground # treesitter playground
      nvim-lspconfig
    ];
    clipboard = {
      providers.wl-copy.enable = true;
      register = "unnamedplus";
    };
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
    # extraConfigLuaPre = ''
    #   vim.cmd [[redir! > vim_log.txt]]
    #   vim.cmd [[echom "Test Message"]]
    # '';
    extraConfigLua = with builtins;
      replaceStrings [
        "@openscad-lsp@"
      ]
      [
        "${pkgs.openscad-lsp}/bin/openscad-lsp"
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
      leaderkm
      ++ [
        # c and d don't cut the removed text
        {
          key = "c";
          action = ''"_c'';
          mode = "x";
        }
        {
          key = "d";
          action = ''"_d'';
          mode = "x";
        }
        {
          # move to the end of region after yanking
          key = "y";
          action = ''y']'';
          mode = "x";
        }
      ];
  };
}
