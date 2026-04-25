{ config, lib, ... }:
{
  ########## Boilerplate ###########
  #modules.hibernate.resumeOffset = ; #sudo filefrag -v /var/lib/swapfile | head
  #modules.hibernate.diskUuid = ""; #lsblk -f
  #modules.hibernate.ramGb = ;
  #modules.hibernate.hibernateScript = ""; # lspci -k | grep -A3 -i network
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
    boot.kernelParams = lib.mkIf hasSwap [ "resume_offset=${toString cfg.resumeOffset}" ]; 
    boot.resumeDevice = lib.mkIf hasSwap "/dev/disk/by-uuid/${toString cfg.diskUuid}";
    
    systemd.services.script-before-hibernate = lib.mkIf hasSystemdScripts {
      description = "Custom commands to execute before hibernate";
      before = [ "systemd-hibernate.service" ];
      wantedBy = [ "systemd-hibernate.service" ];
      script = ''
	${cfg.hibernateScript}
        /run/current-system/sw/bin/systemctl stop NetworkManager
      '';
      serviceConfig.Type = "oneshot";
    };

    systemd.services.script-after-hibernate = lib.mkIf hasSystemdScripts {
      description = "Custom commands to execute on startup after hibernate";
      after = [ "systemd-hibernate.service" ];
      wantedBy = [ "systemd-hibernate.service" ];
      script = ''
        /run/current-system/sw/bin/sleep 3
	${cfg.resumeScript}
        /run/current-system/sw/bin/systemctl restart NetworkManager
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
