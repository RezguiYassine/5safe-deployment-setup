{
  pkgs,
  inputs,
  config,
  ...
}:
let
  xmonad-srid = ./xmonad-srid;
in
{
  imports = [
    ../utils/picom/picom.nix
    ../../lang/haskell.nix
    ../../terminal/alacritty.nix
    ../../terminal/kitty.nix
    # ( import ../../app/dmenu-scripts/networkmanager-dmenu.nix {dmenu_command = "rofi -show dmenu"; inherit pkgs;})
  ];
  systemd.user.tmpfiles.rules = [
    "d ${config.home.homeDirectory}/.cache/xmonad"
    "d ${config.home.homeDirectory}/.config/xmonad"
    "d ${config.home.homeDirectory}/.local/share/xmonad"
  ];
  # programs.feh.enable = true;
  programs.rofi.enable = true;
  home.file.".config/xmonad/lib/Colors/Stylix.hs".source = config.lib.stylix.colors {
    template = builtins.readFile "${xmonad-srid}/lib/Colors/Stylix.hs.mustache";
    extension = ".hs";
  };
  home.file.".config/xmonad/startup.sh".source = ./startup.sh;
  home.file.".config/xmonad/xmonad.hs".source = "${xmonad-srid}/Main.hs";
  # xsession.windowManager.xmonad = {
  #   enable = true;
  #   enableContribAndExtras = true;
  #   extraPackages = haskellPackages: [
  #     haskellPackages.xmonad-contrib
  #     haskellPackages.containers
  #   ];
  #   config = "${xmonad-srid}/Main.hs";
  # };
}
