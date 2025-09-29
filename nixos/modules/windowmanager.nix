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
    xdotool

    # === Xorg server & utilities ===
    xorg.xorgserver
    xorg.xorgproto
    xorg.xauth
    xorg.xinit
    xorg.xrandr
    xorg.xev
    xorg.xset
    xorg.xsetroot
    xorg.xkbcomp
    xorg.xmessage
    xorg.xprop
    xorg.xwininfo
    xorg.xdpyinfo
    xorg.xhost
    xorg.xmodmap
    xorg.xcursorgen
    xorg.xf86videointel
    xorg.xf86videonouveau
    xorg.xf86videoamdgpu
    xorg.xf86videoati
    xorg.xf86videovesa
    xorg.xf86inputlibinput
    xorg.libX11.dev
    xorg.libXext.dev
    xorg.libXrender.dev
    xorg.libXrandr.dev
    xorg.libXft.dev
    xorg.libXi.dev

    # === GUI tools ===
    lxappearance
  ];
}
