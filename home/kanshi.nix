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
        ${pkgs.bash}/bin/bash -c "/etc/profiles/per-user/${vars.user.name}/bin/kanshictl reload && /run/current-system/sw/bin/noctalia-shell ipc call toast send '{\"title\": \"Kanshi\", \"body\": \"Reloaded!\", \"duration\": 2000}'"
      ''; 
    };
  };
}
