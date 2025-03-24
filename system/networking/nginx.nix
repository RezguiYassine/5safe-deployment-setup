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
        server localhost:31883;
      }
      upstream kafka {
        server localhost:31095;
      }
      upstream kafka_internal {
        server localhost:9095;
      }
      upstream kafka_ui {
        server localhost:8080
      }
      server {
        listen 1883;
        proxy_pass mosquitto;
      }
      server {
        listen 19095;
        proxy_pass kafka;
      }
      server {
        listen 9095;
        proxy_pass kafka_internal;
      }
      server {
        listen 8080;
        proxy_pass kafka_ui;
      }
    '';

  };

  users.users.nginx.extraGroups = [ "acme" ];

  security.acme = lib.mkIf (systemSettings.profile == "server") {
    acceptTerms = true;
    defaults.email = "stadtlandshut.5safe@gmail.com";
  };
}
