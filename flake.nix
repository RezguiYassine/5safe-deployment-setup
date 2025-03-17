{
  description = "User flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-24.11";
    blocklist-hosts = {
      url = "github:StevenBlack/hosts";
      flake = false;
    };
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    stylix = {
      url = "github:danth/stylix/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix.url = "github:ryantm/agenix";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, agenix, disko, flake-utils, ... }:
    let
      lib = nixpkgs.lib;
    in
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        constants = import ./constants.nix { inherit pkgs; };
      in
      {
        homeConfigurations = lib.listToAttrs (
          map (machine: {
            name = "safe-${machine.profile}";
            value = home-manager.lib.homeManagerConfiguration {
              inherit pkgs;
              modules = [
                (./. + "/profiles/${machine.profile}/home.nix")
              ];
              extraSpecialArgs = {
                systemSettings = constants.baseSystemSettings // {
                  hostName = machine.hostname;
                  profile = machine.profile;
                };
                inherit (constants) userSettings;
                inherit inputs;
              };
            };
          }) constants.machines
        );

        nixosConfigurations = lib.listToAttrs (
          map (machine: {
            name = machine.hostname;
            value = lib.nixosSystem {
              system = constants.baseSystemSettings.system;
              modules = [
                (./. + "/profiles/${machine.profile}/configuration.nix")
                disko.nixosModules.disko
                agenix.nixosModules.default
              ];
              specialArgs = {
                systemSettings = constants.baseSystemSettings // {
                  hostName = machine.hostname;
                  profile = machine.profile;
                };
                inherit (constants) userSettings;
                inherit inputs;
                inherit constants;
              };
            };
          }) constants.machines
        );
      }
    );
}
