{ pkgs }:

{
  baseSystemSettings = rec {
    timeZone = "Europe/Berlin";
    locale = "en_US.UTF-8";
    bootMode = "uefi";
    bootMountPath = "/boot";
    grubDevice = "";
    gpuType = "intel";
    hasNvidia = (gpuType == "nvidia");
  };

  userSettings = rec {
    username = "safe";
    name = "SAFE";
    dotfilesDir = "~/.dotfiles";
    theme = "ayu-dark";
    wm = "xfce";
    wmType = if (wm == "hyprland") then "wayland" else "x11";
    browser = "firefox";
    term = "kitty";
    font = "Dejavu Sans Mono";
    fontPkg = pkgs.dejavu_fonts;
    editor = "nvim";
  };

  serverAddr = "https://10.215.255.65";
  clusterPort = 6443;
  machines = [
    { hostname = "safe-server"; profile = "server"; }
    { hostname = "safe-agent-1"; profile = "agent-1"; }
    { hostname = "safe-agent-2"; profile = "agent-2"; }
    { hostname = "safe-agent-3"; profile = "agent-3"; }
    # Add more agents as needed
  ];
}
