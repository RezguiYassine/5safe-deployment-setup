{ pkgs, config, ... }:


{

  services.udiskie = {
    enable = true;
    tray = "always";
  };
  services.swayosd = {
    enable = true;
    topMargin = 0.5;
  };

}
