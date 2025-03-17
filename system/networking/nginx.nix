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

  systemd.services.nginx.serviceConfig.ReadWritePaths = [ "/var/log/nginx" "/var/cache/nginx" ];

  security.acme = lib.mkIf (systemSettings.profile == "server") {
    acceptTerms = true;
    defaults.email = "stadtlandshut.5safe@gmail.com";
  };
}
