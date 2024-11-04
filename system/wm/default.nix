{ userSettings, ... }:

{
  imports = [

    ./${userSettings.wm}.nix
    ./xfce.nix
    ./hyprland.nix
    # ./xmonad.nix
    ./kde.nix
    ./x11.nix
    # ./qtile.nix
  ];
}
