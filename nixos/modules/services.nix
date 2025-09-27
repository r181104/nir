{
  config,
  pkgs,
  ...
}: {
  services.xserver.enable = true;
  services.displayManager.ly.enable = true;
  services.displayManager.defaultSession = "none+bspwm";
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
  # services.xserver.desktopManager.budgie.enable = true;
  services.gnome.gnome-keyring.enable = true;
  services.printing.enable = true;
  services.openssh.enable = true;
  services.libinput.enable = true;
  services.udisks2.enable = true;
  services.udev.extraRules = ''
    # Example: Mount USB drives to /media/<label> automatically
        ACTION=="add", SUBSYSTEM=="block", ENV{ID_FS_USAGE}=="filesystem", RUN+="${pkgs.systemd}/bin/systemd-mount --no-block --automount=yes --collect $devnode /media/%E{ID_FS_LABEL}"
    # Allow input group to access input devices
        KERNEL=="event*", NAME="input/%k", MODE="660", GROUP="input"
  '';
}
