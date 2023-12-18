{bg, ...}: {
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [swaybg sway-new-workspace];

  wayland.windowManager.sway = let
    rofi = "${pkgs.rofi-wayland}/bin/rofi";
    rofi-menu = ''${rofi} -show combi -combi-modes "window,drun" -show-icons -theme solarized'';
    rofi-run = ''${rofi} -show run -theme solarized'';
  in {
    enable = true;
    package = pkgs.swayfx;

    config = {
      input."*" = {
        xkb_layout = "it";
        xkb_numlock = "enabled";
      };

      output = {
        "*" = {
          bg = "${bg} center #000000";
        };
      };

      window.titlebar = false;
      terminal = "kitty";
      menu = rofi-menu;
      modifier = "Mod4";

      gaps = {
        inner = 3;
        smartGaps = true;
        smartBorders = "on";
      };

      keybindings =
        lib.mkOptionDefault
        (lib.attrsets.mapAttrs'
          (k: v: {
            name = "Ctrl+Alt+${k}";
            value = v;
          })
          {
            "H" = "workspace prev_on_output";
            "Left" = "workspace prev_on_output";
            "L" = "workspace next_on_output";
            "Right" = "workspace next_on_output";
            "Shift+H" = "move container to workspace prev_on_output, workspace prev_on_output;";
            "Shift+Left" = "move container to workspace prev_on_output, workspace prev_on_output;";
            "Shift+L" = "move container to workspace next_on_output, workspace next_on_output;";
            "Shift+Right" = "move container to workspace next_on_output, workspace next_on_output;";
          }
          // (let
            unmute = "wpctl set-mute @DEFAULT_AUDIO_SINK@ 0";
          in {
            "Alt+F2" = "exec ${rofi-run}";

            "XF86AudioRaiseVolume" = "exec ${unmute}; wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%+";
            "XF86AudioLowerVolume" = "exec ${unmute}; wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%-";
            "XF86MonBrightnessUp" = "exec ${pkgs.brightnessctl}/bin/brightnessctl s +10%";
            "XF86MonBrightnessDown" = "exec ${pkgs.brightnessctl}/bin/brightnessctl s 10%-";
            "XF86AudioMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          }));
    };

    extraConfig = ''
      bindswitch lid:on output eDP-1 disable
      bindswitch lid:off output eDP-1 enable
    '';
  };
}
