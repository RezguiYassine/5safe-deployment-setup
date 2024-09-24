{ pkgs, ... }:

{
  services.picom = {
    enable = true;
    package = pkgs.picom-pijulius;
    vSync = true;
    backend = "glx";
    wintypes = {
      normal = { shadow = false;};
      tooltip = { shadow = true; opacity = 0.75; focus = true; full-shadow = false; };
      dock = { shadow = false; };
      dnd = { shadow = false; };
      popup_menu = { opacity = 1; };
      dropdown_menu = { opacity = 1; };
      }; 
    shadow = false;
    shadowOpacity = 0.75;
    shadowOffsets = [
      (-7)
      (-7)
    ];
  
    shadowExclude = [
      "name = 'Notification'"
      "class_g = 'Conky'"
      "class_g ?= 'Notify-osd'"
      "class_g = 'Cairo-clock'"
      "class_g = 'slop'"
      "class_g = 'Polybar'"
      "_GTK_FRAME_EXTENTS@:c"
    ];

    opacityRules = [
      "90:class_g    = 'xmobar'"
      "90:class_g    = 'firefox'"
      "90:class_g    = 'librewolf'"
      "90:class_g    = 'gtkcord4'"
      "90:class_g    = 'bottles'"
      "90:class_g    = 'PrismLauncher'"
      "90:class_g    = 'Navigator'"
      "90:class_g    = 'Rofi'"
      "90:class_g    = 'Geary'"
      "90:class_g    = 'KeePassXC'"
      "90:class_g    = 'gnome-calendar'"
      "90:class_g    = 'NewsFlashGTK'"
      "90:class_g    = 'Pavucontrol'"
    ];
    fade = false;
    fadeSteps = [
      0.01
      0.01
    ];
    fadeDelta = 1;
    fadeExclude = [];
    settings = {
    shadow-radius = 7;
    no-fading-openclose = false;

    no-fading-destroyed-argb = false;
    inactive-opacity = 1.0;
    popup_menu = { opacity = 1.0; };
    dropdown_menu = { opacity = 1.0; };
    inactive-opacity-override = true;
    active-opacity = 1.0;
    focus-exclude = [
      "class_g = 'Cairo-clock'"
      "class_g = 'Bar'"                    # lemonbar
      "class_g = 'slop'"                    # maim
    ];
    blur-background = false;
    blur-background-exclude = [
      "class_g = 'slop'"
      "_GTK_FRAME_EXTENTS@:c"
    ];
    mark-wmwin-focused = true;
    mark-ovredir-focused = true;
    detect-rounded-corners = true;
    detect-client-opacity = false;
    refresh-rate = 0;
    detect-transient = true;
    detect-client-leader = true;
    glx-no-stencil = true;
    glx-no-rebind-pixmap = true;
    use-damage = false;
    log-level = "info";
    };

  };
  # home.packages = with pkgs; [
  #   picom
  # ];

}
