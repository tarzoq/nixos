{ config, pkgs, lib, ... }:
let
  primeEnabled = config.modules.nvidia.nvidiaBusId != null
    && config.modules.nvidia.amdBusId != null;
in {
  ############ Boilerplate ###########
  #modules.nvidia.nvidiaBusId = ""; #lspci -D -d ::03xx | hexadecimal to decimal
  #modules.nvidia.amdBusId = ""; #prime is disabled if not specified
  ######################################

  options.modules.nvidia = {
    nvidiaBusId = lib.mkOption { #Nvidia
      type = lib.types.nullOr lib.types.str;
      default = null;
    };
    amdBusId = lib.mkOption { #AMD iGPU
      type = lib.types.nullOr lib.types.str;
      default = null;
    };
  };

  config = { #required when options {} is used
    #boot.kernelParams = [ "nvidia-drm.modeset=1" ]; #suggested by ai, not found anywhere else, didn't change anything when I tried it
    #https://wiki.nixos.org/wiki/NVIDIA
    services.xserver.videoDrivers = [ "nvidia" ];
    hardware.nvidia.open = false;
    hardware.nvidia.modesetting.enable = true; #required for wayland
    hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.beta;
    hardware.nvidia.prime = {
      reverseSync.enable = lib.mkIf primeEnabled true; #prioritize dGPU
      nvidiaBusId = lib.mkIf primeEnabled config.modules.nvidia.nvidiaBusId; 
      amdgpuBusId = lib.mkIf primeEnabled config.modules.nvidia.amdBusId; 
    };

    hardware.nvidia.powerManagement.enable = true; #attempt to fix problem with suspend

    environment.systemPackages = with pkgs; [
      egl-wayland #needed for nvidia
    ];
  };
}
