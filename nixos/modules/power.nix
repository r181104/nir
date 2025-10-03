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
    (builtins.attrNames (
      (builtins.tryEval (builtins.readDir "/sys/class/power_supply")).value or {}
    ));

  # Generate TLP settings for batteries
  batterySettings =
    builtins.listToAttrs (map (b: {
        name = "START_CHARGE_THRESH_${b}";
        value = toString config.power.chargeStart;
      })
      batteryNames)
    // builtins.listToAttrs (map (b: {
        name = "STOP_CHARGE_THRESH_${b}";
        value = toString config.power.chargeStop;
      })
      batteryNames);

  # ANSI color codes (Nord palette)
  nordBlue = "\033[38;5;38m";
  nordRed = "\033[38;5;203m";
  nordGreen = "\033[38;5;64m";
  nordYellow = "\033[38;5;220m";
  nordReset = "\033[0m";
in {
  options.power = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable TLP-based power management";
    };
    chargeStart = lib.mkOption {
      type = lib.types.int;
      default = 80;
      description = "TLP start charge threshold for all batteries";
    };
    chargeStop = lib.mkOption {
      type = lib.types.int;
      default = 95;
      description = "TLP stop charge threshold for all batteries";
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
        CPU_SCALING_GOVERNOR_ON_AC = "schedutil";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      };

    # Boot-time colored TLP summary
    systemd.services.tlp-summary = {
      description = "Print colorful TLP status summary on boot";
      after = ["multi-user.target"];
      wantedBy = ["multi-user.target"];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = ''
          ${pkgs.coreutils}/bin/echo -e "${nordBlue}>>> TLP Status Summary${nordReset}"
          ${pkgs.coreutils}/bin/echo -e "${nordYellow}--------------------------------${nordReset}"
          ${pkgs.tlp}/bin/tlp-stat -s | ${pkgs.coreutils}/bin/sed "s/^/${nordGreen}/;s/$/${nordReset}/"
          ${pkgs.tlp}/bin/tlp-stat -b | ${pkgs.coreutils}/bin/sed "s/^/${nordRed}/;s/$/${nordReset}/"
          ${pkgs.tlp}/bin/tlp-stat -p | ${pkgs.coreutils}/bin/sed "s/^/${nordBlue}/;s/$/${nordReset}/"
          ${pkgs.coreutils}/bin/echo -e "${nordYellow}--------------------------------${nordReset}"
        '';
      };
    };
  };
}
