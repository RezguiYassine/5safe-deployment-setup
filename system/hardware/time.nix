{ systemSettings, ... }:

{
  time.timeZone = systemSettings.timeZone;
  services.timesyncd.enable = true;
}
