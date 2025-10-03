{
  config,
  pkgs,
  ...
}: {
  security.rtkit.enable = true;
  security.sudo.enable = true;
  security.sudo.wheelNeedsPassword = false;
  security.wrappers.sudo.source = "${pkgs.sudo}/bin/sudo";

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [22 80 443];
    allowedUDPPorts = [53];
    allowedICMP = true;
    logDropped = true;
    trustedInterfaces = ["lo"];

    extraCommands = ''
      # Drop MySQL from outside
      nft add rule inet filter input tcp dport 3306 drop
    '';
  };

  services.fail2ban = {
    enable = true;

    defaultBanTime = 3600; # 1 hour
    defaultFindTime = 600; # 10 minutes
    maxRetry = 5;

    jails = {
      sshd = {
        enabled = true;
        port = "ssh";
      };

      nginx-http-auth = {
        enabled = true;
        port = "http,https";
        filter = "nginx-http-auth";
        logpath = "/var/log/nginx/*error.log";
      };
    };
    email = {
      enabled = true;
      from = "sten181104@gmail.com";
      to = "rishabhhaldiya18@gmail.com";
      smtp = {
        host = "nixos";
        port = 587;
        user = "sten";
        password = "smtp-pass";
        tls = true;
      };
    };
  };
  systemd.services.fail2ban.serviceConfig.StandardOutput = "journal";
  systemd.services.fail2ban.serviceConfig.StandardError = "journal";
}
