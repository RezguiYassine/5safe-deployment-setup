{inputs, ... }:

{
  # import X11 config
  imports = [ ./x11.nix
              ./pipewire.nix
              ./dbus.nix
            ];

  # Setup XMonad
  services.xserver = {
    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      ghcArgs = [
        "-hidir /tmp" # place interface files in /tmp, otherwise ghc tries to write them to the nix store
        "-odir /tmp" # place object files in /tmp, otherwise ghc tries to write them to the nix store
        "-i${inputs.xmonad-contexts}" # tell ghc to search in the respective nix store path for the module
      ];
    };
  };
}
