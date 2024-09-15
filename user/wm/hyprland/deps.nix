{
  pkgs,
  inputs,
  config,
  userSettings,
  pkgs-nwg-dock-hyprland,
  ...
}:
let
  pkgs-hyprland = inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  home.packages =
    with pkgs;
    [
      alacritty
      kitty
      feh
      killall
      polkit_gnome
      nwg-launchers
      papirus-icon-theme
      libva-utils
      libinput-gestures
      gsettings-desktop-schemas
      gnome.zenity
      wlr-randr
      wtype
      ydotool
      wl-clipboard
      hyprland-protocols
      hyprpicker
      inputs.hyprlock.packages.${pkgs.system}.default
      hypridle
      hyprpaper
      fnott
      keepmenu
      pinentry-gnome3
      wev
      hyprshot
      python311Packages.pyqt6
      libsForQt5.qt5.qtwayland
      qt6.qtwayland
      xdg-utils
      xdg-desktop-portal
      xdg-desktop-portal-gtk
      xdg-desktop-portal-hyprland
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
      (pkgs.writeScriptBin "nwg-dock-wrapper" ''
        #!/bin/sh
        if pgrep -x ".nwg-dock-hyprl" > /dev/null
        then
          nwg-dock-hyprland
        else
          nwg-dock-hyprland -f -x -i 64 -nolauncher -a start -ml 8 -mr 8 -mb 8
        fi
      '')
    ]
    ++ (with pkgs-hyprland; [ ])
    ++ (with pkgs-nwg-dock-hyprland; [
      (nwg-dock-hyprland.overrideAttrs (oldAttrs: {
        patches = ../utils/patches/noactiveclients.patch;
      }))
    ]);
  home.file.".local/share/pixmaps/hyprland-logo-stylix.svg".source = config.lib.stylix.colors {
    template = builtins.readFile ../../pkgs/hyprland-logo-stylix.svg.mustache;
    extension = "svg";
  };
}
