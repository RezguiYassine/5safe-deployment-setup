{ ... }:

{
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 22000 21027 ]; # syncthing
  networking.firewall.allowedUDPPorts = [ 22000 21027 ]; # syncthing
}
