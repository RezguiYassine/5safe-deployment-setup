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
    ../../user/shell/sh.nix
    ../../user/lang/haskell.nix
    ../../user/style/stylix.nix
    ../../user/lang/python/python.nix
    ../../user/wm/utils/redshift.nix
    ../../user/apps
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
    zsh-powerlevel10k
    kitty
    mate.atril
    pasystray
    tigervnc
    gparted
    sshpass
    xorg.xhost
  ];
  services.pasystray.enable = false;
  nixpkgs.config.allowUnfree = true;
  fonts.fontconfig.enable = true;
}
