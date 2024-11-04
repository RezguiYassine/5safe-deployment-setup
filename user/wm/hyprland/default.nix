{
  inputs,
  config,
  lib,
  pkgs,
  userSettings,
  systemSettings,
  ...
}:
let
  systemPackages = inputs.hyprland.packages.${pkgs.system};
  pluginsPackages = inputs.hyprland-plugins.packages.${pkgs.system};
  baseColors = config.lib.stylix.colors;

  toColor = color: "0xff${color}";
  toRgba = color: "rgba(${color}55)";
  toRgb = color: "rgb(${color})";

  bezierSettings = [
    "wind, 0.05, 0.9, 0.1, 1.05"
    "winIn, 0.1, 1.1, 0.1, 1.0"
    "winOut, 0.3, -0.3, 0, 1"
    "liner, 1, 1, 1, 1"
    "linear, 0.0, 0.0, 1.0, 1.0"
  ];

  animationSettings = [
    "windowsIn, 1, 6, winIn, popin"
    "windowsOut, 1, 5, winOut, popin"
    "windowsMove, 1, 5, wind, slide"
    "border, 1, 10, default"
    "borderangle, 1, 100, linear, loop"
    "fade, 1, 10, default"
    "workspaces, 1, 5, wind"
    "windows, 1, 6, wind, slide"
    "specialWorkspace, 1, 6, default, slidefadevert -50%"
  ];

  activeBorderColors = lib.concatStringsSep " " (
    map toColor [
      baseColors.base08
      baseColors.base09
      baseColors.base0A
      baseColors.base0B
      baseColors.base0C
      baseColors.base0D
      baseColors.base0E
      baseColors.base0F
    ]
  );

  # Plugin settings
  hyprtrailsConfig = {
    color = toRgba baseColors.base08;
  };

  hyprexpoConfig = {
    columns = 3;
    gap_size = 5;
    bg_col = toRgb baseColors.base00;
    workspace_method = "first 1"; # [center/first] [workspace] e.g. first 1 or center m+1
    enable_gesture = true; # laptop touchpad
  };

  touchGesturesConfig = {
    sensitivity = 4.0;
    long_press_delay = 260;
    hyprgrass-bind = [
      ", edge:r:l, exec, hyprnome"
      ", edge:l:r, exec, hyprnome --previous"
      ", swipe:3:d, exec, nwggrid-wrapper"
      ", swipe:3:u, hyprexpo:expo, toggleoverview"
      ", swipe:3:d, exec, nwggrid-wrapper"
      ", swipe:3:l, exec, hyprnome --previous"
      ", swipe:3:r, exec, hyprnome"
      ", swipe:4:u, movewindow,u"
      ", swipe:4:d, movewindow,d"
      ", swipe:4:l, movewindow,l"
      ", swipe:4:r, movewindow,r"
      ", tap:3, fullscreen,1"
      ", tap:4, fullscreen,0"
      ", longpress:2, movewindow"
      ", longpress:3, resizewindow"
    ];
  };
  cursorSize = 30;
  cursorSizeStr = "30";
  scratchpadsize = "size 80% 85%";
  scratch_term = "class:^(scratch_term)$";
  scratch_ranger = "class:^(scratch_ranger)$";
  scratch_thunar = "class:^(scratch_thunar)$";
  scratch_btm = "class:^(scratch_btm)$";
  savetodisk = "title:^(Save to Disk)$";
  pavucontrol = "class:^(org.pulseaudio.pavucontrol)$";
  miniframe = "title:\*Minibuf.*";
