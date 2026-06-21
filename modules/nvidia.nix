{ config, pkgs, lib, vars, ... }:
let
  primeEnabled = config.modules.nvidia.nvidiaBusId != null
    && config.modules.nvidia.amdBusId != null;
in {
  ############ Boilerplate ###########
  #modules.nvidia.nvidiaBusId = ""; #(lspci -D -d ::03xx) OR (lspci | grep ' VGA ') | hexadecimal to decimal
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
    modules.niri.imports = "include \"nvidia.hm.kdl\"";

    home-manager.users."${vars.user.name}" = {
      home.file."nixos/config/niri/nvidia.hm.kdl".text = ''
        environment {
            LIBVA_DRIVER_NAME "nvidia"
            __GLX_VENDOR_LIBRARY_NAME "nvidia"
            NVD_BACKEND "direct"
        } 
      '';
    };

    #boot.kernelParams = [ "nvidia-drm.modeset=1" ]; #suggested by ai, not found anywhere else, didn't change anything when I tried it
    #https://wiki.nixos.org/wiki/NVIDIA
    services.xserver.videoDrivers = [ "nvidia" ];
    hardware.nvidia = {
      open = true;
      modesetting.enable = true; #required for wayland
      package = config.boot.kernelPackages.nvidiaPackages.beta;
      powerManagement.enable = true; #attempt to fix problem with suspend
      nvidiaSettings = true;
      prime = {
        reverseSync.enable = lib.mkIf primeEnabled true; #prioritize dGPU
        nvidiaBusId = lib.mkIf primeEnabled config.modules.nvidia.nvidiaBusId; 
        amdgpuBusId = lib.mkIf primeEnabled config.modules.nvidia.amdBusId; 
      };
    };

    environment.systemPackages = with pkgs; [
      egl-wayland #needed for nvidia
    ];

    environment.etc."nvidia/nvidia-application-profiles-rc.d/50-limit-free-buffer-pool-in-wayland-compositors.json" = {
      text = builtins.toJSON {
        rules = [
	  {
	    pattern = {
	      feature = "procname";
	      matches = "niri";
	    };
	    profile = "Limit Free Buffer Pool On Wayland Compositors";
	  }
        ];
	profiles = [
	  {
	    name = "Limit Free Buffer Pool On Wayland Compositors";
	    settings = [
	      {
	        key = "GLVidHeapReuseRation";
		value = 0;
	      }
	    ];
	  }
	];
      };
      mode = "0664";
    };
  };
}
