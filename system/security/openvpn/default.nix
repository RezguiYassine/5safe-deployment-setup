{ pkgs, systemSettings, ... }:

{
  environment.systemPackages = [ pkgs.openvpn ];
  environment.etc.openvpn.source = "${pkgs.update-resolv-conf}/libexec/openvpn";
  services.openvpn.servers."${systemSettings.profile}".config = "./${systemSettings.profile}_frankfurt.ovpn";
}
