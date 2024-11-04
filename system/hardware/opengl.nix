{ pkgs, ... }:

{
  # OpenGL
  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.extraPackages = with pkgs; [
    rocmPackages.clr.icd
    intel-media-driver
  ];
  environment.sessionVariables = { LIBVA_DRIVER_NAME = "iHD"; };
}
