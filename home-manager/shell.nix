{ pkgs, ... }: {
  home.packages = with pkgs; [
    htop
    fortune
    zoxide
    killall
  ];
  programs.fish = {
    enable = true;
    functions = {
      nix_run = ''nix run nixpkgs#$argv[1] -- $argv[2..]'';
    };
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
      fish_add_path .local/bin/
      zoxide init fish | source
      abbr --add sg "${pkgs.shell_gpt}/bin/sgpt --repl temp --shell"
      abbr --add ns "nix shell nixpkgs#"
      abbr --add nr "nix_run"
    '';
    plugins = [
      {
        name = "nix-env.fish";
        src = pkgs.fetchFromGitHub {
          owner = "lilyball";
          repo = "nix-env.fish";
          rev = "7b65bd228429e852c8fdfa07601159130a818cfa";
          sha256 = "sha256-RG/0rfhgq6aEKNZ0XwIqOaZ6K5S4+/Y5EEMnIdtfPhk=";
        };
      }
    ];
    shellAliases = {
      nix-shell = "nix-shell --command fish";
    };

    functions = {
      fish_user_key_bindings = ''
      
      '';
    };
  };
  programs.nix-index.enable = true;
}
