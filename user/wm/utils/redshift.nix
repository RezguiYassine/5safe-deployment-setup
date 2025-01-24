{lib, ...}:

{
  services.redshift = {
    enable = true;
    latitude = 48.31;
    longitude = 12.94;
    provider = "manual";
    settings = {
      redshift = {
        fade = 1;
        temp-day = lib.mkForce 3200;
        temp-night = lib.mkForce 2800;
      };
    };
  };
}
