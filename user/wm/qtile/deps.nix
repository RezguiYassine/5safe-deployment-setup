{
  pkgs,
  inputs,
  config,
  userSettings,
  ...
}:
let
in
{
  home.packages =
    with pkgs;
    [
      xclip
      redshift
      redshift-plasma-applet
      pkgs.gnome-calendar
      pkgs.gnome-system-monitor
      alacritty
      kitty
      feh
      killall
      polkit_gnome
      nwg-launchers
      libva-utils
      libinput-gestures
      gsettings-desktop-schemas
      pkgs.zenity
      wlr-randr
      wtype
      ydotool
      wl-clipboard
      pinentry-gnome3
      wev
      hyprshot
      python311Packages.pyqt6
      kdePackages.qtwayland
      qt6.qtwayland
      xdg-utils
      xdg-desktop-portal
      xdg-desktop-portal-gtk
      wayland-protocols
      wayland-utils
      wlroots
      wlsunset
      pavucontrol
      pamixer
      tesseract4
      (pkgs.writeScriptBin "nwggrid-wrapper" ''
        #!/bin/sh
        if pgrep -x "nwggrid-server" > /dev/null
        then
          nwggrid -client
        else
          GDK_PIXBUF_MODULE_FILE=${pkgs.librsvg}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache nwggrid-server -layer-shell-exclusive-zone -1 -g adw-gtk3 -o 0.55 -b ${config.lib.stylix.colors.base00}
        fi
      '')
      (pkgs.makeDesktopItem {
        name = "nwggrid";
        desktopName = "Application Launcher";
        exec = "nwggrid-wrapper";
        terminal = false;
        type = "Application";
        noDisplay = true;
        icon = "/home/" + userSettings.username + "/.local/share/pixmaps/hyprland-logo-stylix.svg";
      })
    ];

}
