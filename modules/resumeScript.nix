{ config, lib, ... }:
{
  ########## Boilerplate ###########
  #modules.resume.downScript = "";
  #modules.resume.resumeScript = "";
  ###################################

  options.modules.resume = {
    downScript = lib.mkOption {
      type = lib.types.nullOr lib.types.lines;
      default = null;
      description = "Custom commands to execute before going down";
    };
    resumeScript = lib.mkOption {
      type = lib.types.nullOr lib.types.lines;
      default = null;
      description = "Custom commands to execute on resume";
    };
  };
  config = let
    cfg = config.modules.resume;
    hasDownScript = cfg.downScript != null;
    hasResumeScript = cfg.resumeScript != null;
  in {
    systemd.services.script-down = lib.mkIf hasDownScript {
      description = "Custom commands to execute before going down";
      before = [ "suspend.target" "hibernate.target" "hybrid-sleep.target" ];
      wantedBy = [ "suspend.target" "hibernate.target" "hybrid-sleep.target" ];
      script = ''
	${cfg.downScript}
      '';
      serviceConfig.Type = "oneshot";
    };
    systemd.services.script-resume = lib.mkIf hasResumeScript {
      description = "Custom commands to execute on resume";
      after = [ "suspend.target" "hibernate.target" "hybrid-sleep.target" ];
      wantedBy = [ "suspend.target" "hibernate.target" "hybrid-sleep.target" ];
      script = ''
        sleep 3
	${cfg.resumeScript}
      '';
      serviceConfig.Type = "oneshot";
    };
  };
}
