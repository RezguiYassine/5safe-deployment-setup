{ pkgs, ... }:

{
  # OpenGL
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;
  hardware.graphics.extraPackages = with pkgs; [
    rocmPackages.clr.icd
    intel-media-driver
  ];
  environment.sessionVariables = { LIBVA_DRIVER_NAME = "iHD"; };
}
