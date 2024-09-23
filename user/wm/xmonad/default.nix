{ pkgs, inputs, ... }:
let 
  xmonad-srid = ./xmonad-srid; 
in
{

  xsession.windowManager.xmonad = {
    enable = true;
    enableContribAndExtras = true;
    extraPackages = haskellPackages: [
    haskellPackages.xmonad-contrib
    haskellPackages.containers
  ];
    config =  builtins.readFile "${xmonad-srid}/Main.hs";
  };
}
