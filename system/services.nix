{ lib, pkgs, ... }:

{
  services.tumbler.enable = true; # Thumbnail support for images
  services.openssh.enable = true;
  services.gvfs.enable = true; # Mount, trash, and other functionalities
  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };

  services = {
    xserver = {
      enable = true;
      xkb = {
        layout = "eu, iq, ru, tr";
        variant = "";
        options = "grp:rctrl_rshift_toggle";
      };
    };
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      enableHidpi = true;
      # theme = "chili";
      package = lib.mkForce pkgs.kdePackages.sddm;
    };
  };
}
