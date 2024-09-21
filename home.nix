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
    # ./user/lang/ts.nix
    ./user/tmux/tmux.nix
    ./user/style/stylix.nix
    ./user/terminal/kitty.nix
    ./user/terminal/alacritty.nix
    ./user/app/helix.nix
    ./user/app/git/git.nix
    ./user/lang/python/python.nix
    ./user/app/vscodium.nix
    ./user/app/ranger/ranger.nix
    ./user/wm/${userSettings.wm}/${userSettings.wm}.nix
    ./user/wm/kde/kde.nix
  ];
  xdg.enable = true;
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
    vlc
    mate.atril
    pasystray
    # fluffychat
    tigervnc
    vivaldi

    remmina
    obsidian
    vdhcoapp
    jetbrains.pycharm-professional
    jetbrains.webstorm
    qbittorrent
    gparted
    deno
    nodePackages.pnpm
    bun

  ];
  services.pasystray.enable = false;
  gtk.iconTheme = {
    package = pkgs.papirus-icon-theme;
    name = if (config.stylix.polarity == "dark") then "Papirus-Dark" else "Papirus-Light";
  };
  nixpkgs.config.allowUnfree = true;
  fonts.fontconfig.enable = true;
  # home.file."shared".source = "/mnt/shared";
  # home.file."Audios".source = "/mnt/shared/Audios";

}
