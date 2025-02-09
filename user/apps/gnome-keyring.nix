{ pkgs, ... }:
{
  home.packages = [ pkgs.seahorse pkgs.gcr ];
  services.gnome-keyring = {
    enable = true;
    components = [ "secrets" "ssh" "pkcs11" ];
  };
}
