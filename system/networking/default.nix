{ config, pkgs, ... }:
{
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
      k3sServers = "k3s-server.default.svc.cluster.local";
    in ''
      upstream mqtt_backend {
        server ${mqttService}:1883 resolve;
      }

      upstream k3s_api {
        server ${k3sServers}:6443 resolve;
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

    virtualHosts = {
      "mqtt-monitoring-service.prod.edge.5-safe.de" = {
        enableACME = false;
        forceSSL = false;
        locations."/" = {
          proxyPass = "http://ingress-nginx-controller.ingress-nginx.svc.cluster.local";
          proxyWebsockets = true;
          extraConfig = ''
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
          '';
        };
      };
    };
  };

  # # ACME/LetsEncrypt configuration
  # security.acme = {
  #   acceptTerms = true;
  #   defaults.email = "admin@prod.edge.5-safe.de";
  #   defaults.dnsProvider = "route53";
  # };

  networking.firewall.allowedTCPPorts = [ 80 443 6443 1883 19095 ];
}
