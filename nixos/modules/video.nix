{
  config,
  pkgs,
  lib,
  ...
}: {
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    mpv
    vlc
    ffmpeg
    imagemagick
  ];
}
