{
  config,
  pkgs,
  ...
}: {
  programs.steam.enable = true;
  programs.steam.remotePlay.openFirewall = true;
  programs.steam.dedicatedServer.openFirewall = true;
  programs.steam.gamescopeSession.enable = true;
  environment.systemPackages = with pkgs; [
    itch # Indie game launcher
    protonup-ng # Handy for installing Proton-GE (community builds)
    mangohud
    gamemode
  ];
}
