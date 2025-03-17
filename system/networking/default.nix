{ config, pkgs, systemSettings, ... }:
{
  networking.hostName = systemSettings.hostName; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  services.logrotate.checkConfig = false;
  networking.firewall.allowedTCPPorts = [ 80 443 6443 1883 19095 ];
}
