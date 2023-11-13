{pkgs, ...}: let
  templateFile = name: template: data:
    pkgs.stdenv.mkDerivation {
      name = "${name}";

      nativeBuildInpts = [pkgs.mustache-go];

      # Pass Json as file to avoid escaping
      passAsFile = ["jsonData"];
      jsonData = builtins.toJSON data;

      # Disable phases which are not needed. In particular the unpackPhase will
      # fail, if no src attribute is set
      phases = ["buildPhase" "installPhase"];

      buildPhase = ''
        ${pkgs.mustache-go}/bin/mustache $jsonDataPath ${template} > rendered_file
      '';

      installPhase = ''
        cp rendered_file $out
      '';
    };
in {
  home.packages = with pkgs; [
    libnotify
    font-awesome
    (callPackage ./hyprshot.nix {})
    swww
  ];

  services.dunst = {
    enable = true;
    settings.global.timeout = 5;
  };

  services.blueman-applet.enable = true;

  wayland.windowManager.hyprland = {
    enable = true;
    enableNvidiaPatches = true;
    settings = {
      monitor = [
        "HDMI-A-1,preferred,auto,auto"
        ",preferred,auto,1"
      ];

      env = [
        "OZONE_PLATFORM,wayland"
        "NIXOS_OZONE_WL,1"
      ];

      exec-once = let
        convert = "${pkgs.imagemagick}/bin/convert";
        font = "${pkgs.iosevka}/share/fonts/truetype/iosevka-extendedmediumitalic.ttf";
        bg = pkgs.runCommand "desktop-bg.png" {} ''
          ${convert} -font ${font} \
            -background black \
            -fill white \
            -pointsize 24 \
            label:"oh no, not you again!" $out
        '';
      in [
        "swww init && swww img ${bg} --no-resize"
        "eww open bar"
      ];

      exec = [
      ];

      input = {
        kb_layout = "it";
        numlock_by_default = true;
      };

      general = {
        gaps_in = 2;
        gaps_out = 2;
        border_size = 2;
      };

      decoration.rounding = 2;

      dwindle.force_split = 2;

      bind = let
        rofi = "${pkgs.rofi-wayland}/bin/rofi";
        rofi-cmd = ''${rofi} -show combi -combi-modes "window,drun" -show-icons -theme solarized'';
        rofi-run = ''${rofi} -show run -theme solarized'';
      in
        [
          "SUPER, Q, exec, kitty"
          "SUPER, space, exec, ${rofi-cmd}"
          "SUPER, U, exec, hyprctl reload,"
          "ALT, f2, exec, ${rofi-run}"
          "ALT, f4, killactive"
          "CTRL ALT, left,  workspace, -1"
          "CTRL ALT, right, workspace, +1"
          "CTRL ALT SHIFT, left,  movetoworkspace, -1"
          "CTRL ALT SHIFT, right, movetoworkspace, +1"
          "ALT, tab, cyclenext"

          "SUPER CTRL, left, resizeactive, -40 0"
          "SUPER CTRL, right, resizeactive, 40 0"
          "SUPER CTRL, up, resizeactive, 0 -40"
          "SUPER CTRL, down, resizeactive, 0 40"
        ]
        ++ (
          builtins.concatMap
          (dir: let
            d = builtins.substring 0 1 dir;
          in [
            "SUPER, ${dir}, movefocus, ${d}"
            "SUPER SHIFT, ${dir}, movewindow, ${d}"
          ]) ["up" "down" "left" "right"]
        );
      bindm = [
        "SUPER, mouse:272, movewindow"
        "SUPER, mouse:273, resizewindow"
        "SUPER, mouse:274, movewindow"
      ];
      binde = let
        unmute = "wpctl set-mute @DEFAULT_AUDIO_SINK@ 0";
      in [
        ", XF86AudioRaiseVolume, exec, ${unmute}; wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, ${unmute}; wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86MonBrightnessUp, exec, ${pkgs.brightnessctl}/bin/brightnessctl s +10%"
        ", XF86MonBrightnessDown, exec, ${pkgs.brightnessctl}/bin/brightnessctl s 10%-"
        ", XF86AudioMute,        exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ];
      bindl = [
        #   '', switch:off:Lid Switch,exec,hyprctl keyword monitor eDP-1,preferred,auto,auto''
        #   '', switch:on:Lid Switch,exec,hyprctl keyword monitor eDP-1,disable''
        #   '', monitoradded, exec, ${updateMonitor}''
        #   '', monitorremoved, exec, ${updateMonitor}''
      ];
    };
  };

  programs.eww = {
    enable = true;
    package = pkgs.eww-wayland;
    configDir = pkgs.linkFarm "eww-config" [
      {
        name = "eww.yuck";
        path =
          templateFile
          "eww.yuck"
          ./eww-config/eww.yuck
          {
            hyprland-workspaces = let
              hyprland-workspaces = pkgs.callPackage ./hyprland-workspaces.nix {};
            in "${hyprland-workspaces}/bin/hyprland-workspaces";
            jq = "${pkgs.jq}/bin/jq";
            get-volume = "wpctl get-volume @DEFAULT_AUDIO_SINK@";
            brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
          };
      }
      {
        name = "eww.scss";
        path = ./eww-config/eww.scss;
      }
    ];
  };

  xdg.enable = true;
  # services.udiskie.enable = true;

  xdg.desktopEntries.whatsapp = {
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
  xdg.desktopEntries.firefox = let
    firefox = pkgs.firefox;
  in {
    type = "Application";
    name = "Firefox";
    comment = "Launch Firefox";
    icon = "${firefox}/lib/firefox/browser/chrome/icons/default/default128.png";
    exec = ''${firefox}/bin/firefox %U'';
    terminal = false;
  };
}
