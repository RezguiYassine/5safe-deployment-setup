{ pkgs, ... }:
let
  aliases = builtins.readFile ./zsh-aliases;
  functions = builtins.readFile ./zsh-functions;
  xdgStateHome = builtins.getEnv "XDG_STATE_HOME";
  p10k = builtins.readFile ./p10k.zsh;
in
{
  programs.zsh = {
    enable = true;
    prezto = {
      enable = true;
      pmodules = [
        "editor"
        "history"
        "completion"
        "prompt"
        "syntax-highlighting"
        "autosuggestions"
        "directory"
        "utility"
        "git"
        "history-substring-search"
        "tmux"
        "ssh"
        "spectrum"
      ];
      prompt.theme = "powerlevel10k";
      tmux.autoStartLocal = true;
      tmux.defaultSessionName = "autostart";
      extraConfig = ''
        zstyle ':prezto:module:history-substring-search' unique 'yes'
      '';
    };

    initExtra = ''
      ${aliases}
      ${functions}
      ${p10k}
    '';
  };
  programs.bash = {
    enable = true;
    enableCompletion = true;
    initExtra = ''
      ${aliases}
      ${functions}
    '';
  };

  home.packages = with pkgs; [
    disfetch
    lolcat
    cowsay
    onefetch
    gnugrep
    gnused
    bat
    eza
    bottom
    fd
    bc
    direnv
    nix-direnv
  ];

  programs.direnv.enable = true;
  programs.direnv.enableZshIntegration = true;
  programs.direnv.nix-direnv.enable = true;
}
