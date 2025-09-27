{
  config,
  pkgs,
  ...
}: {
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
    audio.enable = true;
  };
  environment.systemPackages = with pkgs; [
    pavucontrol
    acl
    alsa-utils
    alsa-plugins
    alsa-lib
    pipewire
  ];
}
