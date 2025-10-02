{
  config,
  pkgs,
  ...
}: {
  services.xserver.enable = true;
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
    open = false;
    modesetting.enable = true;
    powerManagement.enable = true;
    nvidiaSettings = true;
    prime = {
      offload.enable = true;
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      mesa
      mesa-demos
      vulkan-loader
      vulkan-tools
      vulkan-validation-layers
      vulkan-extension-layer
      libvdpau-va-gl
      intel-media-driver
      libva
      libva-utils
    ];
  };

  environment.systemPackages = with pkgs; [
    (pkgs.writeShellScriptBin "nvidia-run" ''
      #!/bin/sh
      export __NV_PRIME_RENDER_OFFLOAD=1
      export __GLX_VENDOR_LIBRARY_NAME=nvidia
      export __VK_LAYER_NV_optimus=NVIDIA_only
      exec "$@"
    '')
  ];

  boot.blacklistedKernelModules = ["nouveau" "nvidiafb"];
}
