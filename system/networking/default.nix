{ config, pkgs, ... }:
{
  services.logrotate.checkConfig = false;
  services.nginx = {
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

    # TCP/UDP stream configuration using DNS discovery
    streamConfig = let
      mqttService = "mosquitto-broker.default.svc.cluster.local";
    in ''
      upstream mqtt_backend {
        server localhost:1883 resolve;
      }

      upstream k3s_api {
        server localhost:6443 resolve;
      }

      server {
        listen 1883;
        proxy_pass mqtt_backend;
        proxy_timeout 1s;
      }

      server {
        listen 6443;
        proxy_pass k3s_api;
      }
    '';
  };

  # ACME/LetsEncrypt configuration
  security.acme = {
    acceptTerms = true;
    defaults.email = "stadtlandshut.5safe@gmail.com";
    # defaults.dnsProvider = "route53";
  };

  networking.firewall.allowedTCPPorts = [ 80 443 6443 1883 19095 ];
}
