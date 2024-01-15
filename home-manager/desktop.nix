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
        -size 1920x1080 \
        label:"oh no, not you again!" $out
    '';
  in "${bg}";
in {
  # stylix = {
  #   image = bg;
  #   polarity = "dark";
  #   targets.kitty.enable = false;
  # };

  imports = [
    ./sway.nix
  ];
  _module.args = {inherit bg;};
  services.udiskie.enable = true;
  xdg = {
    enable = true;

    configFile = {
      "pipewire/pipewire-pulse.conf.d/switch-on-connect.conf".text = ''
        pulse.cmd = [
            { cmd = "load-module" args = "module-switch-on-connect" }
        ]
      '';
    };

    desktopEntries.whatsapp = {
      type = "Application";
      name = "WhatsApp";
      comment = "Launch WhatsApp";
      icon = pkgs.fetchurl {
        url = "https://upload.wikimedia.org/wikipedia/commons/thumb/6/6b/WhatsApp.svg/240px-WhatsApp.svg.png";
        hash = "sha256-ZbTuq5taAsRvdfJqvqw8cqR5z4/Ogpt/nEb1npp/l4U=";
      };
      exec = ''${pkgs.chromium}/bin/chromium --app="https://web.whatsapp.com/"'';
      terminal = false;
    };
  };
}
