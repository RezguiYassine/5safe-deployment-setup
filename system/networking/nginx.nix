{ systemSettings, lib, constants, ... }:
{
  services.nginx = lib.mkIf (systemSettings.profile == "server") {
    enable = true;
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;

    commonHttpConfig = ''
      add_header Strict-Transport-Security "max-age=31536000; includeSubdomains" always;
      add_header X-Frame-Options DENY;
      add_header X-Content-Type-Options nosniff;
      add_header Referrer-Policy "strict-origin";
    '';

    streamConfig = ''
      upstream mosquitto {
        server localhost:31884;
      }
      upstream kafka {
        server localhost:31095;
      }
      server {
        listen 1883;
        proxy_pass mosquitto;
      }
      server {
      listen 19095;
      proxy_pass kafka;
      }
    '';

  };

  users.users.nginx.extraGroups = [ "acme" ];

  security.acme = lib.mkIf (systemSettings.profile == "server") {
    acceptTerms = true;
    defaults.email = "stadtlandshut.5safe@gmail.com";
  };
}
