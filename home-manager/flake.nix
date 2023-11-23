{
  description = "Home Manager configuration of mikidep";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # eww = {
    #   url = "github:elkowar/eww";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # kickstart-nix-nvim = {
    #   url = "github:mrcjkb/kickstart-nix.nvim";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    nixvim = {
      url = "github:nix-community/nixvim";
      # If you are not running an unstable channel of nixpkgs, select the corresponding branch of nixvim.
      # url = "github:nix-community/nixvim/nixos-23.05";
  
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    # eww,
    nix-index-database,
    nixvim,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
      };
      overlays = [
        # eww.overlays.default
      ];
    };
  in {
    homeConfigurations."mikidep" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      # Specify your home configuration modules here, for example,
      # the path to your home.nix.
      modules = [
        ./home.nix
        ./desktop.nix
        nix-index-database.hmModules.nix-index
        nixvim.homeManagerModules.nixvim
      ];

      extraSpecialArgs = {
      };

      # Optionally use extraSpecialArgs
      # to pass through arguments to home.nix
    };
  };
}
