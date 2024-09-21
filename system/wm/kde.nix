{pkgs, ...}:
let excludedPkgs =  with pkgs.libsForQt5; [
  plasma-browser-integration
  konsole
  oxygen
];
in
{
  services.desktopManager.plasma6.enable = true;
  # services.displayManager.defaultSession = "plasma";
  environment.plasma5.excludePackages = excludedPkgs
}