# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.plymouth.enable = true;
  boot.kernel.sysctl."vm.max_map_count" = 262144;
  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  # time.timeZone = "Europe/Tallinn";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "et_EE.UTF-8";
    LC_IDENTIFICATION = "et_EE.UTF-8";
    LC_MEASUREMENT = "et_EE.UTF-8";
    LC_MONETARY = "et_EE.UTF-8";
    LC_NAME = "et_EE.UTF-8";
    LC_NUMERIC = "et_EE.UTF-8";
    LC_PAPER = "et_EE.UTF-8";
    LC_TELEPHONE = "et_EE.UTF-8";
    LC_TIME = "et_EE.UTF-8";
  };

  hardware.bluetooth.enable = true;
  services = {
    # Enable the X11 windowing system.
    # services.xserver.enable = true;
    flatpak.enable = true;
    automatic-timezoned.enable = true;

    # Enable the GNOME Desktop Environment.
    # xserver.displayManager.gdm.enable = true;
    # services.xserver.desktopManager.gnome.enable = true;

    # Configure keymap in X11
    # services.xserver = {
    #   layout = "it";
    #   xkbVariant = "";
    # };

    udisks2.enable = true;

    # Enable CUPS to print documents.
    printing.enable = true;

    udev.extraRules = ''
      ACTION=="add" SUBSYSTEM=="pci" ATTR{vendor}=="0x0461" ATTR{device}=="0x3f41" ATTR{power/wakeup}="enabled"
    '';

    greetd = {
      enable = true;
      settings = {
        default_session = {
          # command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd sway";
          user = "greeter";
        };
      };
    };

    # Load nvidia driver for Xorg and Wayland
    # services.xserver.videoDrivers = [ "nvidia" ];

    blueman.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };
  };

  security.polkit.enable = true;

  # Configure console keymap
  console.keyMap = "it";
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-wlr
    ];
  };

  programs = {
    adb.enable = true;

    hyprland = {
      enable = true;
      enableNvidiaPatches = true;
      xwayland.enable = true;
    };

    regreet = {
      enable = false;
      settings = {
        background.path = let
          bg = pkgs.runCommand "regreet-bg" {} ''
            mkdir $out
            ${pkgs.imagemagick}/bin/magick -size 1920x1080 xc:black $out/bg.png
          '';
        in "${bg}/bg.png";
        GTK.application_prefer_dark_theme = true;
      };
    };

    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    # programs.mtr.enable = true;
    # programs.gnupg.agent = {
    #   enable = true;
    #   enableSSHSupport = true;
    # };

    fish.enable = true;
  };

  environment.sessionVariables = {
    # If your cursor becomes invisible
    WLR_NO_HARDWARE_CURSORS = "1";
    # Hint electron apps to use wayland
    NIXOS_OZONE_WL = "1";
  };

  # Enable OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  hardware.nvidia = {
    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    powerManagement.enable = false;
    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of
    # supported GPUs is at:
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
    # Only available from driver 515.43.04+
    # Do not disable this unless your GPU is unsupported or if you have a good reason to.
    open = true;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Enable sound with pipewire.
  sound.enable = true;
  security.rtkit.enable = true;

  musnix.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mikidep = {
    isNormalUser = true;
    description = "Michele De Pascalis";
    extraGroups = [
      "networkmanager"
      "wheel"
      "adbusers"
      "audio"
      "dialout"
      "docker"
    ];
    shell = pkgs.fish;
  };

  environment.shells = with pkgs; [zsh fish];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  ];

  services.upower.enable = true;

  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
    daemon.settings.default-ulimits.nofile = {
      Hard = 65536;
      Name = "nofile";
      Soft = 65536;
    };
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
