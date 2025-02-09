{ pkgs, ... }:
{
  services.gnome-keyring = {
    enable = true;
    components = [ "secrets" "ssh" "pkcs11" ];
  };
}
