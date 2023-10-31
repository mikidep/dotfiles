{ pkgs, ... }: {
  imports = [
    ./vscode.nix
    ./shell.nix
    ./ssh.nix
  ];

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "mikidep";
  home.homeDirectory = "/home/mikidep";

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    (agda.withPackages (p: [ p.cubical p.standard-library ]))
    stack
    nerdfonts
    nnn
    trashy

    firefox
    chromium
    # discord
    telegram-desktop
    gimp
    vlc
    jabref
    inkscape
    openscad
    signal-desktop
    ffmpeg_6-full
    audacity

    alsa-tools  
    qpwgraph
    reaper
    

  ];


  fonts.fontconfig.enable = true;

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.kitty.enable = true;
  programs.git = {
    enable = true;
    userName = "Michele De Pascalis";
    userEmail = "michele.de.pascalis.1024@gmail.com";
  };
  programs.neovim.enable = true;

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      droidcam-obs
    ];
  };
}
