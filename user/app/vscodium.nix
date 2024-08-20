{pkgs, ...}:

{
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      dracula-theme.theme-dracula
      vscodevim.vim
      ms-vscode-remote.remote-containers
      ms-azuretools.vscode-docker
    ];
    #haskell = {
     # enable = true;
      #hie = {
       # enable = true;
        #executablePath = "${pkgs.hie-nix}/bin/hie";
      #};
      #};
    };
}