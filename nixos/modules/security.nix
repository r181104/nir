{
  config,
  pkgs,
  lib,
  ...
}: let
  crowdsecService = {
    description = "CrowdSec agent";
    after = ["network.target"];
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.crowdsec}/bin/crowdsec -c /etc/crowdsec/config.yaml";
      Restart = "on-failure";
    };
  };
in {
  options.security = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable modular firewall + CrowdSec security";
    };
  };

  config = lib.mkIf config.security.enable {
    networking.firewall.enable = true;
    networking.firewall.allowedTCPPorts = [22 80 443];
    networking.firewall.allowedUDPPorts = [53];
    networking.firewall.trustedInterfaces = ["lo"];
    networking.firewall.extraCommands = ''
      nft add rule inet filter input icmp type echo-request accept
    '';

    environment.systemPackages = [pkgs.crowdsec pkgs.crowdsec-firewall pkgs.heirloom-mailx];

    systemd.services.crowdsec = crowdsecService;
  };
}
