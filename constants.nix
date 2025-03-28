{ pkgs }:
let constants = rec {
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

  serverAddr = "100.96.1.98";
  clusterPort = 6443;
  machines = [
    { hostname = "safe-server"; profile = "server"; }
    { hostname = "safe-agent_1"; profile = "agent-1"; }
    # Add more agents as needed
  ];
  kafkaSettings = rec {
    clusterDomain = "cluster.local";
    image = {
      tag = "3.5.1-debian-11-r14";
    };
    listeners = {
      client = {
        containerPort = 9092;
      };
      controller = {
        containerPort = 9093;
      };
      interbroker = {
        containerPort = 9094;
      };
      external = {
        containerPort = 9095;
      };
    };
    controller = {
      replicaCount = 3;
      persistence = {
        storageClass = "local-path";
        size = "8Gi";
      };
    };
    broker = {
      replicaCount = 0;
      persistence = {
        storageClass = "local-path";
        size = "8Gi";
      };
    };
    service = {
      ports = {
        client = 19092;
        controller = 19093;
        interbroker = 19094;
        external = 19095;
      };
      nodePorts = {
        external = 31095;
      };
    };
    externalAccess = {
      controller = {
        service = {
          domain = serverAddr;
          nodePort = 31093;
        };
      };
      broker = {
        service = {
          domain = serverAddr;
          nodePort = 31094;
        };
      };
    };
  };
};
in constants
