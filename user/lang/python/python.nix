{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Python setup
    python3Full
    python311Packages.python-lsp-server
  ];
}
