{ userSettings, ... }:

{
  imports = [

    ./${userSettings.wm}.nix
    ./xfce.nix
    ./hyprland.nix
    ./kde.nix
    ./x11.nix
  ];
}
