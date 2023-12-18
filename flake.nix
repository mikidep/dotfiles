{
  description = "NixOS config flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    musnix.url = "github:musnix/musnix";
    musnix.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # nixvim = {
    #   url = "github:nix-community/nixvim";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    ags = {
      url = "github:Aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sway-new-workspace = {
      url = "github:mikidep/sway-new-workspace";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix.url = "github:danth/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";

    neovim-flake = {
      url = "github:cwfryer/neovim-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    musnix,
    home-manager,
    ...
  }: let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit system pkgs;};
      modules = [
        musnix.nixosModules.musnix
        home-manager.nixosModules.home-manager
        ./nixos/configuration.nix
        {
          home-manager.useUserPackages = true;
          home-manager.users.mikidep.imports = with inputs; [
            ./home-manager/home.nix
            ./home-manager/desktop.nix
            # stylix.homeManagerModules.stylix
            {home.packages = [neovim-flake.packages.${system}.lazy];}
            nix-index-database.hmModules.nix-index
            ags.homeManagerModules.default
            {
              nixpkgs.overlays = [
                (_: _: {
                  sway-new-workspace = sway-new-workspace.packages.${system}.default;
                })
              ];
            }
          ];
        }
      ];
    };
  };
}
