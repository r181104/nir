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
  services.displayManager.ly.enable = true;
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
  services.xserver.windowManager.qtile = {
    enable = true;
    package = pkgs.python3.pkgs.qtile;
    configFile = ./../../.config/qtile/config.py;
    extraPackages = python3Packages:
      with python3Packages; [
        qtile-extras
      ];
  };
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
