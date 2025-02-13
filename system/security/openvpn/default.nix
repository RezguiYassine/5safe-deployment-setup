{ pkgs, systemSettings, ... }:

{
  environment.systemPackages = [ pkgs.openvpn ];
  environment.etc."openvpn/${systemSettings.profile}_frankfurt.ovpn".source = ./${systemSettings.profile}_frankfurt.ovpn;
  services.openvpn.servers."${systemSettings.profile}" = {
    config = '' config /etc/openvpn/${systemSettings.profile}_frankfurt.ovpn '';
    # Enable DNS resolution fix
    updateResolvConf = true;
  };
}
