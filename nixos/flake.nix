{
  description = "NixOS config flake";

  inputs = {
    musnix = {
      url = "github:musnix/musnix";
    };
  };

  outputs = {
    self,
    nixpkgs,
    musnix,
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
        ./configuration.nix
      ];
    };
  };
}
