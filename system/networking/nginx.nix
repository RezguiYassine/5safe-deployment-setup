{ constants, systemSettings, ... }:
if systemSettings.profile == "server" then {
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

    streamConfig = let
      mqttService = "mosquitto-broker.default.svc.cluster.local";
    in ''
      stream {
        upstream k3s_servers {
          server ${constants.serverAddr}:${toString constants.clusterPort};
        }

        server {
          listen ${toString constants.clusterPort};
          proxy_pass k3s_servers;
        }
      }
    '';
  };

  # ACME/LetsEncrypt configuration
  security.acme = {
    acceptTerms = true;
    defaults.email = "stadtlandshut.5safe@gmail.com";
    # defaults.dnsProvider = "route53";
  };
} else {};
