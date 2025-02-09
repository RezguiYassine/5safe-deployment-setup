{ pkgs ? import <nixpkgs> {} }:

let
  python = pkgs.python312;
  poetry = pkgs.poetry;
  ipykernel = pkgs.python312Packages.ipykernel;
  xkbcommon = pkgs.libxkbcommon;
in

pkgs.mkShell {
  buildInputs = [
    python
    poetry
    ipykernel
    xkbcommon
    pkgs.iw
    pkgs.python312Packages.iwlib
    pkgs.python312Packages.black
    pkgs.python312Packages.mypy
    pkgs.python312Packages.qtile
  ];

  shellHook = ''
    echo "Poetry installed at $POETRY_HOME"
    echo "Python $(python --version) is available."
    poetry install
  '';
}
