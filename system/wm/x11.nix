{ pkgs, ... }:

{
  imports = [ ./pipewire.nix
              ./dbus.nix
              ./gnome-keyring.nix
              ./fonts.nix
            ];

  # Configure X11
  services.xserver = {
    enable = true;
    xkb = {
      layout = "eu, iq, ru, tr";
      variant = "";
      options = "grp:rctrl_rshift_toggle";
    };
    excludePackages = [ pkgs.xterm ];
    displayManager = {
      lightdm = {
        enable = true;
      };
      sessionCommands = ''
      xset -dpms
      xset s blank
      xset s 300
      xset r rate 350 100
      ${pkgs.lightlocker}/bin/light-locker --idle-hint &
    '';
    };

  };
  services.libinput = {
      touchpad.disableWhileTyping = true;
    };
}
