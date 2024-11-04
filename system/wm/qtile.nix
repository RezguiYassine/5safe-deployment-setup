{
  config,
  pkgs,
  lib,
  ...
}:

{
  # nixpkgs.overlays = [
  #   (self: super: {
  #     qtile-unwrapped = super.qtile-unwrapped.overrideAttrs (_: rec {
  #       postInstall =
  #         let
  #           qtileSession = ''
  #             [Desktop Entry]
  #             Name=Qtile Wayland
  #             Comment=Qtile on Wayland
  #             Exec=qtile start -b wayland
  #             Type=Application
  #           '';
  #         in
  #         ''
  #           mkdir -p $out/share/wayland-sessions
  #           echo "${qtileSession}" > $out/share/wayland-sessions/qtile.desktop
  #         '';
  #       passthru.providedSessions = [ "qtile" ];
  #     });
  #   })
  # ];

  # services.displayManager.sessionPackages = with pkgs; [ qtile-unwrapped ];
  services.xserver.windowManager.qtile = {
    enable = true;
    extraPackages =
      python3Packages: with pkgs; [
        python312Packages.qtile
        python312Packages.qtile-extras
        python312Packages.pywlroots
        python312Packages.pywayland
        python312Packages.xkbcommon
      ];
  };
}
