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
    wine
    bottles
    (lollypop.override { youtubeSupport = false; })
    mate.atril
    kdePackages.phonon-vlc
    pasystray
    # fluffychat
    tigervnc
    vivaldi
    signal-desktop
    libreoffice
    remmina
    obsidian
    qbittorrent
    gparted
    deno
    sshpass
    mangohud # for gaming performance metrics
    vlc
  ];
  services.pasystray.enable = false;
  nixpkgs.config.allowUnfree = true;
  fonts.fontconfig.enable = true;
  # home.file."shared".source = "/mnt/shared";
  # home.file."Audios".source = "/mnt/shared/Audios";

}