in
{
  imports = [
    ./services.nix
    ./deps.nix
    ./hyprlock.nix
    ./hypridle.nix
    ../utils/gtklock.nix
    ../utils/fnott.nix
    ../utils/fuzzel.nix
    ../utils/nwg-grid.nix
    ../utils/nwg-dock.nix
    ../utils/nwg-drawer.nix
    ../utils/waybar.nix
  ];
  gtk.cursorTheme = {
    package = pkgs.quintom-cursor-theme;
    name = if (config.stylix.polarity == "light") then "Quintom_Ink" else "Quintom_Snow";
    size = cursorSize;
  };
  wayland.windowManager.hyprland = {
    enable = true;
    package = systemPackages.hyprland;
    xwayland.enable = true;
    systemd.enable = true;

    plugins = [
      pluginsPackages.hyprtrails
      pluginsPackages.hyprexpo
      inputs.hyprgrass.packages.${pkgs.system}.default
    ];
    # extraConfig = ''
    #   source=~/.config/hypr/monitors.conf
    # '';

    settings = {
      env = [

        "XDG_CURRENT_DESKTOP,Hyprland"
        "XDG_SESSION_DESKTOP,Hyprland"
        "XDG_SESSION_TYPE,wayland"
        "WLR_DRM_DEVICES,/dev/dri/card2:/dev/dri/card1"
        "GDK_BACKEND,wayland,x11,*"
        "QT_QPA_PLATFORM,wayland;xcb"
        "QT_QPA_PLATFORMTHEME,qt6ct"
        "QT_AUTO_SCREEN_SCALE_FACTOR,1"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
        "CLUTTER_BACKEND,wayland"
        "XCURSOR_SIZE, ${cursorSizeStr}"
      ];
      bezier = bezierSettings;
      animations = {
        enabled = true;
        animation = animationSettings;
      };

      general = {
        layout = "master";
        border_size = 2;
        "col.active_border" = "${activeBorderColors} 270deg";
        "col.inactive_border" = toColor baseColors.base02;
        resize_on_border = true;
        gaps_in = 7;
        gaps_out = 7;
        allow_tearing = false;
      };

      cursor = {
        no_warps = false;
        inactive_timeout = 30;
        # no_hardware_cursors = true;
      };

      plugin = {
        hyprtrails = hyprtrailsConfig;
        hyprexpo = hyprexpoConfig;
        touch_gestures = touchGesturesConfig;
      };
      xwayland = {
        force_zero_scaling = true;
      };
      source = [ "${config.home.homeDirectory}/.config/hypr/monitors.conf" ];
      # monitor = [
      #   "eDP-2,1920x1080@165.003006,0x0,1.0"
      #   # "eDP-2,2560x1440@165.003006,0x0,1.0"
      #   # "HDMI-A-1,3840x2160@120,0x0,1.0,bitdepth, 10"
      #   # "HDMI-A-1,3840x2160@120,0x0,1.0"
      #   # "eDP-1,2048x1152@165,3840x0,1.0"
      #   "eDP-1,2048x1152@165.003006,2160x0,1.0"
      # ];
      exec-once = [
        "dbus-update-activation-environment --systemd DISPLAY XAUTHORITY WAYLAND_DISPLAY XDG_SESSION_DESKTOP=Hyprland XDG_CURRENT_DESKTOP=Hyprland XDG_SESSION_TYPE=wayland"
        "hyprctl setcursor ${config.gtk.cursorTheme.name} ${cursorSizeStr}"
        "hypridle"
        "sleep 5 && libinput-gestures"
        "hyprpaper"
        "nm-applet"
        #"emacs --daemon"
        # "ydotoold"
        "nm-applet"
        "blueman-applet"
        #"GOMAXPROCS=1 syncthing --no-browser"
        "waybar"
      ];

      windowrulev2 = [
        "float,${scratch_term}"
        "${scratchpadsize},${scratch_term}"
        "workspace special:scratch_term ,${scratch_term}"
        "center,${scratch_term}"

        "float,${scratch_ranger}"
        "${scratchpadsize},${scratch_ranger}"
        "workspace special:scratch_ranger silent,${scratch_ranger}"
        "center,${scratch_ranger}"

        "float,${scratch_thunar}"
        "${scratchpadsize},${scratch_thunar}"
        "workspace special:scratch_thunar silent,${scratch_thunar}"
        "center,${scratch_thunar}"

        "float,${scratch_btm}"
        "${scratchpadsize},${scratch_btm}"
        "workspace special:scratch_btm silent,${scratch_btm}"
        "center,${scratch_btm}"

        "float,class:^(Element)$"
        "size 85% 90%,class:^(Element)$"
        "workspace special:scratch_element silent,class:^(Element)$"
        "center,class:^(Element)$"

        "float,class:^(lollypop)$"
        "size 85% 90%,class:^(lollypop)$"
        "workspace special:scratch_music silent,class:^(lollypop)$"
        "center,class:^(lollypop)$"

        "float,${savetodisk}"
        "size 70% 75%,${savetodisk}"
        "center,${savetodisk}"

        "float,${pavucontrol}"
        "size 86% 40%,${pavucontrol}"
        "move 50% 6%,${pavucontrol}"
        "workspace special silent,${pavucontrol}"
        "opacity 0.80,${pavucontrol}"

        "float,${miniframe}"
        "size 64% 50%,${miniframe}"
        "move 18% 25%,${miniframe}"
        "animation popin 1 20,${miniframe}"

        "float,class:^(pokefinder)$"

        "opacity 0.80,title:orui"

        "opacity 1.0,class:^(org.qutebrowser.qutebrowser),fullscreen:1"
        "opacity 0.85,class:^(element)$"
        "opacity 0.85,class:^(lollypop)$"
        "opacity 1.0,class:^(brave-browser),fullscreen:1"
        "opacity 1.0,class:^(librewolf),fullscreen:1"
        "opacity 0.85,title:^(my local dashboard awesome homepage - qutebrowser)$"
        "opacity 0.85,title:\[.*\] - my local dashboard awesome homepage"
        "opacity 0.85,class:^(org.keepassxc.keepassxc)$"
        "opacity 0.85,class:^(org.gnome.nautilus)$"
        "opacity 0.85,class:^(org.gnome.nautilus)$"

        "group, class:kitty"
        "group, title:code"
        "group, class:firefox"
        "group, class:code"

        "float,class:flameshot"
        "monitor 0,class:flameshot"
        "move 0 0,class:flameshot"
        "noanim,class:flameshot"
        "noborder,class:flameshot"
        "rounding 0,class:flameshot"
      ];
      layerrule = [
        "blur,waybar"
        "xray,waybar"
        "blur,launcher" # fuzzel
        "blur,gtk-layer-shell"
        "xray,gtk-layer-shell"
        "blur,~nwggrid"
        "xray 1,~nwggrid"
        "animation fade,~nwggrid"
      ];

      blurls = [
        "waybar"
        "launcher" # fuzzel
        "gtk-layer-shell"
        "~nwggrid"
      ];

      bind = [
        "SUPER, PRINT, exec, hyprshot -m window"
        # Screenshot a monitor
        ", PRINT, exec, hyprshot -m output"
        # Screenshot a region
        "SUPERSHIFT, PRINT, exec, hyprshot -m region"
        "ALT, PRINT, exec, XDG_CURRENT_DESKTOP=sway flameshot"

        "SUPER,I,exec,networkmanager_dmenu"
        "SUPER,T,exec,${userSettings.term}"
        "SUPER,grave,exec,${userSettings.browser}"
        # "SUPER,P,exec,keepmenu"
        "SUPER,P,exec, kitty --class scratch_term -e ipdf ~"
        "SUPER,O,exec, obsidian"
        "SUPERSHIFT,P,exec,hyprprofile-dmenu"
        "SUPER,Z,exec,if hyprctl clients | grep scratch_term; then echo \"scratch_term respawn not needed\"; else alacritty --class scratch_term; fi"
        "SUPER,Z,togglespecialworkspace,scratch_term"
        "SUPER,F,exec,if hyprctl clients | grep scratch_ranger; then echo \"scratch_ranger respawn not needed\"; else kitty --class scratch_ranger -e ranger; fi"
        "SUPER,F,togglespecialworkspace,scratch_ranger"
        "SUPER,V,exec,if hyprctl clients | grep scratch_thunar; then echo \"scratch_thunar respawn not needed\"; else thunar; fi"
        "SUPER,V,togglespecialworkspace,scratch_thunar"
        "SUPER,M,exec,if hyprctl clients | grep lollypop; then echo \"scratch_ranger respawn not needed\"; else lollypop; fi"
        "SUPER,M,togglespecialworkspace,scratch_music"
        "SUPERSHIFT,B,exec,if hyprctl clients | grep scratch_btm; then echo \"scratch_ranger respawn not needed\"; else alacritty --class scratch_btm -e btm; fi"
        "SUPERSHIFT,B,togglespecialworkspace,scratch_btm"
        "SUPER,D,exec,if hyprctl clients | grep Element; then echo \"scratch_ranger respawn not needed\"; else element-desktop; fi"
        "SUPER,D,togglespecialworkspace,scratch_element"
        "SUPER,code:172,exec,togglespecialworkspace,scratch_pavucontrol"
        "SUPER,code:172,exec,if hyprctl clients | grep pavucontrol; then echo \"scratch_ranger respawn not needed\"; else pavucontrol; fi"
        "SUPER,code:47,exec,fuzzel"
        "SUPER,X,exec,fnottctl dismiss"
        "SUPERSHIFT,X,exec,fnottctl dismiss all"
        "SUPER,E,togglefloating"
        "SUPER,G,togglegroup"
        "SUPER,N,changegroupactive,f"
        "SUPER,B,changegroupactive,b"

        "SUPER,equal, exec, hyprctl keyword cursor:zoom_factor \"$(hyprctl getoption cursor:zoom_factor | grep float | awk '{print $2 + 0.5}')\""
        "SUPER,minus, exec, hyprctl keyword cursor:zoom_factor \"$(hyprctl getoption cursor:zoom_factor | grep float | awk '{print $2 - 0.5}')\""

        "SUPER,SPACE,fullscreen,1"
        "SUPERSHIFT,F,fullscreen,0"
        "SUPER,Y,workspaceopt,allfloat"
        "ALT,TAB,cyclenext"
        "ALT,TAB,bringactivetotop"
        "ALTSHIFT,TAB,cyclenext,prev"
        "ALTSHIFT,TAB,bringactivetotop"
        "SUPER,TAB,hyprexpo:expo, toggleoverview"
        "SUPER,V,exec,wl-copy $(wl-paste | tr \\n)"
        # "SUPERSHIFT,T,exec,screenshot-ocr"
        "CTRLALT,Delete,exec,hyprctl kill"
        "SUPERSHIFT,K,exec,hyprctl kill"
        "SUPER,W,exec,nwg-dock-wrapper"
        "SUPER,code:9,exec,nwggrid-wrapper"
        "SUPER,code:66,exec,nwggrid-wrapper"
        ",code:172,exec,lollypop -t"
        ",code:174,exec,lollypop -s"
        ",code:171,exec,lollypop -n"
        ",code:173,exec,lollypop -p"

        "SUPER,Q,killactive"
        "SUPERSHIFT,Q,exit"

        "SUPERSHIFT,S,exec,systemctl suspend"
        ",switch:on:Lid Switch,exec,loginctl lock-session"
        "SUPERCTRL,L,exec,loginctl lock-session"

        ",code:122,exec,swayosd-client --output-volume lower"
        ",code:123,exec,swayosd-client --output-volume raise"
        ",code:121,exec,swayosd-client --output-volume mute-toggle"
        ",code:256,exec,swayosd-client --output-volume mute-toggle"
        "SHIFT,code:122,exec,swayosd-client --output-volume lower"
        "SHIFT,code:123,exec,swayosd-client --output-volume raise"
        ",code:232,exec,swayosd-client --brightness lower"
        ",code:233,exec,swayosd-client --brightness raise"
        ",code:237,exec,brightnessctl --device='asus::kbd_backlight' set 1-"
        ",code:238,exec,brightnessctl --device='asus::kbd_backlight' set +1"
        ",code:255,exec,airplane-mode"

        "SUPER,H,movefocus,l"
        "SUPER,J,movefocus,d"
        "SUPER,K,movefocus,u"
        "SUPER,L,movefocus,r"

        "SUPERSHIFT,H,movewindow,l"
        "SUPERSHIFT,J,movewindow,d"
        "SUPERSHIFT,K,movewindow,u"
        "SUPERSHIFT,L,movewindow,r"

        "SUPER,1,focusworkspaceoncurrentmonitor,1"
        "SUPER,2,focusworkspaceoncurrentmonitor,2"
        "SUPER,3,focusworkspaceoncurrentmonitor,3"
        "SUPER,4,focusworkspaceoncurrentmonitor,4"
        "SUPER,5,focusworkspaceoncurrentmonitor,5"
        "SUPER,6,focusworkspaceoncurrentmonitor,6"
        "SUPER,7,focusworkspaceoncurrentmonitor,7"
        "SUPER,8,focusworkspaceoncurrentmonitor,8"
        "SUPER,9,focusworkspaceoncurrentmonitor,9"

        "SUPERCTRL,right,exec,hyprnome"
        "SUPERCTRL,left,exec,hyprnome --previous"
        "SUPERSHIFT,right,exec,hyprnome --move"
        "SUPERSHIFT,left,exec,hyprnome --previous --move"

        "SUPERSHIFT,1,movetoworkspace,1"
        "SUPERSHIFT,2,movetoworkspace,2"
        "SUPERSHIFT,3,movetoworkspace,3"
        "SUPERSHIFT,4,movetoworkspace,4"
        "SUPERSHIFT,5,movetoworkspace,5"
        "SUPERSHIFT,6,movetoworkspace,6"
        "SUPERSHIFT,7,movetoworkspace,7"
        "SUPERSHIFT,8,movetoworkspace,8"
        "SUPERSHIFT,9,movetoworkspace,9"
      ];
      bindm = [
        "SUPER,mouse:272,movewindow"
        "SUPER,mouse:273,resizewindow"
      ];
      binds = {
        movefocus_cycles_fullscreen = false;
      };

      input = {
        kb_layout = "eu, iq, ru, tr";
        kb_options = "grp:rctrl_rshift_toggle";
        repeat_delay = 350;
        repeat_rate = 50;
        accel_profile = "adaptive";
        follow_mouse = 2;
        float_switch_override_focus = 0;
      };

      misc = {
        disable_hyprland_logo = true;
        mouse_move_enables_dpms = true;
        enable_swallow = true;
        swallow_regex = "(scratch_term)|(Alacritty)|(kitty)";
        font_family = userSettings.font;

      };
      decoration = {
        rounding = 8;
        dim_special = 0.0;
        blur = {
          enabled = true;
          size = 5;
          passes = 2;
          ignore_opacity = true;
          contrast = 1.17;
          brightness = if (config.stylix.polarity == "dark") then "0.8" else "1.25";
          xray = true;
          special = true;
          popups = true;
        };
      };

    };
  };
}
