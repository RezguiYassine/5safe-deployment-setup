{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ./pipewire.nix
    ./dbus.nix
    ./gnome-keyring.nix
    ./fonts.nix
  ];

  environment.sessionVariables.NIXOS_OZONE_WL = "1"; # to run vscode under Wayland
  environment.systemPackages = with pkgs; [
    wayland
 ];

  # Configure xwayland
}
