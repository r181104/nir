{
  config,
  pkgs,
  ...
}: {
  services.xserver.windowManager.xmonad = {
    enable = true;
    enableContribAndExtras = true;
    enableConfiguredRecompile = true;
    haskellPackages = pkgs.haskellPackages;
    extraPackages = haskellPackages: [
      haskellPackages.xmonad-contrib
      haskellPackages.monad-logger
    ];
  };
  boot.initrd.systemd.dbus.enable = true;
}
