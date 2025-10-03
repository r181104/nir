{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    qbittorent
    miru
  ];
}
