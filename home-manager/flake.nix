{
  description = "Home Manager configuration of mikidep";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    eww = {
      url = "github:elkowar/eww";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    /*
       flatpak = {
      url = "github:yawnt/declarative-nix-flatpak/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    */
    /*
       flatpaks = {
      url = "github:GermanBread/declarative-flatpak/stable";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    */
  };

  outputs = {
    nixpkgs,
    home-manager,
    eww,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      config.overlays = [eww.overlays.default];
    };
  in {
    homeConfigurations."mikidep" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      # Specify your home configuration modules here, for example,
      # the path to your home.nix.
      modules = [
        ./home.nix
        ./desktop.nix
      ];

      extraSpecialArgs = {
      };

      # Optionally use extraSpecialArgs
      # to pass through arguments to home.nix
    };
  };
}
