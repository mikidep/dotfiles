{
  pkgs,
  fetchFromGitHub,
  writeShellApplication,
}: let
  src = fetchFromGitHub {
    owner = "Gustash";
    repo = "Hyprshot";
    rev = "382bf0b";
    hash = "sha256-+LCQDilin6yKzfXjUV4MIhNHA/VXhuoh81rq0f0Wkso=";
  };
in
  writeShellApplication {
    name = "hyprshot";
    runtimeInputs = with pkgs; [
      jq
      grim
      slurp
      wl-clipboard
      libnotify
    ];
    text = let
      s = builtins.readFile "${src}/hyprshot";
    in
      builtins.replaceStrings [
        ''[ -z "$XDG_PICTURES_DIR" ] && type xdg-user-dir &> /dev/null && XDG_PICTURES_DIR=$(xdg-user-dir PICTURES)''
        ''[ -z "$HYPRSHOT_DIR" ] && SAVEDIR=''${XDG_PICTURES_DIR:=~} || SAVEDIR=''${HYPRSHOT_DIR}''
      ]
      [
        ''''
        ''SAVEDIR=~/Pictures/Screenshots''
      ]
      s;
    checkPhase = "";
  }
