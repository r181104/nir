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
  services.displayManager.defaultSession = "none+Qtile";
  programs.i3lock.enable = true;
  security.pam.services.i3lock = {};
  environment.systemPackages = with pkgs; [
    # === Compositing, notifications, and status bar ===
    feh
    picom
    dunst
    libnotify
    pywal
    bemenu
    # === Icons & themes ===
    papirus-icon-theme
    # === Input & gestures ===
    libinput-gestures
    xdotool
    # === GUI tools ===
    lxappearance
    # === Python Packages for QTILE ===
    python3Packages.psutil
    python3Packages.pywal
    python3Packages.pillow
    python3Packages.dbus-python
    python3Packages.xcffib
    python3Packages.cairocffi
    python3Packages.requests
    python3Packages.i3ipc
    mypy
  ];
}
