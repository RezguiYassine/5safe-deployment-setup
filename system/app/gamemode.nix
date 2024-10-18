{ pkgs, ... }:

{
  # Feral GameMode
  environment.systemPackages = with pkgs;[
    gamemode
    (lutris.override {
        extraPkgs = pkgs: [
         # List package dependencies here
        ];
        extraLibraries =  pkgs: [
        # List library dependencies here
        ];
      }
    )
  ];
  programs.gamemode.enable = true;
}
