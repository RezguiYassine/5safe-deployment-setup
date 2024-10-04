{ userSettings, ... }:

{
  imports = [

    ./xfce.nix
    ./${userSettings.wm}.nix
    ./xmonad.nix
    ./kde.nix
    ./x11.nix
    ./qtile.nix
  ];
}
