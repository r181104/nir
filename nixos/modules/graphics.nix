{
  config,
  pkgs,
  lib,
  ...
}: {
  hardware.nvidia.prime = {
    intelBusId = "PCI:0@0:2:0";
    nvidiaBusId = "PCI:1@0:0:0";
    offload.enable = true;
    offload.enableOffloadCmd = true;
  };
  hardware.nvidia = {
    open = false;
    nvidiaSettings = true;
    modesetting.enable = true;
    forceFullCompositionPipeline = true;
  };
  boot.extraModulePackages = [config.boot.kernelPackages.nvidia_x11];
  boot.blacklistedKernelModules = ["nouveau" "nvidia_drm" "nvidia_modeset" "nvidia"];
  environment.systemPackages = [pkgs.linuxPackages.nvidia_x11];
}
