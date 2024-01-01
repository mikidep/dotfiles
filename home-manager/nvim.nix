{pkgs, ...}: {
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
    options = {
      expandtab = true;
      shiftwidth = 2;
      tabstop = 2;
      number = true;
      relativenumber = true;
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
  };
}
