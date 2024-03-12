{
  description = "NixOS config flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    musnix = {
      url = "github:musnix/musnix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sway-new-workspace = {
      url = "github:mikidep/sway-new-workspace";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs-wayland = {
      url = "github:nix-community/nixpkgs-wayland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    musnix,
    home-manager,
    nixpkgs-wayland,
    ...
  }: let
    system = "x86_64-linux";
  in {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit system;};
      modules = [
        musnix.nixosModules.musnix
        home-manager.nixosModules.home-manager
        ./nixos/configuration.nix
        {
          home-manager.useUserPackages = true;
          home-manager.users.mikidep.imports = with inputs; [
            ./home-manager/home.nix
            ./home-manager/desktop.nix
            nix-index-database.hmModules.nix-index
            nixvim.homeManagerModules.nixvim
            {
              nixpkgs.overlays = [
                (_: _: {
                  sway-new-workspace = sway-new-workspace.packages.${system}.default;
                })
                # nixpkgs-wayland.overlay
              ];
            }
          ];
        }
      ];
    };
  };
}
