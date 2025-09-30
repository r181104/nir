{
  config,
  pkgs,
  ...
}: {
  services.xserver.windowManager.xmonad.enable = true;
  services.xserver.windowManager.xmonad.enableContrib = true;
  services.xserver.windowManager.xmonad.extraPackages = with pkgs; [
    xmobar
    xterm
    dmenu
  ];
}
