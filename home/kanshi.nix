{ config, pkgs, vars, ... }:
{
  services.kanshi = {
    enable = true;
  };

  systemd.user.paths."watcher-kanshi" = {
    Install.WantedBy = [ "graphical-session.target" ];
    Path = {
      PathChanged = "${vars.user.home}/nixos/config/kanshi";
      Unit = "watcher-kanshi.service";
    };
  };
  
  systemd.user.services."watcher-kanshi" = {
    Unit.Description = "Watch kanshi for changes";
    Service = {
      Type = "oneshot";
      ExecStart = ''
        ${pkgs.bash}/bin/bash -c \
	  "/etc/profiles/per-user/${vars.user.name}/bin/kanshictl reload && \
	  /run/current-system/sw/bin/notify-send -u low -t 2000 -i video-display \
	    \"Kanshi\" \
	    \"Reloaded!\""
      ''; 
    };
  };
}
