{ pkgs, fetchFromGitHub, writeShellApplication }:
let
  src = fetchFromGitHub {
    owner = "Gustash";
    repo = "Hyprshot";
    rev = "1.2.3";
    hash = "sha256-sew47VR5ZZaLf1kh0d8Xc5GVYbJ1yWhlug+Wvf+k7iY=";
  };
in writeShellApplication {
  name = "hyprshot";
  runtimeInputs = with pkgs; [
    jq
    grim
    slurp
    wl-clipboard
    libnotify
  ];
  text = builtins.readFile "${src}/hyprshot";
  checkPhase = "";
}