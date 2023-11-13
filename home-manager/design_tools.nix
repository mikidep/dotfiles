{pkgs, ...}: {
  home.packages = with pkgs; [openscad prusa-slicer];

  home.file.BOSL2 = {
    source = let
      src = pkgs.fetchFromGitHub {
        owner = "BelfrySCAD";
        repo = "BOSL2";
        rev = "46f7835";
        hash = "sha256-rsQZM55OZw9hEX972+nrq9QU+Cc1S5oE/A3jIu4PFMg=";
      };
    in "${src}";
    target = ".local/share/OpenSCAD/libraries/BOSL2";
  };
}
