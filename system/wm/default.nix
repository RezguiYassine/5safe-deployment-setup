{ userSettings, ... }:

{
  imports = [

    ./${userSettings.wm}.nix
    ./x11.nix
    ./wayland.nix
    ./gnome.nix
  ];
}
