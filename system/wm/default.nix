{userSettings, ...}:

{
    imports = [
    
    ./xfce.nix 
    ./${userSettings.wm}".nix"
    ./xmonad.nix
  
  ];
}