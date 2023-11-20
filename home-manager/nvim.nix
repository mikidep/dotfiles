{pkgs, ...}: {
  home.packages = [
    pkgs.nvim-pkg
  ];
  programs.neovim = {
    enable = false;
#    package = pkgs.nvim-pkg;
  };
}
