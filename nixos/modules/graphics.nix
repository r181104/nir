{
  config,
  pkgs,
  lib,
  ...
}: {
  services.xserver.videoDrivers = ["intel" "nvidia"];
  hardware.nvidia = {
    open = false;
    modesetting.enable = true;
    prime = {
      intelBusId = "PCI:0@0:2:0";
      nvidiaBusId = "PCI:1@0:0:0";
      offload.enable = true;
      offload.enableOffloadCmd = true;
    };
    nvidiaSettings = true;
    powerManagement.enable = true;
  };
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      mesa
      vulkan-loader
      vulkan-tools
      vulkan-validation-layers
      vulkan-extension-layer
      libvdpau-va-gl
      vaapi-intel-hybrid
      intel-media-driver
      libva
      libva-utils
    ];
  };
  hardware.cpu.intel.updateMicrocode = true;
  boot.blacklistedKernelModules = ["nouveau"];
  environment.systemPackages = with pkgs; [
    linuxPackages.nvidia_x11
    mesa-demos
    vulkan-tools
    libva-utils
    nvtopPackages.full
  ];
}
