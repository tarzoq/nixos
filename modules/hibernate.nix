{ config, lib, ... }:
{
  ########## Boilerplate ###########
  #modules.hibernate.resumeOffset = ;
  #modules.hibernate.diskUuid = "";
  #modules.hibernate.ramGb = ;
  #modules.hibernate.hibernateScript = "";
  #modules.hibernate.resumeScript = "";
  ###################################

  options.modules.hibernate = {
    resumeOffset = lib.mkOption {
      type = lib.types.int;
      default = null;
    };
    diskUuid = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
    };
    ramGb = lib.mkOption {
      type = lib.types.int;
      default = 16;
    };
    hibernateScript = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Custom commands to execute before hibernate";
    };
    resumeScript = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Custom commands to execute on startup after hibernate";
    };
  };
  config = let
    cfg = config.modules.hibernate;
    hasSwap = cfg.resumeOffset != null && cfg.diskUuid != null;
    hasSystemdScripts = cfg.hibernateScript != null && cfg.resumeScript != null;
  in {
    boot.kernelParams = lib.mkIf hasSwap [ "resume_offset=${toString cfg.resumeOffset}" ]; # sudo filefrag -v /var/lib/swapfile | head

    boot.resumeDevice = lib.mkIf hasSwap "/dev/disk/by-uuid/${toString cfg.diskUuid}"; # lsblk -f
    
    systemd.services.script-before-hibernate = lib.mkIf hasSystemdScripts {
      description = "Custom commands to execute before hibernate";
      before = [ "systemd-hibernate.service" ];
      wantedBy = [ "systemd-hibernate.service" ];
      script = ''
	${cfg.hibernateScript}
        systemctl stop NetworkManager
      '';
      serviceConfig.Type = "oneshot";
    };
    # lspci -k | grep -A3 -i network
    systemd.services.script-after-hibernate = lib.mkIf hasSystemdScripts {
      description = "Custom commands to execute on startup after hibernate";
      after = [ "post-resume.service" ];
      wantedBy = [ "post-resume.service" ];
      script = ''
        sleep 3
	${cfg.resumeScript}
        systemctl restart NetworkManager
      '';
      serviceConfig.Type = "oneshot";
    };

    swapDevices = [ # https://nixos.wiki/wiki/Hibernation
      {
        device = "/var/lib/swapfile";
        size = builtins.floor ((cfg.ramGb * 1024) * 1.1); #current memory * 1.1 (rounded) in GB
      }
    ];
  };
}
