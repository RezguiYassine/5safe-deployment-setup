{
  config,
  pkgs,
  userSettings,
  ...
}:
{
  home.stateVersion = "24.05";
  home.username = userSettings.username;
  home.homeDirectory = "/home/" + userSettings.username;
  programs.home-manager.enable = true;
  imports = [
    ./user/shell/sh.nix
    ./user/lang/haskell.nix
    ./user/tmux/tmux.nix
    ./user/style/stylix.nix
    ./user/app/helix.nix
    ./user/app/git/git.nix
    ./user/lang/python/python.nix
    ./user/app/vscodium.nix
    ./user/app/ranger/ranger.nix
    ./user/wm/${userSettings.wm}
    ./user/wm/hyprland
  ];
  home.sessionVariables = {
    EDITOR = userSettings.editor;
    TERM = userSettings.term;
    BROWSER = userSettings.browser;
  };

  home.packages = with pkgs; [
    (pkgs.nerdfonts.override {
      fonts = [
        "FiraCode"
        "DroidSansMono"
      ];
    })
    xwayland
    tor-browser-bundle-bin
    emacs
    zsh-powerlevel10k
    syncthing
    kitty
    (pkgs.discord.override {
      withOpenASAR = true;
      # withVencord = true;
    })
    wineWowPackages.stable
    winetricks
    protontricks
    bottles
    (lollypop.override { youtubeSupport = false; })
    mate.atril
    pasystray
    # fluffychat
    vdhcoapp
    tigervnc
    vivaldi
    signal-desktop
    libreoffice
    remmina
    obsidian
    gparted
    deno
    sshpass
    mangohud # for gaming performance metrics
    vlc
    xorg.xhost
    whatsapp-for-linux
    openfortivpn
    frostwire-bin
    telegram-desktop
    okular
  ];
  services.pasystray.enable = false;
  nixpkgs.config.allowUnfree = true;
  fonts.fontconfig.enable = true;
}
