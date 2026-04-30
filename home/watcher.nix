{ config, pkgs, vars, ... }:
{
  ## 1. Define the Path Unit
  systemd.user.paths."watcher-kanshi" = {
    Install.WantedBy = [ "graphical-session.target" ];
    Path = {
      PathChanged = "${vars.user.home}/nixos/config/kanshi"; # Or PathExists, DirectoryNotEmpty, etc.
      Unit = "watcher-kanshi.service"; # The service to activate
    };
  };
  
  #2. Define the corresponding Service
  systemd.user.services."watcher-kanshi" = {
    Unit.Description = "Watch kanshi for changes";
    Service = {
      Type = "oneshot";
      #ExecStart = "${pkgs.bash}/bin/bash -c '/run/current-system/sw/bin/brave' &"; 
      ExecStart = ''${pkgs.bash}/bin/bash -c "/etc/profiles/per-user/${vars.user.name}/bin/kanshictl reload && /run/current-system/sw/bin/noctalia-shell ipc call toast send '{\"title\": \"Kanshi\", \"body\": \"Reloaded!\", \"duration\": 2000}'" ''; 
      #ExecStart = "${pkgs.bash}/bin/bash -c '/etc/profiles/per-user/${vars.user.name}/bin/kanshictl reload && /run/current-system/sw/bin/notify-send \"Kanshi\" \"Reload Done!\"'"; 
    };
    #environment.DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/1000/bus";
    #unitConfig = {
    #  StartLimitBurst = 10;
    #  StartLimitIntervalSec = 60;
    #};
  };
}
