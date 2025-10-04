{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    qbittorrent
    gemini-cli
  ];
}
