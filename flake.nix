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

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      agenix,
      disko,
      ...
    }:
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;
      pkgs = nixpkgs.legacyPackages.${system};
      systemSettings = {
        system = "x86_64-linux";
        hostName-server = "safe-server";
        hostName-agent-1 = "safe-agent-1";
        profile-server = "server";
        profile-agent-1 = "agent-1"
        timeZone = "Europe/Berlin";
        locale = "en_US.UTF-8";
        bootMode = "uefi";
        bootMountPath = "/boot";
        grubDevice = ""; # device identifier for grub; only used for legacy (bios) boot mode
        gpuType = "intel"; # amd, intel or nvidia; only makes some slight mods for amd at the moment
        hasNvidia = if(systemSettings.gpuType == "nvidia") then true else false;
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
      homeConfigurations = {
        safe-server = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            (./. + "/profiles" + ("/" + systemSettings.profile-server) + "/home.nix") # load home.nix from selected PROFILE
          ];
          extraSpecialArgs = {
            # pass config variables from above
            inherit systemSettings;
            inherit userSettings;
            inherit inputs;
          };
        };
        safe-agent-1 = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            (./. + "/profiles" + ("/" + systemSettings.profile-agent-1) + "/home.nix") # load home.nix from selected PROFILE
          ];
          extraSpecialArgs = {
            # pass config variables from above
            inherit systemSettings;
            inherit userSettings;
            inherit inputs;
          };
        };
      };

      nixosConfigurations = {
        "${systemSettings.hostName-server}" = lib.nixosSystem {
          inherit system;
          modules = [
            (./. + "/profiles" + ("/" + systemSettings.profile-server) + "/configuration.nix")
            disko.nixosModules.disko
            agenix.nixosModules.default
          ]; # load configuration.nix from selected PROFILE
          specialArgs = {
            inherit systemSettings;
            inherit userSettings;
            inherit inputs;
          };
        };
        "${systemSettings.hostName-agent-1}" = lib.nixosSystem {
          inherit system;
          modules = [
            (./. + "/profiles" + ("/" + systemSettings.profile-agent-1) + "/configuration.nix")
            disko.nixosModules.disko
            agenix.nixosModules.default
          ]; # load configuration.nix from selected PROFILE
          specialArgs = {
            inherit systemSettings;
            inherit userSettings;
            inherit inputs;
          };
        };
      };
    };
}
