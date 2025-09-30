{
  config,
  pkgs,
  ...
}: {
  security.rtkit.enable = true;
  security.sudo.enable = true;
  security.sudo.wheelNeedsPassword = false;
  security.wrappers.sudo.source = "${pkgs.sudo}/bin/sudo";
}
