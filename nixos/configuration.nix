{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    /etc/nixos/hardware-configuration.nix
    ./modules/basic-pkgs.nix
    ./modules/services.nix
    ./modules/security.nix
    ./modules/audio.nix
    ./modules/video.nix
    ./modules/dev.nix
    ./modules/windowmanager.nix
    ./modules/graphics.nix
    ./modules/gaming.nix
    ./modules/auto-upgrade.nix
    ./modules/xmonad.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.efi.canTouchEfiVariables = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
  nix.settings.auto-optimise-store = true;

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [80 443 2222];
    };
  };
  hardware.bluetooth.enable = true;

  users.defaultUserShell = pkgs.bash;
  users.users.sten = {
    isNormalUser = true;
    shell = pkgs.fish;
    description = "sten";
    extraGroups = ["networkmanager" "wheel" "input"];
    packages = with pkgs; [
      fish
      zsh
      tree
    ];
  };

  console = {
    font = "solar24x32";
    useXkbConfig = true;
  };

  environment.shells = with pkgs; [bash fish];

  nixpkgs.config.allowUnfree = true;
  hardware.enableRedistributableFirmware = true;

  time.timeZone = "Asia/Kolkata";
  i18n.defaultLocale = "en_IN";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IN";
    LC_IDENTIFICATION = "en_IN";
    LC_MEASUREMENT = "en_IN";
    LC_MONETARY = "en_IN";
    LC_NAME = "en_IN";
    LC_NUMERIC = "en_IN";
    LC_PAPER = "en_IN";
    LC_TELEPHONE = "en_IN";
    LC_TIME = "en_IN";
    LC_ALL = "en_IN";
  };

  system.stateVersion = "25.05";
  nix.settings.experimental-features = ["nix-command" "flakes"];
}
