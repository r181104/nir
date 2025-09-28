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
  services.xserver.windowManager.bspwm.enable = true;
  services.xserver.windowManager.dwm = {
    enable = true;
    package = pkgs.dwm.overrideAttrs {
      src = ./../../dwm;
    };
  };
  services.displayManager.defaultSession = "none+bspwm";
  environment.systemPackages = with pkgs; [
    # === Window manager & hotkey daemon ===
    bspwm
    sxhkd

    # === Compositing, notifications, and status bar ===
    feh
    picom
    dunst
    polybar
    pywal
    bemenu
    betterlockscreen

    # === Icons & themes ===
    papirus-icon-theme

    # === Input & gestures ===
    libinput-gestures

    # === Xorg server & utilities ===
    xorg.xorgserver
    xorg.xinit
    xorg.xrandr
    xorg.xsetroot
    xorg.xprop
    xorg.xev
    xorg.xdpyinfo

    # === GUI tools ===
    lxappearance
  ];
}
