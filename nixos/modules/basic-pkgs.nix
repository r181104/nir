{
  config,
  pkgs,
  lib,
  ...
}: {
  # System packages
  environment.systemPackages = with pkgs; [
    # === Essentials ===
    git
    vim
    neovide
    keychain
    xclip
    btop
    htop
    wget
    curl
    fish
    skim
    fd
    zoxide
    tmux
    ripgrep
    bat
    bind
    man
    stow
    eza
    bc
    fastfetch
    unzip
    zip
    gzip
    p7zip
    killall

    # === Network & system utilities ===
    networkmanager
    networkmanagerapplet
    blueman
    brightnessctl
    pcmanfm

    # === Icons ===
    papirus-icon-theme

    # === Terminal emulators ===
    alacritty
    wezterm

    # === Browsers & search ===
    firefox-devedition
    ddgr
    w3m

    # === GTK dependencies ===
    gtk2
    gtk3
    gtk4
    gtk-engine-murrine
    gdk-pixbuf
    pango
    cairo
    shared-mime-info
    hicolor-icon-theme

    # === Polkit agent ===
    polkit_gnome
  ];

  # Enable polkit for GUI privilege prompts
  security.polkit.enable = true;
  # Enable shells
  programs.fish.enable = true;
  # Enable nm-applet
  programs.nm-applet.enable = true;
}
