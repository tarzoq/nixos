{ config, pkgs, ... }:

{
  #https://wiki.nixos.org/wiki/NVIDIA
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.open = false;
  hardware.nvidia.modesetting.enable = true; #required for wayland
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.beta;
  hardware.nvidia.prime = {
    reverseSync.enable = true;
    nvidiaBusId = "PCI:1@0:0:0"; #lspci -D -d ::03xx
    amdgpuBusId = "PCI:16@0:0:0"; #hexadecimal to decimal
  };
  hardware.nvidia.powerManagement.enable = true; #attempt to fix problem with suspend
}
