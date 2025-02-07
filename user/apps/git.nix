{
  config,
  pkgs,
  userSettings,
  ...
}:

{
  home.packages = with pkgs; [
    git
    lazygit
  ];
  programs.git = {
    enable = true;
    lfs.enable = true;
    aliases = {
      ci = "commit";
      co = "checkout";
      s = "status";
    };
    userName = "Qubut";
    userEmail = "s-aahmed@haw-landshut.de";
    extraConfig = {
      init.defaultBranch = "main";
      safe.directory = [
        ("/home/" + userSettings.username + "/.dotfiles")
        ("/home/" + userSettings.username + "/.dotfiles/.git")
      ];
    };
  };
}
