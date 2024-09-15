{ pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      dracula-theme.theme-dracula
      vscodevim.vim
      ms-vscode-remote.remote-containers
      ms-azuretools.vscode-docker
      bbenoist.nix
      scalameta.metals
      scala-lang.scala
      # pkgs.vscode-extensions.haskell.haskell
      denoland.vscode-deno
    ];
    haskell = {
      enable = true;
      hie = {
        enable = true;
        executablePath = "${pkgs.haskellPackages.implicit-hie}/bin/gen-hie";
      };
    };
  };
}
