{...}:
{
  imports = [
   ./opengl.nix
   ./bluetooth.nix
   ./power.nix
   ./printing.nix
   ./systemd.nix
   ./time.nix
  ];
  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
}
