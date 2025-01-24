{
  config,
  pkgs,
  lib,
  ...
}:

{
  services.xserver.windowManager.qtile = {
    enable = true;
    extraPackages =
      python3Packages: with pkgs; [
        python312Packages.qtile
        python312Packages.pywlroots
        python312Packages.pywayland
        python312Packages.xkbcommon
      ];
  };
}
