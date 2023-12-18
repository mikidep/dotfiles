{bg, ...}: {
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [swaybg];

  wayland.windowManager.sway = let
    rofi = "${pkgs.rofi-wayland}/bin/rofi";
    rofi-menu = ''${rofi} -show combi -combi-modes "window,drun" -show-icons -theme solarized'';
    rofi-run = ''${rofi} -show run -theme solarized'';
  in {
    enable = true;
    package = pkgs.swayfx;

    config = {
      input."*".xkb_layout = "it";

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
          // {
            "Alt+F2" = "exec ${rofi-run}";
          });
    };
  };
}
