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
    userSettings = {
      "svelte-enable-ts-plugin" = true;
      "languageServerHaskell.enableHIE" = true;
      "languageServerHaskell.hieExecutablePath" = "${pkgs.haskellPackages.implicit-hie}/bin/gen-hie";
      "files.autoSave" = "afterDelay";
      "files.autoSaveDelay" = 1000;
      # Whitespace
      "files.trimTrailingWhitespace" = true;
      "files.trimFinalNewlines" = true;
      "files.insertFinalNewline" = true;
      "diffEditor.ignoreTrimWhitespace" = false;
    };
  };
}
