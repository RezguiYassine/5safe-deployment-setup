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
  };

  outputs = inputs@{ self, nixpkgs, home-manager, agenix, disko, ... }:
    let
      lib = nixpkgs.lib;
      pkgs = nixpkgs.legacyPackages."x86_64-linux";
      machines = [
        { hostname = "safe-server"; profile = "server"; }
        { hostname = "safe-agent-1"; profile = "agent-1"; }
        { hostname = "safe-agent-2"; profile = "agent-2"; }
        { hostname = "safe-agent-3"; profile = "agent-3"; }
        # Add more agents as needed
      ];
      baseSystemSettings = {
        system = "x86_64-linux";
        timeZone = "Europe/Berlin";
        locale = "en_US.UTF-8";
        bootMode = "uefi";
        bootMountPath = "/boot";
        grubDevice = ""; # device identifier for grub; only used for legacy (bios) boot mode
        gpuType = "intel"; # amd, intel or nvidia; only makes some slight mods for amd at the moment
        hasNvidia = if(baseSystemSettings.gpuType == "nvidia") then true else false;
      };

      userSettings = rec {
        username = "safe";
        name = "SAFE";
        dotfilesDir = "~/.dotfiles";
        theme = "ayu-dark";
        wm = "xfce"; # Selected window manager or desktop environment; must select one in both ./user/wm/ and ./system/wm/
        wmType = if (wm == "hyprland") then "wayland" else "x11";
        browser = "firefox"; # Default browser; must select one from ./user/app/browser/
        term = "kitty";
        font = "DejaVu Sans Mono";
        fontPkg = pkgs.dejavu_fonts;
        editor = "nvim";
        # EDITOR and TERM session variables must be set in home.nix or other module
      };

    in
    {
      homeConfigurations = lib.listToAttrs (
        map (machine: {
          name = "safe-${machine.profile}";
          value = home-manager.lib.homeManagerConfiguration {
            pkgs = nixpkgs.legacyPackages.${baseSystemSettings.system};
            modules = [
              (./. + "/profiles" + ("/" + machine.profile) + "/home.nix")
            ];
            extraSpecialArgs = {
              systemSettings = baseSystemSettings // { hostName = machine.hostname; };
              inherit userSettings;
              inherit inputs;
            };
          };
        }) machines
      );

      nixosConfigurations = lib.listToAttrs (
        map (machine: {
          name = machine.hostname;
          value = lib.nixosSystem {
            system = baseSystemSettings.system;
            modules = [
              (./. + "/profiles" + ("/" + machine.profile) + "/configuration.nix")
              disko.nixosModules.disko
              agenix.nixosModules.default
            ];
            specialArgs = {
              systemSettings = baseSystemSettings // { hostName = machine.hostname; };
              inherit userSettings;
              inherit inputs;
            };
          };
        }) machines
      );
    };
}
