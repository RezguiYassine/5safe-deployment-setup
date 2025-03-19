{...}:
{
  imports = [
   ./system/hardware/opengl.nix
   ./system/hardware/bluetooth.nix
   ./system/hardware/power.nix
   ./system/hardware/printing.nix
   ./system/hardware/systemd.nix
   ./system/hardware/time.nix
  ];
  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
}
