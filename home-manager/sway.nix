{
  pkgs,
  lib,
  config,
  bg,
  ...
}: {
  home.packages = with pkgs; [swaybg];

  services.mako = {
    enable = false;
    anchor = "bottom-right";
    defaultTimeout = 5000;
    groupBy = "app-icon";
    extraConfig = let
      makoctl = "${pkgs.mako}/bin/makoctl";
      rofi = "${pkgs.rofi-wayland}/bin/rofi";
    in ''
      on-notify=exec ${makoctl} menu ${rofi} -dmenu -p "Choose action:"
    '';
  };

  programs.wezterm = {
    enable = true;
    extraConfig = ''
      local config = {}
      config.window_decorations = "RESIZE"
      config.enable_tab_bar = false
      config.font_size = 12
      config.window_padding = {
        left = "2pt",
        right = "2pt",
        top = 0,
        bottom = 0,
      }
      config.adjust_window_size_when_changing_font_size = false
      -- config.use_resize_increments = true
      return config
    '';
  };

  wayland.windowManager.sway = let
    rofi = "${pkgs.rofi-wayland}/bin/rofi";
    rofi-menu = ''${rofi} -show combi -combi-modes "window,drun" -show-icons -theme solarized'';
    rofi-run = ''${rofi} -show run -theme solarized'';
    # currently, there is some friction between sway and gtk:
    # https://github.com/swaywm/sway/wiki/GTK-3-settings-on-Wayland
    # the suggested way to set gtk settings is with gsettings
    # for gsettings to work, we need to tell it where the schemas are
    # using the XDG_DATA_DIR environment variable
    # run at the end of sway config
    configure-gtk =
      pkgs.writeShellScript
      "configure-gtk"
      (
        let
          schema = pkgs.gsettings-desktop-schemas;
          datadir = "${schema}/share/gsettings-schemas/${schema.name}";
        in ''
          export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
          gnome_schema=org.gnome.desktop.interface
          gsettings set $gnome_schema gtk-theme 'Dracula'
        ''
      );
    update-lid =
      pkgs.writeShellScript
      "update-lid"
      ''
        #!/bin/sh
        if grep -q open /proc/acpi/button/lid/LID/state; then
            swaymsg output eDP-1 enable
        else
            swaymsg output eDP-1 disable
        fi
      '';
  in {
    enable = true;
    package = let
      cfg = config.wayland.windowManager.sway;
    in
      pkgs.swayfx.override {
        extraSessionCommands = cfg.extraSessionCommands;
        extraOptions = cfg.extraOptions;
        withBaseWrapper = cfg.wrapperFeatures.base;
        withGtkWrapper = cfg.wrapperFeatures.gtk;
      };

    systemd.enable = true;

    config = {...}: {
      config = {
        input."*" = {
          xkb_layout = "it";
          xkb_numlock = "enabled";
          tap = "enabled";
          tap_button_map = "lrm";
        };

        output = {
          "*" = {
            bg = "${bg} center #000000";
          };
          "Dell Inc. DELL P2719HC H5F9QS2" = {
            scale = "1";
          };
          "LG Electronics LG HDR 4K 0x0000B7E8" = {
            scale = "2";
          };
        };

        window.titlebar = false;
        terminal = "kitty";
        menu = rofi-menu;
        modifier = "Mod4";

        bars = [
          {
            fonts = {
              names = ["Monospace"];
              size = 12.0;
            };
            statusCommand = "${pkgs.i3status}/bin/i3status";
          }
        ];

        gaps = {
          inner = 3;
          smartGaps = true;
          smartBorders = "on";
        };

        focus = {
          followMouse = false;
          newWindow = "urgent";
        };
      };
      options.keybindings = lib.mkOption {
        # This is quite cursed. See https://github.com/NixOS/nixpkgs/issues/16884
        apply = defaultKb:
          defaultKb
          // lib.attrsets.mapAttrs'
          (k: v: {
            name = "Ctrl+Alt+${k}";
            value = v;
          })
          (
            let
              sway-nw = "${pkgs.sway-new-workspace}/bin/sway-new-workspace";
            in {
              "H" = "workspace prev_on_output";
              "Left" = "workspace prev_on_output";
              "L" = "workspace next_on_output";
              "Right" = "workspace next_on_output";
              "Shift+H" = "move container to workspace prev_on_output, workspace prev_on_output;";
              "Shift+Left" = "move container to workspace prev_on_output, workspace prev_on_output;";
              "Shift+L" = "move container to workspace next_on_output, workspace next_on_output;";
              "Shift+Right" = "move container to workspace next_on_output, workspace next_on_output;";
              "N" = "exec ${sway-nw} open";
              "Shift+N" = "exec ${sway-nw} move";
            }
          )
          // (
            let
              unmute = "wpctl set-mute @DEFAULT_AUDIO_SINK@ 0";
            in {
              "Alt+F2" = "exec ${rofi-run}";
              "Mod4+space" = "exec ${rofi-menu}";

              "XF86AudioRaiseVolume" = "exec ${unmute}; exec wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%+";
              "XF86AudioLowerVolume" = "exec ${unmute}; exec wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%-";
              "XF86MonBrightnessUp" = "exec ${pkgs.brightnessctl}/bin/brightnessctl s +10%";
              "XF86MonBrightnessDown" = "exec ${pkgs.brightnessctl}/bin/brightnessctl s 10%-";
              "XF86AudioMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
            }
          );
      };
    };

    extraConfig = let
      launch = "${pkgs.xdg-launch}/bin/xdg-launch";
    in ''
      exec ${configure-gtk}
      exec_always ${update-lid}

      bindswitch lid:on output eDP-1 disable
      bindswitch lid:off output eDP-1 enable

      workspace number 1
      exec firefox
      workspace number 2
      exec kitty
      workspace number 9
      exec telegram-desktop
      exec ${launch} whatsapp
    '';
  };
}
