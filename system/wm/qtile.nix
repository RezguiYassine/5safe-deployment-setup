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
      python3Packages:  with python3Packages; [
        pywlroots
        pywayland
        xkbcommon
      ];
  };
}
