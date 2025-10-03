# power.nix
{
  config,
  pkgs,
  lib,
  ...
}: let
  # Function to auto-detect battery names at activation time
  batteryNames =
    builtins.filter (b: builtins.match "BAT[0-9]+" b != null)
    (builtins.attrNames (builtins.readDir "/sys/class/power_supply" or {}));
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
    # Install TLP package
    environment.systemPackages = [pkgs.tlp];

    # Enable TLP service
    services.tlp.enable = true;

    # Mask rfkill
    systemd.services."systemd-rfkill.service".enable = false;
    systemd.services."systemd-rfkill.socket".enable = false;

    # Generate TLP settings dynamically for all batteries
    services.tlp.settings =
      lib.mkMerge (
        builtins.mapAttrs (
          _: battery: {
            "START_CHARGE_THRESH_${battery}" = toString config.power.chargeStart;
            "STOP_CHARGE_THRESH_${battery}" = toString config.power.chargeStop;
          }
        ) (builtins.listToAttrs (builtins.map (b: {
            name = b;
            value = "";
          })
          batteryNames))
      )
      // {
        CPU_SCALING_GOVERNOR_ON_AC = "schedutil";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      };
  };
}
