{ config, pkgs, ... }:
let
  cursorSize = 30;
  cursorTheme = if (config.stylix.polarity == "light") then "Quintom_Ink" else "Quintom_Snow";
in
{
  imports = [
    ../utils/picom/picom.nix
    ../utils/redshift.nix
    ../../terminal/alacritty.nix
    ../../terminal/kitty.nix
    ./deps.nix
  ];
  home.pointerCursor = {
    x11.enable = true;
    name = cursorTheme;
    size = cursorSize;
    package = pkgs.quintom-cursor-theme;
  };
  gtk.cursorTheme = {
    package = pkgs.quintom-cursor-theme;
    name = cursorTheme;
    size = cursorSize;
  };
  xsession = {
        enable = true;
        numlock.enable = true;
       preferStatusNotifierItems = true;
      };
  programs.rofi.enable = true;
  home.file.".config/qtile/autostart.sh".source = ./startup.sh;
  home.file.".config/qtile/qtile_config".source = ./qtile_config/qtile_config;
  home.file.".config/qtile/colors.py".source = config.lib.stylix.colors {
    template = builtins.readFile ./qtile_config/colors.py.mustache;
    extension = ".py";
  };
  home.file.".config/qtile/config.py".source = ./qtile_config/config.py;
}
