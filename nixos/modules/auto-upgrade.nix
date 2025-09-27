{
  config,
  pkgs,
  ...
}: {
  system.autoUpgrade = {
    enable = true;
    flake = "github:https://github.com/rishabh181104/nir/tree/master/nixos";
    flags = [
      "--recreate-lock-file"
      "--commit-lock-file"
    ];
    dates = "01:00";
  };
}
