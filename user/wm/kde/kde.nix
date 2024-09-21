{pkgs, ...}:

{
  services.desktopManager.plasma6.enable = true;
  services.power-profiles-daemon.enable = false;
  # services.displayManager.defaultSession = "plasma";
  environment.plasma5.excludePackages = with pkgs.libsForQt5; [
  plasma-browser-integration
  konsole
  oxygen
];
}