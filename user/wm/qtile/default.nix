{...}:

{
  imports = [
    ../utils/picom/picom.nix
    ../../terminal/alacritty.nix
    ../../terminal/kitty.nix
    ];
  programs.rofi.enable = true;
  home.file.".config/xmonad/startup.sh".source = ./startup.sh;
  xdg.configFile."qtile" = {
  source = ./qtile_config/qtile_config;
  recursive = true;
};

}
