# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  lib,
  inputs,
  systemSettings,
  userSettings,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../system/disko-config
   ../../system/hardware/opengl.nix
   ../../system/hardware/bluetooth.nix
   ../../system/hardware/power.nix
   ../../system/hardware/printing.nix
   ../../system/hardware/systemd.nix
   ../../system/hardware/time.nix
   ../../system/security
   ../../system/networking
   ../../system/services.nix
    (import ../../system/app/docker.nix {
      storageDriver = null;
      inherit pkgs userSettings systemSettings lib;
    })
    (import ../../system/security/sshd.nix {
      authorizedKeys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDtiPSDIWGb5bYd1+XvmVWV+yLNy7uLJ4azvTXrFmFBug04QOPzkjxTaMsaRW7le2Z952ArsCC7dhgWgTUIy6GORjqoCKjhh6o8vcDcnMtSNzJtAc4quPriPdsydulGW+NUlM8vBU/lp/ZGkEzhFcEXr+zoTYaNYv3O+WgViTNpuTmdKwuRIuRbKY/i4gJ6cAVVEc/6BfkLFIIQQw6OP4fldLBr791o2YySWxWR3kbSMdqS+PNMyrs5lL2STaQFxOyU7HphCQjEktyKHXufc7LgTuVCdymujIxmWmxm+rXbY7SkctAylDXxhlTJ1OShD6hkercSyZueUphkcuHFygu5s/oYyiWijTOBNP0SYdQF1rRZORR49VC54tvR6stH4okGz8z3mEjMA67o569ONM5jlYTO5BdpbPIVc7JiwbLWE7yce8oBRoFxovCykhpuI8DPgQ0Ip1G4QQZ24oJOlBcy76mWhFbnA7CAHLdMDSi1ev1aB4xPrGqYne4iV3YW/EIeVWRyQrx7I7K9zF6TW1mxMjbCmjfKdZd2EYKjsENlQ2GsZwTHC503FUcoJs6yWwzxdYYMcdtGte0LJpK/vVThqxgGSvWMaqcvC5ImIQj4+qAO29Lp4l+i66nQ3XZT5jqMFbv/ygEy4ZfXAApHCVraRWKxolwge6c5Bs1YGlZjFQ=="
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMaoakMcpx9sFDCIJfYjxJdRPc6QVGx/u0SCZp3oJg9M"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGbNQ4popx8kpWTXEf5q5LeynBByGXo46HyfHdLuiIG2"
        ];
      inherit userSettings;
     })
    ../../system/app/virtualization.nix
    ../../system/style/stylix.nix
    ../../system/wm
    ../../k3s/server.nix
    ../../k3s/services
  ] ++ (if (systemSettings.hasNvidia) then [ ../../system/hardware/nvidia.nix ] else []);

  networking.hostName = systemSettings.hostName; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = systemSettings.timeZone;

  # Select internationalisation properties.
  i18n.defaultLocale = systemSettings.locale;

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
  environment.shells = with pkgs; [ zsh ];
  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.safe = {
    isNormalUser = true;
    description = "safe";
    shell = pkgs.zsh;
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "input"
      "vboxusers"
      "plugdev"
      "tty"
    ];
    packages = with pkgs; [
      kdePackages.kate
    ];
  };

  programs.firefox.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    thin-provisioning-tools
    linux-firmware
    vim
    git
    neovim
    curl
    wget
    zsh
    fzf
    htop
    bat
    lshw
    wpa_supplicant
    wayland-scanner
    kdePackages.qtbase
    timeshift
    pkgs.kubernetes-helm
  ];

  environment.sessionVariables = {
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";
  };
  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal
      pkgs.xdg-desktop-portal-gtk
    ];
  };
  services.blueman.enable = true;
  # I'm sorry Stallman-taichou
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];


  programs.xfconf.enable = true;
  programs.thunar.enable = true;
  programs.nm-applet.enable = true;
  programs.thunar.plugins = with pkgs.xfce; [
    thunar-archive-plugin
    thunar-volman
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
