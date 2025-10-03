# nixos/modules/power.nix
{
  config,
  pkgs,
  lib,
  ...
}: let
  # Auto-detect batteries (BAT0, BAT1, etc.)
  batteryNames =
    builtins.filter (b: builtins.match "BAT[0-9]+" b != null)
    (builtins.attrNames ((builtins.tryEval (builtins.readDir "/sys/class/power_supply")).value or {}));

  batterySettings =
    builtins.listToAttrs (map (b: {
        name = "START_CHARGE_THRESH_${b}";
        value = "80"; # default start charge
      })
      batteryNames)
    // builtins.listToAttrs (map (b: {
        name = "STOP_CHARGE_THRESH_${b}";
        value = "95"; # default stop charge
      })
      batteryNames);
in {
  options.power = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable TLP-based power management for laptop";
    };
  };

  config = lib.mkIf config.power.enable {
    environment.systemPackages = [pkgs.tlp];

    services.tlp.enable = true;

    systemd.services."systemd-rfkill.service".enable = false;
    systemd.services."systemd-rfkill.socket".enable = false;

    services.tlp.settings =
      batterySettings
      // {
        CPU_SCALING_GOVERNOR_ON_AC = "schedutil"; # balanced
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave"; # battery
      };

    # Boot-time TLP summary
    systemd.services.tlp-summary = {
      description = "Print TLP status summary on boot";
      after = ["multi-user.target"];
      wantedBy = ["multi-user.target"];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = ''
          ${pkgs.coreutils}/bin/echo -e ">>> TLP Status Summary"
          ${pkgs.coreutils}/bin/echo -e "--------------------------------"
          ${pkgs.tlp}/bin/tlp-stat -s
          ${pkgs.tlp}/bin/tlp-stat -b
          ${pkgs.tlp}/bin/tlp-stat -p
          ${pkgs.coreutils}/bin/echo -e "--------------------------------"
        '';
      };
    };
  };
}
