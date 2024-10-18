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
        temp-day = lib.mkForce 5000;
        temp-night = lib.mkForce 4000;
      };
    };
  };
}
