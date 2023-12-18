{pkgs, ...}: let
  bg = let
    convert = "${pkgs.imagemagick}/bin/convert";
    font = "${pkgs.iosevka}/share/fonts/truetype/iosevka-extendedmediumitalic.ttf";
    bg = pkgs.runCommand "desktop-bg.png" {} ''
      ${convert} -font ${font} \
        -background black \
        -fill white \
        -pointsize 24 \
        -gravity center \
        label:"oh no, not you again!" $out
    '';
  in "${bg}";
in {
  imports = [
    (import ./sway.nix {inherit bg;})
  ];
}
