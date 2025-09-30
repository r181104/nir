{
  config,
  pkgs,
  ...
}: {
  services.xserver = {
    enable = true;
    autoRepeatDelay = 200;
    autoRepeatInterval = 50;
  };
  services.xserver.windowManager.xmonad = {
    enable = true;
    config = builtins.readFile ./../../.config/xmonad/xmonad.hs;
    enableContribAndExtras = true;
    enableConfiguredRecompile = true;
    haskellPackages = pkgs.haskellPackages;
  };
  boot.initrd.systemd.dbus.enable = true;
  services.displayManager.defaultSession = "none+xmonad";
  environment.systemPackages = with pkgs; [
    # === Compositing, notifications, and status bar ===
    feh
    picom
    dunst
    pywal
    xmobar
    bemenu
    betterlockscreen
    # === Icons & themes ===
    papirus-icon-theme
    # === Input & gestures ===
    libinput-gestures
    xdotool
    # === GUI tools ===
    lxappearance
  ];
}
